//
//  ConnectorPracticeViewModel.swift
//  English along with John - Presentation / Connectors
//

import Foundation
import Observation

/// ViewModel para a tela de prática ativa de conectivos.
/// Controla o timer regressivo de 18s (Arcade), vidas, pontuação e transição de questões.
@Observable
@MainActor
public final class ConnectorPracticeViewModel {

    // MARK: - Estado da Sessão
    public private(set) var session: ConnectorSession
    public private(set) var selectedOptionId: String? = nil
    public private(set) var evaluationResult: AnswerEvaluationResult? = nil
    public private(set) var isAnswered: Bool = false
    public private(set) var secondsLeft: Int = 18
    public private(set) var isMastered: Bool = false

    // MARK: - Dependências & Concorrência
    private let validateAnswerUseCase: any ValidateConnectorAnswerUseCaseProtocol
    private let repository: any ConnectorsRepositoryProtocol
    private var timerTask: Task<Void, Never>? = nil

    public init(
        session: ConnectorSession,
        validateAnswerUseCase: any ValidateConnectorAnswerUseCaseProtocol = ValidateConnectorAnswerUseCase(),
        repository: any ConnectorsRepositoryProtocol
    ) {
        self.session = session
        self.validateAnswerUseCase = validateAnswerUseCase
        self.repository = repository
    }

    public func onAppear() {
        startQuestionTimerIfNeeded()
        Task { await checkCurrentMastery() }
    }

    public func onDisappear() {
        stopTimer()
    }

    // MARK: - Controle do Timer Arcade (18 Segundos)
    private func startQuestionTimerIfNeeded() {
        guard session.mode == .arcade, !isAnswered else { return }

        secondsLeft = 18
        stopTimer()

        timerTask = Task { @MainActor in
            while secondsLeft > 0 && !isAnswered && !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
                if Task.isCancelled || isAnswered { break }
                secondsLeft -= 1
            }

            if secondsLeft <= 0 && !isAnswered {
                handleTimeout()
            }
        }
    }

    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    private func handleTimeout() {
        selectOption(nil, timedOut: true)
    }

    // MARK: - Ações de Resposta
    public func selectOption(_ optionId: String?, timedOut: Bool = false) {
        guard !isAnswered else { return }
        stopTimer()

        self.selectedOptionId = optionId
        self.isAnswered = true

        let result = validateAnswerUseCase.execute(
            session: session,
            selectedOptionId: optionId,
            timedOut: timedOut,
            secondsLeft: secondsLeft
        )

        self.evaluationResult = result
        self.session = result.updatedSession

        // Se acertou, salva pontuação automaticamente
        if session.isGameOver {
            Task {
                try? await repository.saveSessionScore(
                    score: session.score,
                    bestStreak: session.bestStreak,
                    mode: session.mode
                )
            }
        }
    }

    // MARK: - Avançar para a Próxima Questão
    public func nextQuestion() {
        guard session.currentIndex + 1 < session.exercises.count else { return }

        session.currentIndex += 1
        isAnswered = false
        selectedOptionId = nil
        evaluationResult = nil

        Task { await checkCurrentMastery() }
        startQuestionTimerIfNeeded()
    }

    // MARK: - Alternar Status de Domínio
    public func toggleMastery() async {
        guard let current = session.currentExercise else { return }
        do {
            let nextState = try await repository.toggleMasteredId(current.connectorId)
            self.isMastered = nextState
        } catch {
            // Silencioso
        }
    }

    private func checkCurrentMastery() async {
        guard let current = session.currentExercise else { return }
        if let mastered = try? await repository.getMasteredIds() {
            self.isMastered = mastered.contains(current.connectorId)
        }
    }
}

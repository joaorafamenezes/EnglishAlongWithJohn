//
//  TodayLessonViewModel.swift
//  English along with John - Presentation Layer
//

import Foundation
import Observation

/// ViewModel para a tela da Lição do Dia com o professor John.
/// Utiliza a macro `@Observable` e isolamento estrito no `@MainActor`.
@Observable
@MainActor
public final class TodayLessonViewModel {

    // MARK: - Estados de Apresentação
    public enum ViewState: Equatable {
        case idle
        case loading
        case loaded(Lesson)
        case error(message: String)
    }

    // MARK: - Propriedades Observáveis
    public private(set) var state: ViewState = .idle
    public private(set) var isPlayingAudio: Bool = false
    public private(set) var currentAudioTime: Double = 0.0

    // MARK: - Dependências Injetadas
    private let fetchTodayLessonUseCase: any FetchTodayLessonUseCaseProtocol
    private weak var coordinator: (any AppCoordinatorProtocol)?

    public init(
        fetchTodayLessonUseCase: any FetchTodayLessonUseCaseProtocol,
        coordinator: (any AppCoordinatorProtocol)? = nil
    ) {
        self.fetchTodayLessonUseCase = fetchTodayLessonUseCase
        self.coordinator = coordinator
    }

    // MARK: - Ações do Usuário / Intenções de Negócio

    /// Carrega a aula do dia chamando o caso de uso assíncrono.
    public func onAppear() async {
        guard case .idle = state else { return }
        await loadLesson()
    }

    /// Recarrega forçadamente a aula (ex.: Pull to Refresh ou Retry button).
    public func retryLoading() async {
        await loadLesson()
    }

    private func loadLesson() async {
        state = .loading
        do {
            let lesson = try await fetchTodayLessonUseCase.execute()
            state = .loaded(lesson)
        } catch let error as LocalizedError {
            state = .error(message: error.errorDescription ?? "Ocorreu um erro ao carregar a lição.")
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    /// Alterna o estado do player de áudio com a voz do professor John.
    public func toggleAudioPlayback() {
        isPlayingAudio.toggle()
        // No player real, integra com AVAudioSession e SystemAudioPlayer
    }

    /// Dispara o fluxo de exercícios práticos via Coordinator.
    public func didTapStartExercises(lesson: Lesson) {
        coordinator?.navigate(to: .exerciseSession(lessonId: lesson.id))
    }

    /// Dispara a navegação para o Laboratório de Conectivos (English Connectors Hub).
    public func didTapConnectorsHub() {
        coordinator?.navigate(to: .connectorsHub)
    }

    /// Dispara a navegação para o menu do jogo de Phrasal Verbs.
    public func didTapPhrasalVerbsHub() {
        coordinator?.navigate(to: .phrasalVerbsHub)
    }

    /// Dispara a navegação para o menu da Família -Ever & Whereas.
    public func didTapEverFamilyHub() {
        coordinator?.navigate(to: .everFamilyHub)
    }

    /// Dispara a navegação para o menu de Expressões Idiomáticas.
    public func didTapIdiomaticExpressionsHub() {
        coordinator?.navigate(to: .idiomaticExpressionsHub)
    }
}

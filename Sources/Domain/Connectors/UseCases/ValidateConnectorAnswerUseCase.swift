//
//  ValidateConnectorAnswerUseCase.swift
//  English along with John - Domain / Connectors
//

import Foundation

public protocol ValidateConnectorAnswerUseCaseProtocol: Sendable {
    func execute(
        session: ConnectorSession,
        selectedOptionId: String?,
        timedOut: Bool,
        secondsLeft: Int
    ) -> AnswerEvaluationResult
}

public final class ValidateConnectorAnswerUseCase: ValidateConnectorAnswerUseCaseProtocol {
    private let basePoints: Int = 100
    private let streakCap: Int = 5

    public init() {}

    public func execute(
        session: ConnectorSession,
        selectedOptionId: String?,
        timedOut: Bool,
        secondsLeft: Int
    ) -> AnswerEvaluationResult {
        var updatedSession = session
        guard let currentExercise = updatedSession.currentExercise else {
            fatalError("Não há exercício ativo na sessão.")
        }

        let isCorrect = !timedOut && currentExercise.isCorrect(optionId: selectedOptionId)

        var pointsEarned = 0
        var timeBonus = 0
        var calculatedBasePoints = 0
        var streakMultiplier = 1

        if isCorrect {
            updatedSession.streak += 1
            updatedSession.bestStreak = max(updatedSession.bestStreak, updatedSession.streak)
            streakMultiplier = min(updatedSession.streak, streakCap)
            calculatedBasePoints = basePoints * streakMultiplier

            // No modo Arcade, adiciona bônus de agilidade de 5 pontos por segundo restante (até 18s)
            if updatedSession.mode == .arcade {
                let clampedSeconds = max(0, min(18, secondsLeft))
                timeBonus = clampedSeconds * 5
            }

            pointsEarned = calculatedBasePoints + timeBonus
            updatedSession.score += pointsEarned
        } else {
            updatedSession.streak = 0
            // No modo Arcade perde 1 vida. No modo Zen as vidas são preservadas para aprendizado tranquilo.
            if updatedSession.mode == .arcade {
                updatedSession.lives -= 1
            }
        }

        // Registra o histórico da resposta
        let answerRecord = ConnectorAnswerRecord(
            exerciseId: currentExercise.id,
            selectedOptionId: selectedOptionId,
            isCorrect: isCorrect,
            timedOut: timedOut,
            pointsEarned: pointsEarned
        )
        updatedSession.answers.append(answerRecord)

        // Verifica status da sessão
        let hasMoreQuestions = updatedSession.currentIndex + 1 < updatedSession.exercises.count

        if updatedSession.mode == .arcade && updatedSession.lives <= 0 {
            updatedSession.status = .lost
        } else if !hasMoreQuestions {
            updatedSession.status = .won
        }

        return AnswerEvaluationResult(
            exercise: currentExercise,
            isCorrect: isCorrect,
            timedOut: timedOut,
            selectedOptionId: selectedOptionId,
            pointsEarned: pointsEarned,
            timeBonus: timeBonus,
            basePoints: calculatedBasePoints,
            streakMultiplier: streakMultiplier,
            updatedSession: updatedSession
        )
    }
}

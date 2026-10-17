//
//  ValidateConnectorAnswerUseCaseTests.swift
//  English along with John - Tests / Connectors
//

import Testing
import Foundation

@Suite("Suíte de Testes: ValidateConnectorAnswerUseCase")
struct ValidateConnectorAnswerUseCaseTests {

    private func makeSampleExercise(correctOptionId: String = "a") -> ConnectorExercise {
        ConnectorExercise(
            id: "q-test-1",
            prompt: "_____ the release was tight, we delivered zero bugs.",
            options: [
                ConnectorExerciseOption(id: "a", text: "Although"),
                ConnectorExerciseOption(id: "b", text: "Despite"),
                ConnectorExerciseOption(id: "c", text: "Because"),
                ConnectorExerciseOption(id: "d", text: "So")
            ],
            correctOptionId: correctOptionId,
            connectorId: "although",
            connectorTerm: "Although",
            family: .contrast,
            translation: "Embora",
            explanation: "Explicação sintática",
            fullSentence: "Although the release was tight...",
            sentenceTranslation: "Embora o prazo...",
            whyCorrect: "Por causa do sujeito e verbo",
            whyOthersFail: "As outras opções exigem substantivo",
            proTip: "Dica do John"
        )
    }

    @Test("Modo Arcade: Resposta correta com bônus de agilidade e multiplicador de streak")
    func testArcadeCorrectAnswerScoringWithStreakAndTimeBonus() {
        // Arrange
        let exercise = makeSampleExercise()
        var session = ConnectorSession(
            mode: .arcade,
            lives: 3,
            maxLives: 3,
            score: 0,
            streak: 2, // já tem 2 acertos, este será o 3º acerto (multiplicador x3)
            exercises: [exercise, exercise]
        )
        let sut = ValidateConnectorAnswerUseCase()

        // Act (respondeu correto faltando 10 segundos)
        let result = sut.execute(
            session: session,
            selectedOptionId: "a",
            timedOut: false,
            secondsLeft: 10
        )

        // Assert
        #expect(result.isCorrect)
        #expect(result.streakMultiplier == 3)
        #expect(result.basePoints == 300) // 100 * 3
        #expect(result.timeBonus == 50)   // 10s * 5
        #expect(result.pointsEarned == 350)
        #expect(result.updatedSession.score == 350)
        #expect(result.updatedSession.streak == 3)
        #expect(result.updatedSession.lives == 3) // vidas intactas
    }

    @Test("Modo Arcade: Resposta incorreta perde 1 vida e zera o streak")
    func testArcadeWrongAnswerLosesLifeAndResetsStreak() {
        // Arrange
        let exercise = makeSampleExercise()
        let session = ConnectorSession(
            mode: .arcade,
            lives: 3,
            maxLives: 3,
            score: 500,
            streak: 4,
            exercises: [exercise, exercise]
        )
        let sut = ValidateConnectorAnswerUseCase()

        // Act
        let result = sut.execute(
            session: session,
            selectedOptionId: "b", // Errado (correto é 'a')
            timedOut: false,
            secondsLeft: 12
        )

        // Assert
        #expect(!result.isCorrect)
        #expect(result.pointsEarned == 0)
        #expect(result.updatedSession.lives == 2)
        #expect(result.updatedSession.streak == 0)
    }

    @Test("Modo Arcade: Timeout após 18s perde vida e encerra o jogo ao esgotar as vidas")
    func testArcadeTimeoutLosesLastLifeAndTriggersGameOver() {
        // Arrange
        let exercise = makeSampleExercise()
        let session = ConnectorSession(
            mode: .arcade,
            lives: 1, // Última vida
            maxLives: 3,
            exercises: [exercise, exercise]
        )
        let sut = ValidateConnectorAnswerUseCase()

        // Act
        let result = sut.execute(
            session: session,
            selectedOptionId: nil,
            timedOut: true,
            secondsLeft: 0
        )

        // Assert
        #expect(result.timedOut)
        #expect(!result.isCorrect)
        #expect(result.updatedSession.lives == 0)
        #expect(result.updatedSession.status == .lost)
    }

    @Test("Modo Zen: Resposta incorreta zera o streak mas preserva as vidas")
    func testZenModePreservesLivesOnMistake() {
        // Arrange
        let exercise = makeSampleExercise()
        let session = ConnectorSession(
            mode: .zen,
            lives: 99,
            maxLives: 99,
            streak: 3,
            exercises: [exercise]
        )
        let sut = ValidateConnectorAnswerUseCase()

        // Act
        let result = sut.execute(
            session: session,
            selectedOptionId: "c",
            timedOut: false,
            secondsLeft: 0
        )

        // Assert
        #expect(!result.isCorrect)
        #expect(result.updatedSession.lives == 99)
        #expect(result.updatedSession.streak == 0)
        #expect(result.updatedSession.status == .won) // Completou a lista sem perder por vidas
    }
}

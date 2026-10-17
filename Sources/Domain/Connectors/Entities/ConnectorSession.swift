//
//  ConnectorSession.swift
//  English along with John - Domain / Connectors
//

import Foundation

public enum SessionStatus: String, Codable, Sendable {
    case playing
    case won
    case lost
}

public struct ConnectorAnswerRecord: Sendable, Equatable {
    public let exerciseId: String
    public let selectedOptionId: String?
    public let isCorrect: Bool
    public let timedOut: Bool
    public let pointsEarned: Int

    public init(
        exerciseId: String,
        selectedOptionId: String?,
        isCorrect: Bool,
        timedOut: Bool,
        pointsEarned: Int
    ) {
        self.exerciseId = exerciseId
        self.selectedOptionId = selectedOptionId
        self.isCorrect = isCorrect
        self.timedOut = timedOut
        self.pointsEarned = pointsEarned
    }
}

/// Entidade que encapsula o estado de uma sessão de estudo ou desafio arcade.
public struct ConnectorSession: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let mode: GameMode
    public var lives: Int
    public let maxLives: Int
    public var score: Int
    public var streak: Int
    public var bestStreak: Int
    public var status: SessionStatus
    public var currentIndex: Int
    public let exercises: [ConnectorExercise]
    public var answers: [ConnectorAnswerRecord]

    public init(
        id: UUID = UUID(),
        mode: GameMode,
        lives: Int,
        maxLives: Int,
        score: Int = 0,
        streak: Int = 0,
        bestStreak: Int = 0,
        status: SessionStatus = .playing,
        currentIndex: Int = 0,
        exercises: [ConnectorExercise],
        answers: [ConnectorAnswerRecord] = []
    ) {
        self.id = id
        self.mode = mode
        self.lives = lives
        self.maxLives = maxLives
        self.score = score
        self.streak = streak
        self.bestStreak = bestStreak
        self.status = status
        self.currentIndex = currentIndex
        self.exercises = exercises
        self.answers = answers
    }

    public var currentExercise: ConnectorExercise? {
        guard currentIndex >= 0 && currentIndex < exercises.count else { return nil }
        return exercises[currentIndex]
    }

    public var totalCount: Int {
        exercises.count
    }

    public var isGameOver: Bool {
        status == .won || status == .lost
    }
}

/// Objeto de resultado da validação de uma resposta.
public struct AnswerEvaluationResult: Sendable, Equatable {
    public let exercise: ConnectorExercise
    public let isCorrect: Bool
    public let timedOut: Bool
    public let selectedOptionId: String?
    public let pointsEarned: Int
    public let timeBonus: Int
    public let basePoints: Int
    public let streakMultiplier: Int
    public let updatedSession: ConnectorSession

    public init(
        exercise: ConnectorExercise,
        isCorrect: Bool,
        timedOut: Bool,
        selectedOptionId: String?,
        pointsEarned: Int,
        timeBonus: Int,
        basePoints: Int,
        streakMultiplier: Int,
        updatedSession: ConnectorSession
    ) {
        self.exercise = exercise
        self.isCorrect = isCorrect
        self.timedOut = timedOut
        self.selectedOptionId = selectedOptionId
        self.pointsEarned = pointsEarned
        self.timeBonus = timeBonus
        self.basePoints = basePoints
        self.streakMultiplier = streakMultiplier
        self.updatedSession = updatedSession
    }
}

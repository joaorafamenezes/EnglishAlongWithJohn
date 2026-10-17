//
//  FetchConnectorsSessionUseCase.swift
//  English along with John - Domain / Connectors
//

import Foundation

public protocol FetchConnectorsSessionUseCaseProtocol: Sendable {
    func execute(config: SessionConfig) async throws -> ConnectorSession
}

public final class FetchConnectorsSessionUseCase: FetchConnectorsSessionUseCaseProtocol {
    private let repository: any ConnectorsRepositoryProtocol

    public init(repository: any ConnectorsRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(config: SessionConfig) async throws -> ConnectorSession {
        let exercises = try await repository.fetchExercises(config: config)

        guard !exercises.isEmpty else {
            if config.hideMastered {
                throw ConnectorsDomainError.allItemsMastered
            } else {
                throw ConnectorsDomainError.emptyExercisePool
            }
        }

        let maxLives = config.mode == .zen ? 99 : 3

        return ConnectorSession(
            mode: config.mode,
            lives: maxLives,
            maxLives: maxLives,
            score: 0,
            streak: 0,
            bestStreak: 0,
            status: .playing,
            currentIndex: 0,
            exercises: exercises,
            answers: []
        )
    }
}

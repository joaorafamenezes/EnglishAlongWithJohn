//
//  FetchConnectorsSessionUseCaseTests.swift
//  English along with John - Tests / Connectors
//

import Testing
import Foundation
@testable import EnglishAlongWithJohn

@Suite("Suíte de Testes: FetchConnectorsSessionUseCase")
struct FetchConnectorsSessionUseCaseTests {

    private final class MockConnectorsRepository: ConnectorsRepositoryProtocol, @unchecked Sendable {
        var stubbedExercises: [ConnectorExercise] = []
        var masteredIds: Set<String> = []

        func fetchCatalog() async throws -> [Connector] { [] }

        func fetchExercises(config: SessionConfig) async throws -> [ConnectorExercise] {
            var pool = stubbedExercises
            if config.hideMastered {
                pool = pool.filter { !masteredIds.contains($0.connectorId) }
            }
            return Array(pool.prefix(config.questionCount))
        }

        func fetchEverFamilyGuide() async -> [EverFamilyItem] { [] }
        func getMasteredIds() async throws -> Set<String> { masteredIds }
        func toggleMasteredId(_ id: String) async throws -> Bool { true }
        func saveSessionScore(score: Int, bestStreak: Int, mode: GameMode) async throws {}
    }

    private func makeExercise(id: String, connectorId: String) -> ConnectorExercise {
        ConnectorExercise(
            id: id,
            prompt: "Test prompt _____ test.",
            options: [ConnectorExerciseOption(id: "a", text: "opt")],
            correctOptionId: "a",
            connectorId: connectorId,
            connectorTerm: connectorId,
            family: .contrast,
            translation: "trans",
            explanation: "exp",
            fullSentence: "full",
            sentenceTranslation: "full_trans",
            whyCorrect: "why",
            whyOthersFail: "fail",
            proTip: "tip"
        )
    }

    @Test("Deve preparar a sessão com quantidade solicitada e vidas adequadas ao modo")
    func testFetchSessionSetup() async throws {
        // Arrange
        let mockRepo = MockConnectorsRepository()
        mockRepo.stubbedExercises = [
            makeExercise(id: "1", connectorId: "c1"),
            makeExercise(id: "2", connectorId: "c2"),
            makeExercise(id: "3", connectorId: "c3")
        ]
        let sut = FetchConnectorsSessionUseCase(repository: mockRepo)
        let config = SessionConfig(mode: .arcade, questionCount: 2)

        // Act
        let session = try await sut.execute(config: config)

        // Assert
        #expect(session.mode == .arcade)
        #expect(session.lives == 3)
        #expect(session.exercises.count == 2)
        #expect(session.status == .playing)
    }

    @Test("Deve filtrar itens dominados quando hideMastered estiver ativado")
    func testHideMasteredFiltersOutDominantConnectors() async throws {
        // Arrange
        let mockRepo = MockConnectorsRepository()
        mockRepo.masteredIds = ["c1"] // c1 está dominado
        mockRepo.stubbedExercises = [
            makeExercise(id: "1", connectorId: "c1"),
            makeExercise(id: "2", connectorId: "c2")
        ]
        let sut = FetchConnectorsSessionUseCase(repository: mockRepo)
        let config = SessionConfig(mode: .zen, questionCount: 10, hideMastered: true)

        // Act
        let session = try await sut.execute(config: config)

        // Assert
        #expect(session.exercises.count == 1)
        #expect(session.exercises.first?.connectorId == "c2")
    }

    @Test("Deve lançar erro allItemsMastered caso todos os itens da seleção estejam dominados")
    func testThrowsWhenAllItemsAreMastered() async {
        // Arrange
        let mockRepo = MockConnectorsRepository()
        mockRepo.masteredIds = ["c1"]
        mockRepo.stubbedExercises = [
            makeExercise(id: "1", connectorId: "c1")
        ]
        let sut = FetchConnectorsSessionUseCase(repository: mockRepo)
        let config = SessionConfig(mode: .zen, questionCount: 10, hideMastered: true)

        // Act & Assert
        await #expect(throws: ConnectorsDomainError.allItemsMastered) {
            _ = try await sut.execute(config: config)
        }
    }
}

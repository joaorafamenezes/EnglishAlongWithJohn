//
//  FetchTodayLessonUseCaseTests.swift
//  English along with John - Tests / UnitTests
//

import Testing
import Foundation
@testable import EnglishAlongWithJohn

@Suite("Suíte de Testes: FetchTodayLessonUseCase")
struct FetchTodayLessonUseCaseTests {

    @Test("Deve retornar a lição de hoje com sucesso quando o repositório responder corretamente")
    func testFetchTodayLessonSuccess() async throws {
        // Arrange (Given)
        let expectedLesson = MockLessonRepository.sampleLesson
        let mockRepository = MockLessonRepository(stubbedLesson: expectedLesson)
        let sut = FetchTodayLessonUseCase(repository: mockRepository)

        // Act (When)
        let resultLesson = try await sut.execute()

        // Assert (Then)
        #expect(resultLesson.id == expectedLesson.id)
        #expect(resultLesson.title == expectedLesson.title)
        #expect(resultLesson.exercises.count == 2)
        #expect(mockRepository.fetchTodayLessonCallCount == 1)
    }

    @Test("Deve propagar erro de conectividade quando a rede estiver indisponível")
    func testFetchTodayLessonNetworkFailure() async {
        // Arrange (Given)
        let mockRepository = MockLessonRepository(shouldThrowError: LessonDomainError.networkUnavailable)
        let sut = FetchTodayLessonUseCase(repository: mockRepository)

        // Act & Assert (When / Then)
        await #expect(throws: LessonDomainError.networkUnavailable) {
            _ = try await sut.execute()
        }
    }

    @Test("Deve encapsular erros genéricos em LessonDomainError.unknown")
    func testFetchTodayLessonGenericFailure() async {
        // Arrange (Given)
        struct ArbitraryError: Error, LocalizedError {
            var errorDescription: String? { "Disk write failure" }
        }
        let mockRepository = MockLessonRepository(shouldThrowError: ArbitraryError())
        let sut = FetchTodayLessonUseCase(repository: mockRepository)

        // Act & Assert (When / Then)
        do {
            _ = try await sut.execute()
            Issue.record("Deveria ter lançado um erro, mas completou com sucesso.")
        } catch let domainError as LessonDomainError {
            #expect(domainError == .unknown(message: "Disk write failure"))
        } catch {
            Issue.record("Erro lançado não foi convertido para LessonDomainError: \(error)")
        }
    }
}

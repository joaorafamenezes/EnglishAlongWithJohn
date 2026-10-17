//
//  FetchTodayLessonUseCase.swift
//  English along with John - Domain Layer
//

import Foundation

/// Caso de Uso de Responsabilidade Única (SRP):
/// Orquestra as regras de negócio para carregar e preparar a lição do dia do aluno.
public final class FetchTodayLessonUseCase: FetchTodayLessonUseCaseProtocol {
    private let repository: any LessonRepositoryProtocol

    public init(repository: any LessonRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> Lesson {
        // Regra de negócio: recuperar lição do dia via repositório resiliente
        do {
            let lesson = try await repository.fetchTodayLesson()
            return lesson
        } catch let domainError as LessonDomainError {
            throw domainError
        } catch {
            throw LessonDomainError.unknown(message: error.localizedDescription)
        }
    }
}

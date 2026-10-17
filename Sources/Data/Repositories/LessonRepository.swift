//
//  LessonRepository.swift
//  English along with John - Data Layer
//

import Foundation

/// Protocolo para abstrair a persistência local (SwiftData/CoreData/Keychain/Disk).
public protocol LessonLocalDataSourceProtocol: Sendable {
    func getCachedTodayLesson() async throws -> Lesson?
    func saveTodayLesson(_ lesson: Lesson) async throws
    func markLessonCompleted(id: UUID) async throws
}

/// Protocolo para abstrair a comunicação com a API remota REST/GraphQL.
public protocol LessonRemoteDataSourceProtocol: Sendable {
    func fetchTodayLesson() async throws -> LessonDTO
    func syncLessonProgress(lessonId: UUID, completed: Bool) async throws
}

/// Implementação Concreta de Repositório seguindo o padrão Offline-First.
/// Combina fonte de dados local (cache) com revalidação assíncrona remota.
public final class LessonRepository: LessonRepositoryProtocol {
    private let localDataSource: any LessonLocalDataSourceProtocol
    private let remoteDataSource: any LessonRemoteDataSourceProtocol

    public init(
        localDataSource: any LessonLocalDataSourceProtocol,
        remoteDataSource: any LessonRemoteDataSourceProtocol
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    public func fetchTodayLesson() async throws -> Lesson {
        // 1. Tentar obter dado fresco da rede (Network-first com fallback para cache local)
        do {
            let remoteDTO = try await remoteDataSource.fetchTodayLesson()
            let domainLesson = remoteDTO.toDomain()
            
            // Atualiza o cache local de forma atômica
            try? await localDataSource.saveTodayLesson(domainLesson)
            return domainLesson
        } catch {
            // 2. Se a rede falhar, recorre ao cache local persistido
            if let cachedLesson = try? await localDataSource.getCachedTodayLesson() {
                return cachedLesson
            }
            
            // 3. Caso não haja cache nem rede, propaga erro de domínio adequado
            if (error as? URLError)?.code == .notConnectedToInternet {
                throw LessonDomainError.networkUnavailable
            }
            throw LessonDomainError.serverFailure(statusCode: (error as? URLError)?.errorCode ?? 500)
        }
    }

    public func fetchLesson(by id: UUID) async throws -> Lesson {
        // Implementação simplificada delegada
        return try await fetchTodayLesson()
    }

    public func saveLessonProgress(lessonId: UUID, completed: Bool) async throws {
        // Salva localmente primeiro (garantindo resposta instantânea da UI)
        try await localDataSource.markLessonCompleted(id: lessonId)

        // Envia para a nuvem de forma assíncrona
        Task.detached(priority: .background) { [remoteDataSource] in
            try? await remoteDataSource.syncLessonProgress(lessonId: lessonId, completed: completed)
        }
    }
}

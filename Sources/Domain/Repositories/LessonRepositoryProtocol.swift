//
//  LessonRepositoryProtocol.swift
//  English along with John - Domain Layer
//

import Foundation

/// Contrato agnóstico de dados para obtenção e mutação de lições.
/// A camada de domínio depende apenas desta interface (DIP - Dependency Inversion Principle).
public protocol LessonRepositoryProtocol: Sendable {
    /// Obtém a lição diária programada para a data de hoje.
    /// Deve seguir a política Offline-First (leitura de cache com sincronização remota).
    func fetchTodayLesson() async throws -> Lesson

    /// Busca lição específica por identificador.
    func fetchLesson(by id: UUID) async throws -> Lesson

    /// Marca lição como concluída e persiste o progresso do aluno.
    func saveLessonProgress(lessonId: UUID, completed: Bool) async throws
}

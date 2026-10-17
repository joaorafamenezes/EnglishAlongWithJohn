//
//  FetchTodayLessonUseCaseProtocol.swift
//  English along with John - Domain Layer
//

import Foundation

/// Contrato para o Caso de Uso de obtenção da lição do dia.
public protocol FetchTodayLessonUseCaseProtocol: Sendable {
    func execute() async throws -> Lesson
}

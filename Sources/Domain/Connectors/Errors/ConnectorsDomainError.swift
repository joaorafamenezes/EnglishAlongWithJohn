//
//  ConnectorsDomainError.swift
//  English along with John - Domain / Connectors
//

import Foundation

public enum ConnectorsDomainError: LocalizedError, Sendable, Equatable {
    case allItemsMastered
    case emptyExercisePool
    case exerciseNotFound
    case sessionAlreadyFinished
    case unknown(message: String)

    public var errorDescription: String? {
        switch self {
        case .allItemsMastered:
            return "Todos os conectivos desta seleção foram marcados como dominados. Desative 'Ocultar conectivos dominados' para praticar em Modo Revisão."
        case .emptyExercisePool:
            return "Nenhum exercício encontrado para os filtros selecionados."
        case .exerciseNotFound:
            return "Exercício não encontrado na sessão ativa."
        case .sessionAlreadyFinished:
            return "Esta sessão já foi concluída."
        case .unknown(let message):
            return "Ocorreu um erro inesperado: \(message)"
        }
    }
}

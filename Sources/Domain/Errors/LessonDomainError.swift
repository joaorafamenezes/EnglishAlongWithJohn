//
//  LessonDomainError.swift
//  English along with John - Domain Layer
//

import Foundation

/// Erros canônicos de domínio para operações pedagógicas e lições.
public enum LessonDomainError: LocalizedError, Sendable, Equatable {
    case lessonNotFound
    case networkUnavailable
    case serverFailure(statusCode: Int)
    case cacheCorrupted
    case unauthorized
    case unknown(message: String)

    public var errorDescription: String? {
        switch self {
        case .lessonNotFound:
            return "A lição solicitada não foi encontrada ou ainda não está disponível."
        case .networkUnavailable:
            return "Sem conexão com a internet. Verifique sua rede para carregar novas lições."
        case .serverFailure(let code):
            return "Falha de comunicação com o servidor (Status: \(code)). Tente novamente."
        case .cacheCorrupted:
            return "Os dados salvos localmente estão inacessíveis."
        case .unauthorized:
            return "Sessão expirada. Faça login novamente para acessar o conteúdo do professor John."
        case .unknown(let message):
            return "Ocorreu um erro inesperado: \(message)"
        }
    }
}

//
//  AuthDomainError.swift
//  English along with John - Domain Layer
//

import Foundation

/// Erros canônicos de autenticação da camada de domínio.
public enum AuthDomainError: LocalizedError, Sendable, Equatable {
    case invalidCredentials
    case emptyFields
    case serverUnavailable
    case sessionExpired
    case unknown(message: String)

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Usuário ou senha incorretos. Verifique suas credenciais e tente novamente."
        case .emptyFields:
            return "Por favor, preencha o usuário e a senha para continuar."
        case .serverUnavailable:
            return "Serviço de autenticação temporariamente indisponível. Tente mais tarde."
        case .sessionExpired:
            return "Sua sessão expirou. Efetue login novamente."
        case .unknown(let message):
            return "Ocorreu um erro inesperado: \(message)"
        }
    }
}

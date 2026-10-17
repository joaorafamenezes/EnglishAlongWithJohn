//
//  AuthenticateUserUseCaseProtocol.swift
//  English along with John - Domain Layer
//

import Foundation

/// Contrato para o Caso de Uso de autenticação de usuários.
public protocol AuthenticateUserUseCaseProtocol: Sendable {
    func execute(credentials: LoginCredentials) async throws -> UserSession
}

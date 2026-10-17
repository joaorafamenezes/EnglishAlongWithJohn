//
//  AuthRepositoryProtocol.swift
//  English along with John - Domain Layer
//

import Foundation

/// Contrato agnóstico de infraestrutura para operações de autenticação e sessão.
public protocol AuthRepositoryProtocol: Sendable {
    /// Autentica um usuário através de credenciais informadas.
    func authenticate(credentials: LoginCredentials) async throws -> UserSession

    /// Encerra a sessão ativa do usuário.
    func logout() async throws

    /// Retorna a sessão ativa em memória ou cache seguro (Keychain), caso exista.
    func getCurrentSession() async -> UserSession?
}

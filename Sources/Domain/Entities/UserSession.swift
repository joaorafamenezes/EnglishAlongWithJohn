//
//  UserSession.swift
//  English along with John - Domain Layer
//

import Foundation

/// Entidade que representa a sessão ativa do usuário autenticado no aplicativo.
public struct UserSession: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let username: String
    public let displayName: String
    public let token: String
    public let authenticatedAt: Date

    public init(
        id: UUID = UUID(),
        username: String,
        displayName: String,
        token: String = UUID().uuidString,
        authenticatedAt: Date = Date()
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.token = token
        self.authenticatedAt = authenticatedAt
    }
}

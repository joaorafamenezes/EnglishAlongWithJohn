//
//  LoginCredentials.swift
//  English along with John - Domain Layer
//

import Foundation

/// Value Object que encapsula e valida os dados de entrada para autenticação.
public struct LoginCredentials: Sendable, Equatable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        self.password = password
    }

    public var isEmpty: Bool {
        username.isEmpty || password.isEmpty
    }
}

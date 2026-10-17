//
//  InMemoryAuthRepository.swift
//  English along with John - Data Layer
//

import Foundation

/// Implementação em memória (Simulada / Mock) do repositório de autenticação.
/// Atende ao requisito de validação offline com par fixo "admin" / "admin".
public final class InMemoryAuthRepository: AuthRepositoryProtocol, @unchecked Sendable {
    private var activeSession: UserSession?
    public var simulatedDelayNanoseconds: UInt64

    public init(simulatedDelayNanoseconds: UInt64 = 400_000_000) { // 400ms de feedback visual padrão
        self.simulatedDelayNanoseconds = simulatedDelayNanoseconds
    }

    public func authenticate(credentials: LoginCredentials) async throws -> UserSession {
        // Simulação de latência de rede/processamento criptográfico seguro
        if simulatedDelayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        }

        // Validação estrita das credenciais fixadas
        let validUsername = "admin"
        let validPassword = "admin"

        guard credentials.username == validUsername, credentials.password == validPassword else {
            throw AuthDomainError.invalidCredentials
        }

        let session = UserSession(
            id: UUID(),
            username: validUsername,
            displayName: "Aluno Admin",
            token: "mock_jwt_session_token_\(UUID().uuidString)"
        )
        self.activeSession = session
        return session
    }

    public func logout() async throws {
        self.activeSession = nil
    }

    public func getCurrentSession() async -> UserSession? {
        return activeSession
    }
}

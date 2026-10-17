//
//  AuthenticateUserUseCase.swift
//  English along with John - Domain Layer
//

import Foundation

/// Caso de Uso de Responsabilidade Única (SRP):
/// Orquestra as regras de negócio de validação e submissão para autenticação do aluno.
public final class AuthenticateUserUseCase: AuthenticateUserUseCaseProtocol {
    private let repository: any AuthRepositoryProtocol

    public init(repository: any AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(credentials: LoginCredentials) async throws -> UserSession {
        // Regra de Domínio: campos não podem estar vazios
        guard !credentials.isEmpty else {
            throw AuthDomainError.emptyFields
        }

        // Delega para o repositório resiliente sob abstração DIP
        do {
            let session = try await repository.authenticate(credentials: credentials)
            return session
        } catch let authError as AuthDomainError {
            throw authError
        } catch {
            throw AuthDomainError.unknown(message: error.localizedDescription)
        }
    }
}

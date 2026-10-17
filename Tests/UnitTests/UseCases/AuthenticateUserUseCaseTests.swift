//
//  AuthenticateUserUseCaseTests.swift
//  English along with John - Tests / UnitTests
//

import Testing
import Foundation

@Suite("Suíte de Testes: AuthenticateUserUseCase")
struct AuthenticateUserUseCaseTests {

    @Test("Deve autenticar com sucesso ao receber credenciais admin / admin")
    func testAuthenticationSuccessWithAdminCredentials() async throws {
        // Arrange
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let sut = AuthenticateUserUseCase(repository: repo)
        let credentials = LoginCredentials(username: "admin", password: "admin")

        // Act
        let session = try await sut.execute(credentials: credentials)

        // Assert
        #expect(session.username == "admin")
        #expect(session.displayName == "Aluno Admin")
        #expect(!session.token.isEmpty)
    }

    @Test("Deve lançar erro de credenciais inválidas para senha incorreta")
    func testAuthenticationFailureWithWrongPassword() async {
        // Arrange
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let sut = AuthenticateUserUseCase(repository: repo)
        let credentials = LoginCredentials(username: "admin", password: "wrong_password")

        // Act & Assert
        await #expect(throws: AuthDomainError.invalidCredentials) {
            _ = try await sut.execute(credentials: credentials)
        }
    }

    @Test("Deve lançar erro de credenciais inválidas para usuário inexistente")
    func testAuthenticationFailureWithUnknownUser() async {
        // Arrange
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let sut = AuthenticateUserUseCase(repository: repo)
        let credentials = LoginCredentials(username: "john_doe", password: "admin")

        // Act & Assert
        await #expect(throws: AuthDomainError.invalidCredentials) {
            _ = try await sut.execute(credentials: credentials)
        }
    }

    @Test("Deve lançar erro de campos vazios antes de invocar o repositório")
    func testAuthenticationFailureWithEmptyCredentials() async {
        // Arrange
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let sut = AuthenticateUserUseCase(repository: repo)
        let credentials = LoginCredentials(username: "", password: "")

        // Act & Assert
        await #expect(throws: AuthDomainError.emptyFields) {
            _ = try await sut.execute(credentials: credentials)
        }
    }
}

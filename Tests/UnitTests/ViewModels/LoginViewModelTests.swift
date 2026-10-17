//
//  LoginViewModelTests.swift
//  English along with John - Tests / UnitTests
//

import Testing
import Foundation
@testable import EnglishAlongWithJohn

@Suite("Suíte de Testes: LoginViewModel")
@MainActor
struct LoginViewModelTests {

    @Test("Deve inicializar com estados padrão vazios e canSubmit como falso")
    func testInitialState() {
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let useCase = AuthenticateUserUseCase(repository: repo)
        let sut = LoginViewModel(authenticateUserUseCase: useCase)

        #expect(sut.username.isEmpty)
        #expect(sut.password.isEmpty)
        #expect(!sut.isPasswordVisible)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(!sut.isAuthenticated)
        #expect(!sut.canSubmit)
    }

    @Test("Deve habilitar canSubmit apenas quando ambos os campos forem preenchidos")
    func testCanSubmitValidation() {
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let useCase = AuthenticateUserUseCase(repository: repo)
        let sut = LoginViewModel(authenticateUserUseCase: useCase)

        sut.username = "admin"
        #expect(!sut.canSubmit)

        sut.password = "admin"
        #expect(sut.canSubmit)

        sut.username = "   "
        #expect(!sut.canSubmit)
    }

    @Test("Deve autenticar com sucesso e invocar o callback onLoginSuccess")
    func testSuccessfulLoginFlow() async {
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let useCase = AuthenticateUserUseCase(repository: repo)

        var didCallSuccess = false
        let sut = LoginViewModel(authenticateUserUseCase: useCase) { _ in
            didCallSuccess = true
        }

        sut.username = "admin"
        sut.password = "admin"

        await sut.login()

        #expect(sut.isAuthenticated)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(sut.currentSession?.username == "admin")
        #expect(didCallSuccess)
    }

    @Test("Deve apresentar mensagem de erro amigável ao falhar a autenticação")
    func testFailedLoginFlow() async {
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let useCase = AuthenticateUserUseCase(repository: repo)
        let sut = LoginViewModel(authenticateUserUseCase: useCase)

        sut.username = "admin"
        sut.password = "senha_errada"

        await sut.login()

        #expect(!sut.isAuthenticated)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == AuthDomainError.invalidCredentials.errorDescription)
    }

    @Test("Deve alternar a visibilidade da senha corretamente")
    func testTogglePasswordVisibility() {
        let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
        let useCase = AuthenticateUserUseCase(repository: repo)
        let sut = LoginViewModel(authenticateUserUseCase: useCase)

        #expect(!sut.isPasswordVisible)

        sut.togglePasswordVisibility()
        #expect(sut.isPasswordVisible)

        sut.togglePasswordVisibility()
        #expect(!sut.isPasswordVisible)
    }
}

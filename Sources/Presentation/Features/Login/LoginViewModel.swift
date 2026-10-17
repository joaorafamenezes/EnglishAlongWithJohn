//
//  LoginViewModel.swift
//  English along with John - Presentation Layer
//

import Foundation
import Observation

/// ViewModel para a tela de autenticação do aplicativo.
/// Implementa a macro `@Observable` com isolamento no `@MainActor`.
@Observable
@MainActor
public final class LoginViewModel {

    // MARK: - Estados de Entrada do Usuário
    public var username: String = "" {
        didSet { clearErrorIfNeeded() }
    }
    public var password: String = "" {
        didSet { clearErrorIfNeeded() }
    }
    public var isPasswordVisible: Bool = false

    // MARK: - Estados de UI e Apresentação
    public private(set) var isLoading: Bool = false
    public private(set) var errorMessage: String? = nil
    public private(set) var isAuthenticated: Bool = false
    public private(set) var currentSession: UserSession? = nil

    // MARK: - Regras de Apresentação / Computed Properties
    public var canSubmit: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        !isLoading
    }

    // MARK: - Dependências
    private let authenticateUserUseCase: any AuthenticateUserUseCaseProtocol
    public var onLoginSuccess: (@MainActor (UserSession) -> Void)?

    public init(
        authenticateUserUseCase: any AuthenticateUserUseCaseProtocol,
        onLoginSuccess: (@MainActor (UserSession) -> Void)? = nil
    ) {
        self.authenticateUserUseCase = authenticateUserUseCase
        self.onLoginSuccess = onLoginSuccess
    }

    // MARK: - Ações de Usuário

    /// Submete as credenciais do usuário para validação assíncrona.
    public func login() async {
        guard canSubmit else { return }

        isLoading = true
        errorMessage = nil

        let credentials = LoginCredentials(username: username, password: password)

        do {
            let session = try await authenticateUserUseCase.execute(credentials: credentials)
            self.currentSession = session
            self.isAuthenticated = true
            self.isLoading = false
            self.onLoginSuccess?(session)
        } catch let domainError as AuthDomainError {
            self.isLoading = false
            self.errorMessage = domainError.errorDescription
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }

    /// Alterna a visibilidade do campo de senha (texto claro vs protegido).
    public func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }

    /// Limpa mensagens de erro ao digitar novamente.
    private func clearErrorIfNeeded() {
        if errorMessage != nil {
            errorMessage = nil
        }
    }
}

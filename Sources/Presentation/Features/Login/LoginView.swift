//
//  LoginView.swift
//  English along with John - Presentation Layer
//

import SwiftUI

/// View declarativa para a tela de Login do aplicativo "English along with John".
/// Consome o `LoginViewModel` observável e adota design moderno nativo em SwiftUI.
public struct LoginView: View {
    @Bindable private var viewModel: LoginViewModel

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            // Fundo estilizado com gradiente sutil
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    // MARK: - Header com Identidade Visual do App
                    brandingHeaderView

                    // MARK: - Card de Formulário de Entrada
                    formCardView

                    // MARK: - Banner de Erro Reativo
                    if let error = viewModel.errorMessage {
                        errorBanner(message: error)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // MARK: - Botão de Ação Principal
                    submitButtonView

                    // MARK: - Dica Rápida para Testadores / Avaliadores
                    quickAccessHintView

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isPasswordVisible)
    }

    // MARK: - Subviews Modulares

    @ViewBuilder
    private var brandingHeaderView: some View {
        VStack(spacing: 12) {
            // Avatar do Professor John com anel gradiente
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 88, height: 88)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 6)

                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.white)
            }

            VStack(spacing: 6) {
                Text("English along with John")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("Seu mentor diário para fluência natural no inglês")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    @ViewBuilder
    private var formCardView: some View {
        VStack(spacing: 16) {
            // Campo de Usuário
            HStack(spacing: 12) {
                Image(systemName: "person.fill")
                    .foregroundStyle(.blue)
                    .frame(width: 24)

                TextField("Usuário (ex: admin)", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textContentType(.username)
                    .submitLabel(.next)
                    #endif
            }
            .padding(14)
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )

            // Campo de Senha com Alternador de Visibilidade
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.blue)
                    .frame(width: 24)

                if viewModel.isPasswordVisible {
                    TextField("Senha (ex: admin)", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .textContentType(.password)
                        .submitLabel(.go)
                        #endif
                        .onSubmit {
                            Task { await viewModel.login() }
                        }
                } else {
                    SecureField("Senha (ex: admin)", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .textContentType(.password)
                        .submitLabel(.go)
                        #endif
                        .onSubmit {
                            Task { await viewModel.login() }
                        }
                }

                Button(action: {
                    viewModel.togglePasswordVisibility()
                }) {
                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.secondary)
                        .padding(4)
                }
            }
            .padding(14)
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    private func errorBanner(message: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.red)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color.red.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var submitButtonView: some View {
        Button(action: {
            Task {
                await viewModel.login()
            }
        }) {
            HStack(spacing: 10) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Entrar na Plataforma")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                viewModel.canSubmit ? Color.blue : Color.blue.opacity(0.4)
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: viewModel.canSubmit ? Color.blue.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
        .disabled(!viewModel.canSubmit)
    }

    @ViewBuilder
    private var quickAccessHintView: some View {
        Button(action: {
            // Autofill amigável para testes rápidos
            viewModel.username = "admin"
            viewModel.password = "admin"
        }) {
            HStack(spacing: 6) {
                Image(systemName: "key.fill")
                    .font(.caption2)
                Text("Preencher Credenciais de Teste (admin / admin)")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.appCardBackground)
            .foregroundStyle(.secondary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews
#Preview("Tela de Login Padrão") {
    let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
    let useCase = AuthenticateUserUseCase(repository: repo)
    let viewModel = LoginViewModel(authenticateUserUseCase: useCase)
    LoginView(viewModel: viewModel)
}

#Preview("Com Erro de Credenciais") {
    let repo = InMemoryAuthRepository(simulatedDelayNanoseconds: 0)
    let useCase = AuthenticateUserUseCase(repository: repo)
    let viewModel = LoginViewModel(authenticateUserUseCase: useCase)
    viewModel.username = "usuario_invalido"
    viewModel.password = "123456"

    return LoginView(viewModel: viewModel)
        .task {
            await viewModel.login()
        }
}

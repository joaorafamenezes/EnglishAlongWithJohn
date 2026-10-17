//
//  AppContainer.swift
//  English along with John - Core / DI
//

import Foundation

/// Protocolo do Container de Dependências da Aplicação (Composition Root).
/// Centraliza a criação e ciclo de vida de instâncias sem depender de frameworks externos.
@MainActor
public protocol AppContainerProtocol {
    var coordinator: AppCoordinator { get }
    var lessonRepository: any LessonRepositoryProtocol { get }
    var authRepository: any AuthRepositoryProtocol { get }
    var connectorsRepository: any ConnectorsRepositoryProtocol { get }
    
    // Factories para Casos de Uso
    func makeFetchTodayLessonUseCase() -> any FetchTodayLessonUseCaseProtocol
    func makeAuthenticateUserUseCase() -> any AuthenticateUserUseCaseProtocol
    func makeFetchConnectorsSessionUseCase() -> any FetchConnectorsSessionUseCaseProtocol

    // Factories para ViewModels
    func makeTodayLessonViewModel() -> TodayLessonViewModel
    func makeLoginViewModel(onSuccess: (@MainActor (UserSession) -> Void)?) -> LoginViewModel
    func makeConnectorsHubViewModel(onStartSession: (@MainActor (ConnectorSession) -> Void)?) -> ConnectorsHubViewModel
    func makeConnectorPracticeViewModel(session: ConnectorSession) -> ConnectorPracticeViewModel
}

/// Implementação padrão do Container de Injeção de Dependências.
@MainActor
public final class AppContainer: AppContainerProtocol {
    // Singleton compartilhado para navegação de fluxo
    public let coordinator: AppCoordinator

    // Repositórios persistidos durante a sessão
    public let lessonRepository: any LessonRepositoryProtocol
    public let authRepository: any AuthRepositoryProtocol
    public let connectorsRepository: any ConnectorsRepositoryProtocol

    public init(
        coordinator: AppCoordinator = AppCoordinator(),
        lessonRepository: (any LessonRepositoryProtocol)? = nil,
        authRepository: (any AuthRepositoryProtocol)? = nil,
        connectorsRepository: (any ConnectorsRepositoryProtocol)? = nil
    ) {
        self.coordinator = coordinator
        self.lessonRepository = lessonRepository ?? MockLessonRepository()
        self.authRepository = authRepository ?? InMemoryAuthRepository()
        self.connectorsRepository = connectorsRepository ?? ConnectorsRepository()
    }

    // MARK: - Use Cases
    public func makeFetchTodayLessonUseCase() -> any FetchTodayLessonUseCaseProtocol {
        FetchTodayLessonUseCase(repository: lessonRepository)
    }

    public func makeAuthenticateUserUseCase() -> any AuthenticateUserUseCaseProtocol {
        AuthenticateUserUseCase(repository: authRepository)
    }

    public func makeFetchConnectorsSessionUseCase() -> any FetchConnectorsSessionUseCaseProtocol {
        FetchConnectorsSessionUseCase(repository: connectorsRepository)
    }

    // MARK: - ViewModels
    public func makeTodayLessonViewModel() -> TodayLessonViewModel {
        TodayLessonViewModel(
            fetchTodayLessonUseCase: makeFetchTodayLessonUseCase(),
            coordinator: coordinator
        )
    }

    public func makeLoginViewModel(onSuccess: (@MainActor (UserSession) -> Void)? = nil) -> LoginViewModel {
        LoginViewModel(
            authenticateUserUseCase: makeAuthenticateUserUseCase(),
            onLoginSuccess: onSuccess
        )
    }

    public func makeConnectorsHubViewModel(onStartSession: (@MainActor (ConnectorSession) -> Void)? = nil) -> ConnectorsHubViewModel {
        ConnectorsHubViewModel(
            repository: connectorsRepository,
            fetchSessionUseCase: makeFetchConnectorsSessionUseCase(),
            onStartSession: onStartSession
        )
    }

    public func makeConnectorPracticeViewModel(session: ConnectorSession) -> ConnectorPracticeViewModel {
        ConnectorPracticeViewModel(
            session: session,
            repository: connectorsRepository
        )
    }
}

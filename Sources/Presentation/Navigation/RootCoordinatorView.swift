//
//  RootCoordinatorView.swift
//  English along with John - Presentation / Navigation
//

import SwiftUI

/// View Raiz que conecta o `NavigationStack` ao `AppCoordinator` e resolve destinos via rotas.
public struct RootCoordinatorView: View {
    @State private var isAuthenticated: Bool = false
    @Bindable private var coordinator: AppCoordinator
    private let container: any AppContainerProtocol

    @State private var activeConnectorSession: ConnectorSession? = nil

    public init(container: any AppContainerProtocol) {
        self.container = container
        self._coordinator = Bindable(container.coordinator)
    }

    public var body: some View {
        Group {
            if isAuthenticated {
                NavigationStack(path: $coordinator.path) {
                    TodayLessonView(viewModel: container.makeTodayLessonViewModel())
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                }
                .transition(.asymmetric(insertion: .push(from: .trailing), removal: .opacity))
            } else {
                LoginView(viewModel: container.makeLoginViewModel { _ in
                    withAnimation(.easeInOut(duration: 0.35)) {
                        isAuthenticated = true
                    }
                })
                .transition(.asymmetric(insertion: .opacity, removal: .push(from: .leading)))
            }
        }
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .todayLesson:
            TodayLessonView(viewModel: container.makeTodayLessonViewModel())

        case .connectorsHub:
            ConnectorsHubView(viewModel: container.makeConnectorsHubViewModel { session in
                self.activeConnectorSession = session
                coordinator.navigate(to: .connectorPractice(sessionId: session.id))
            })

        case .connectorPractice(let sessionId):
            if let session = activeConnectorSession, session.id == sessionId {
                ConnectorPracticeView(viewModel: container.makeConnectorPracticeViewModel(session: session))
            } else {
                Text("Sessão não encontrada.")
            }

        case .lessonDetail(let id):
            VStack {
                Text("Detalhes da Lição: \(id.uuidString)")
                    .font(.headline)
            }

        case .exerciseSession(let lessonId):
            VStack(spacing: 20) {
                Text("Sessão de Exercícios do John")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("ID da Lição: \(lessonId.uuidString)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button("Concluir e Voltar") {
                    coordinator.pop()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Exercícios")

        case .pronunciationDrill(let audioUrl):
            VStack {
                Text("Treino de Pronúncia")
                    .font(.title2)
                if let url = audioUrl {
                    Text("Áudio: \(url.absoluteString)")
                        .font(.caption)
                }
            }

        case .studentProfile:
            VStack {
                Text("Perfil do Aluno & Histórico")
                    .font(.title2)
            }
        }
    }
}

//
//  TodayLessonView.swift
//  English along with John - Presentation Layer
//

import SwiftUI

/// View SwiftUI declarativa e reativa para a Lição Diária.
/// Consome o `TodayLessonViewModel` observável e delega as ações de usuário.
public struct TodayLessonView: View {
    @State private var viewModel: TodayLessonViewModel

    public init(viewModel: TodayLessonViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                loadingView
            case .loaded(let lesson):
                loadedContentView(lesson: lesson)
            case .error(let message):
                errorView(message: message)
            }
        }
        .navigationTitle("English with John")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onAppear()
        }
    }

    // MARK: - Subviews Modulares

    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.4)
                .tint(.blue)
            Text("Carregando aula de hoje com John...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }

    @ViewBuilder
    private func loadedContentView(lesson: Lesson) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                // Header com instrutor
                instructorHeaderView

                // Badge de Nível e Tópico
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(lesson.level.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.12))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())

                        Spacer()

                        Label("\(lesson.durationInSeconds / 60) min de imersão", systemImage: "clock.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text(lesson.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    Text(lesson.topic)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)


                // Menus de Estudo e Jogos do Sistema
                studyModulesSection
            }
            .padding(.vertical)
        }
        .background(Color.appBackground)
        .refreshable {
            await viewModel.retryLoading()
        }
    }

    @ViewBuilder
    private var instructorHeaderView: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(8)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Teacher John")
                    .font(.headline)
                Text("Seu mentor nativo hoje")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "sparkles")
                .foregroundStyle(.orange)
                .font(.title3)
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }


    @ViewBuilder
    private var studyModulesSection: some View {
        VStack(spacing: 16) {
            // 1. Laboratório de Conectivos (Connectors Lab)
            menuCard(
                title: "Prática de Conectivos (Connectors Lab)",
                subtitle: "Gap Runner nos modos Zen e Arcade, Deck dos 81 Conectivos e Match Rápido.",
                icon: "sparkles.rectangle.stack.fill",
                iconColor: .purple,
                buttonTitle: "Abrir Laboratório de Conectivos",
                gradient: LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing),
                action: { viewModel.didTapConnectorsHub() }
            )

            // 2. Phrasal Verbs Game
            menuCard(
                title: "Phrasal Verbs Game",
                subtitle: "Desafio das Frases (Quiz), Match Rápido e Deck Didático com níveis A1 a C1.",
                icon: "figure.run.circle.fill",
                iconColor: .orange,
                buttonTitle: "Jogar Phrasal Verbs",
                gradient: LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing),
                action: { viewModel.didTapPhrasalVerbsHub() }
            )

            // 3. Família -Ever & Whereas
            menuCard(
                title: "Família -Ever & Whereas",
                subtitle: "Regra de ouro, matriz comparativa e quiz de fixação para Whatever, Whenever, Wherever, Whoever, However e Whereas.",
                icon: "key.horizontal.fill",
                iconColor: .green,
                buttonTitle: "Explorar Família -Ever",
                gradient: LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing),
                action: { viewModel.didTapEverFamilyHub() }
            )

            // 4. Expressões Idiomáticas (Idiomatic Expressions)
            menuCard(
                title: "Expressões Idiomáticas",
                subtitle: "Desafio de significados reais, notas culturais e frases do cotidiano sem tradução ao pé da letra.",
                icon: "quote.bubble.fill",
                iconColor: .pink,
                buttonTitle: "Praticar Expressões",
                gradient: LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing),
                action: { viewModel.didTapIdiomaticExpressionsHub() }
            )
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func menuCard(
        title: String,
        subtitle: String,
        icon: String,
        iconColor: Color,
        buttonTitle: String,
        gradient: LinearGradient,
        action: @escaping @MainActor () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.headline)
                    .foregroundStyle(iconColor)
                Spacer()
            }

            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: action) {
                HStack {
                    Text(buttonTitle)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(gradient)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange)

            Text("Não foi possível carregar a aula")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                Task {
                    await viewModel.retryLoading()
                }
            }) {
                Label("Tentar Novamente", systemImage: "arrow.clockwise")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}

// MARK: - Previews
#Preview("Estado de Sucesso") {
    let mockRepo = MockLessonRepository()
    let useCase = FetchTodayLessonUseCase(repository: mockRepo)
    let coordinator = AppCoordinator()
    let viewModel = TodayLessonViewModel(fetchTodayLessonUseCase: useCase, coordinator: coordinator)

    NavigationStack {
        TodayLessonView(viewModel: viewModel)
    }
}

#Preview("Estado de Erro") {
    let mockRepo = MockLessonRepository(shouldThrowError: LessonDomainError.networkUnavailable)
    let useCase = FetchTodayLessonUseCase(repository: mockRepo)
    let coordinator = AppCoordinator()
    let viewModel = TodayLessonViewModel(fetchTodayLessonUseCase: useCase, coordinator: coordinator)

    NavigationStack {
        TodayLessonView(viewModel: viewModel)
    }
}

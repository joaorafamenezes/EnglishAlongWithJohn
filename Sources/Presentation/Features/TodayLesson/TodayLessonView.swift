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

                // Player de Áudio / Podcast
                audioPlayerCard(lesson: lesson)
                    .padding(.horizontal)

                // Resumo pedagógico
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sobre a aula de hoje")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(lesson.summary)
                        .font(.body)
                        .lineSpacing(4)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Seção de Exercícios Práticos
                exerciseSectionCard(lesson: lesson)
                    .padding(.horizontal)

                // Laboratório de Conectivos (English Connectors Lab)
                connectorsLabBannerCard
                    .padding(.horizontal)
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
    private func audioPlayerCard(lesson: Lesson) -> some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Áudio & Pronúncia")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("Ouça a entonação natural com John")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: {
                    viewModel.toggleAudioPlayback()
                }) {
                    Image(systemName: viewModel.isPlayingAudio ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.blue)
                }
            }

            // Simulação de Waveform visual
            HStack(spacing: 4) {
                ForEach(0..<24) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index < 8 && viewModel.isPlayingAudio ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: CGFloat([12, 24, 18, 30, 15, 28, 22, 16][index % 8]))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 36)
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func exerciseSectionCard(lesson: Lesson) -> some View {
        VStack(spacing: 12) {
            HStack {
                Label("\(lesson.exercises.count) Exercícios Práticos", systemImage: "checkmark.circle.badge.questionmark")
                    .font(.headline)
                Spacer()
            }

            Text("Fixe o vocabulário e expressões idiomáticas aprendidas no episódio.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                viewModel.didTapStartExercises(lesson: lesson)
            }) {
                HStack {
                    Text("Iniciar Desafio do Dia")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var connectorsLabBannerCard: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Prática de Conectivos (Connectors Lab)", systemImage: "sparkles.rectangle.stack.fill")
                    .font(.headline)
                    .foregroundStyle(.purple)
                Spacer()
            }

            Text("Treine conectivos sintáticos essenciais e a Família -ever nos modos Zen e Arcade.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                viewModel.didTapConnectorsHub()
            }) {
                HStack {
                    Text("Abrir Laboratório de Conectivos")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
                )
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

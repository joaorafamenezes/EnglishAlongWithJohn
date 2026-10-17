//
//  ConnectorPracticeView.swift
//  English along with John - Presentation / Connectors
//

import SwiftUI

/// View interativa de prática de conectivos com suporte a Modo Zen e Desafio Arcade.
public struct ConnectorPracticeView: View {
    @Bindable private var viewModel: ConnectorPracticeViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: ConnectorPracticeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header HUD (Zen vs Arcade)
                headerHUDView
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 20) {
                        if let currentExercise = viewModel.session.currentExercise {
                            // MARK: - Card da Pergunta
                            questionCard(exercise: currentExercise)

                            // MARK: - Opções de Resposta
                            optionsGridView(exercise: currentExercise)

                            // MARK: - Feedback do Teacher John
                            if viewModel.isAnswered, let result = viewModel.evaluationResult {
                                teacherFeedbackCard(result: result)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                // MARK: - Barra Inferior de Ação
                if viewModel.isAnswered {
                    bottomActionBar
                        .padding()
                        .background(Color.appCardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.06), radius: 6, y: -2)
                }
            }

            // MARK: - Overlay de Fim de Jogo / Vitória
            if viewModel.session.isGameOver {
                gameOverOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Encerrar") {
                    dismiss()
                }
                .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.isAnswered)
        .animation(.easeInOut(duration: 0.2), value: viewModel.secondsLeft)
    }

    // MARK: - Header HUD

    @ViewBuilder
    private var headerHUDView: some View {
        VStack(spacing: 10) {
            HStack {
                // Progresso
                Text("Questão \(viewModel.session.currentIndex + 1) de \(viewModel.session.totalCount)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()

                // Multiplicador de Streak
                if viewModel.session.streak > 1 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("x\(min(viewModel.session.streak, 5)) STREAK")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.12))
                    .clipShape(Capsule())
                }

                // Pontuação (Arcade ou Zen com pontos)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text("\(viewModel.session.score) pts")
                        .font(.footnote)
                        .fontWeight(.bold)
                }
            }

            // HUD Específico do Modo Arcade
            if viewModel.session.mode == .arcade {
                HStack {
                    // Vidas (Corações)
                    HStack(spacing: 4) {
                        ForEach(0..<viewModel.session.maxLives, id: \.self) { index in
                            Image(systemName: index < viewModel.session.lives ? "heart.fill" : "heart")
                                .foregroundStyle(index < viewModel.session.lives ? .red : .gray.opacity(0.4))
                                .font(.subheadline)
                        }
                    }

                    Spacer()

                    // Cronômetro 18s
                    HStack(spacing: 6) {
                        Image(systemName: "timer")
                            .foregroundStyle(timerColor)
                        Text("\(viewModel.secondsLeft)s")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(timerColor)
                    }
                }

                // Barra de progresso do timer
                ProgressView(value: Double(viewModel.secondsLeft), total: 18.0)
                    .tint(timerColor)
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var timerColor: Color {
        if viewModel.secondsLeft > 10 { return .blue }
        if viewModel.secondsLeft > 5 { return .orange }
        return .red
    }

    // MARK: - Card da Pergunta

    @ViewBuilder
    private func questionCard(exercise: ConnectorExercise) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                // Badge de Família
                HStack(spacing: 6) {
                    Image(systemName: exercise.family.iconName)
                    Text(exercise.family.localizedTitle)
                }
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(hex: exercise.family.accentColorHex).opacity(0.15))
                .foregroundStyle(Color(hex: exercise.family.accentColorHex))
                .clipShape(Capsule())

                Spacer()

                // Botão de Marcar como Dominado
                Button(action: {
                    Task { await viewModel.toggleMastery() }
                }) {
                    Image(systemName: viewModel.isMastered ? "checkmark.seal.fill" : "checkmark.seal")
                        .foregroundStyle(viewModel.isMastered ? .green : .secondary)
                        .font(.title3)
                }
            }

            // Frase com Lacuna
            Text(exercise.prompt)
                .font(.system(size: 19, weight: .semibold, design: .rounded))
                .lineSpacing(6)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Opções de Resposta

    @ViewBuilder
    private func optionsGridView(exercise: ConnectorExercise) -> some View {
        VStack(spacing: 10) {
            ForEach(exercise.options) { option in
                optionButton(option: option, exercise: exercise)
            }
        }
    }

    @ViewBuilder
    private func optionButton(option: ConnectorExerciseOption, exercise: ConnectorExercise) -> some View {
        let isSelected = viewModel.selectedOptionId == option.id
        let isCorrect = option.id == exercise.correctOptionId

        Button(action: {
            viewModel.selectOption(option.id)
        }) {
            HStack {
                Text(option.text)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(optionTextColor(isSelected: isSelected, isCorrect: isCorrect))

                Spacer()

                if viewModel.isAnswered {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title3)
                    } else if isSelected {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(.title3)
                    }
                }
            }
            .padding(16)
            .background(optionBackgroundColor(isSelected: isSelected, isCorrect: isCorrect))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(optionBorderColor(isSelected: isSelected, isCorrect: isCorrect), lineWidth: 1.5)
            )
        }
        .disabled(viewModel.isAnswered)
        .buttonStyle(.plain)
    }

    private func optionTextColor(isSelected: Bool, isCorrect: Bool) -> Color {
        guard viewModel.isAnswered else { return .primary }
        if isCorrect { return .green }
        if isSelected { return .red }
        return .secondary
    }

    private func optionBackgroundColor(isSelected: Bool, isCorrect: Bool) -> Color {
        guard viewModel.isAnswered else { return Color.appCardBackground }
        if isCorrect { return Color.green.opacity(0.12) }
        if isSelected { return Color.red.opacity(0.12) }
        return Color.appCardBackground
    }

    private func optionBorderColor(isSelected: Bool, isCorrect: Bool) -> Color {
        guard viewModel.isAnswered else { return Color.primary.opacity(0.06) }
        if isCorrect { return .green }
        if isSelected { return .red }
        return .clear
    }

    // MARK: - Feedback Pedagógico do Teacher John

    @ViewBuilder
    private func teacherFeedbackCard(result: AnswerEvaluationResult) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header do resultado
            HStack {
                Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                    .foregroundStyle(result.isCorrect ? .green : .red)
                    .font(.title3)

                Text(result.isCorrect ? "Excelente resposta!" : (result.timedOut ? "Tempo esgotado!" : "Resposta incorreta"))
                    .font(.headline)
                    .foregroundStyle(result.isCorrect ? .green : .red)

                Spacer()

                if result.pointsEarned > 0 {
                    Text("+\(result.pointsEarned) pts")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.yellow.opacity(0.2))
                        .foregroundStyle(.orange)
                        .clipShape(Capsule())
                }
            }

            Divider()

            // Frase Completa Traduzida
            VStack(alignment: .leading, spacing: 4) {
                Text(result.exercise.fullSentence)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(result.exercise.sentenceTranslation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            // Análise Sintática
            VStack(alignment: .leading, spacing: 6) {
                Label("Por que está correto?", systemImage: "checkmark")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
                Text(result.exercise.whyCorrect)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Label("Por que as outras falham?", systemImage: "xmark")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
                Text(result.exercise.whyOthersFail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            // Dica de Ouro do John
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.title2)
                    .foregroundStyle(.blue)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Dica do Teacher John")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    Text(result.exercise.proTip)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                }
            }
            .padding(12)
            .background(Color.blue.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(16)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Barra Inferior

    @ViewBuilder
    private var bottomActionBar: some View {
        Button(action: {
            if viewModel.session.currentIndex + 1 < viewModel.session.totalCount {
                viewModel.nextQuestion()
            }
        }) {
            HStack {
                Text(viewModel.session.currentIndex + 1 < viewModel.session.totalCount ? "Próxima Questão" : "Ver Desempenho")
                    .font(.headline)
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Overlay de Fim de Sessão

    @ViewBuilder
    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.65)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: viewModel.session.status == .won ? "trophy.fill" : "heart.slash.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(viewModel.session.status == .won ? .yellow : .red)

                Text(viewModel.session.status == .won ? "Sessão Concluída!" : "Fim de Jogo!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(viewModel.session.status == .won
                     ? "Parabéns! Você completou todas as questões praticando conectivos em inglês."
                     : "Você perdeu as 3 vidas no Desafio Arcade. Treine no Modo Zen para fixar os conceitos antes de tentar novamente.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 8) {
                    Text("Pontuação Final: \(viewModel.session.score) pts")
                        .font(.headline)
                        .foregroundStyle(.yellow)
                    Text("Melhor Sequência (Streak): \(viewModel.session.bestStreak) acertos")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding()
                .background(Color.white.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Button("Voltar ao Hub de Conectivos") {
                    dismiss()
                }
                .fontWeight(.bold)
                .padding(.horizontal, 30)
                .padding(.vertical, 14)
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }
            .padding(28)
            .background(Color.appCardBackground.opacity(0.25))
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(24)
        }
    }
}

// Extensão utilitária para converter HEX para Color
private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview("Modo Zen") {
    let repo = ConnectorsRepository()
    let exercise = repo.loadSampleExercise()
    let session = ConnectorSession(
        mode: .zen,
        lives: 99,
        maxLives: 99,
        exercises: [exercise]
    )
    ConnectorPracticeView(viewModel: ConnectorPracticeViewModel(session: session, repository: repo))
}

private extension ConnectorsRepository {
    func loadSampleExercise() -> ConnectorExercise {
        LocalConnectorsDataSource().loadExercises()[0]
    }
}

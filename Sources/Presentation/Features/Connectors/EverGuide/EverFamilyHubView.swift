//
//  EverFamilyHubView.swift
//  English along with John - Presentation / Connectors / EverGuide
//

import SwiftUI

/// Hub Dedicado para a Família -Ever & Whereas com Guia Comparativo e Desafio de Fixação.
/// Mantido em bloco próprio e separado, fiel à experiência da aplicação web.
public struct EverFamilyHubView: View {
    @State private var selectedTab: EverTab = .guide
    @State private var everQuestions: [ConnectorExercise] = EverQuestionsData.questions

    public enum EverTab: String, CaseIterable, Identifiable {
        case guide = "Estudo Comparativo"
        case quiz = "Prática de Fixação (25 Frases)"

        public var id: String { rawValue }
    }

    public init() {}

    public var body: some View {
        VStack(spacing: 14) {
            // Seletor de Abas
            Picker("Aba", selection: $selectedTab) {
                ForEach(EverTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 8)

            if selectedTab == .guide {
                EverFamilyGuideView(isModal: false)
            } else {
                everQuizView
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Família -Ever & Whereas")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Aba de Prática Exclusiva com as 25 Frases da Família -Ever

    @ViewBuilder
    private var everQuizView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header Informativo
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.teal)
                        Text("Treino Focado: Regra Mental do Sufixo -Ever")
                            .font(.headline)
                            .fontWeight(.bold)
                    }

                    Text("Aplique a regra mnemônica (Pessoa, Lugar, Tempo, Objeto/Evento, Modo ou Contraste) para preencher a lacuna correta em cada frase:")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineSpacing(2)

                    HStack {
                        Label("\(everQuestions.count) frases práticas com explicações completas", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.teal)
                    }
                    .padding(.top, 4)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)

                // Lista de Exercícios
                LazyVStack(spacing: 14) {
                    ForEach(Array(everQuestions.enumerated()), id: \.element.id) { index, exercise in
                        EverExerciseCardView(index: index + 1, exercise: exercise)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Card Interativo do Exercício da Família -Ever

private struct EverExerciseCardView: View {
    let index: Int
    let exercise: ConnectorExercise

    @State private var selectedOptionId: String? = nil
    @State private var isAnswered: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Número e Badge
            HStack {
                Text("Questão #\(index)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 6) {
                    Button(action: {
                        SpeechSynthesizerService.shared.speak(exercise.connectorTerm)
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.caption2)
                            .foregroundStyle(.teal)
                    }
                    .buttonStyle(.plain)

                    Text(exercise.connectorTerm)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.teal.opacity(0.12))
                        .foregroundStyle(.teal)
                        .clipShape(Capsule())
                }
            }

            // Prompt
            Text(exercise.prompt)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineSpacing(3)

            // Opções
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                ForEach(exercise.options) { option in
                    let isSelected = selectedOptionId == option.id
                    let isCorrect = option.id == exercise.correctOptionId

                    Button(action: {
                        selectedOptionId = option.id
                        isAnswered = true
                    }) {
                        HStack {
                            Text(option.text)
                                .font(.footnote)
                                .fontWeight(.bold)
                            Spacer()
                            if isAnswered {
                                if isCorrect {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else if isSelected {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(buttonBackground(isCorrect: isCorrect, isSelected: isSelected))
                        .foregroundStyle(isAnswered && (isCorrect || isSelected) ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .disabled(isAnswered)
                }
            }

            // Explicação Pedagógica Contextual ao Responder
            if isAnswered {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: selectedOptionId == exercise.correctOptionId ? "checkmark.circle.fill" : "info.circle.fill")
                            .foregroundStyle(selectedOptionId == exercise.correctOptionId ? .green : .orange)
                        Text(selectedOptionId == exercise.correctOptionId ? "Correto!" : "Resposta correta: \(exercise.connectorTerm)")
                            .font(.footnote)
                            .fontWeight(.bold)
                    }

                    HStack(alignment: .top, spacing: 6) {
                        Button(action: {
                            SpeechSynthesizerService.shared.speak(exercise.fullSentence)
                        }) {
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.caption2)
                                .foregroundStyle(.teal)
                        }
                        .buttonStyle(.plain)

                        Text("Tradução: \"\(exercise.sentenceTranslation)\"")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Text(exercise.explanation)
                        .font(.caption2)
                        .foregroundStyle(.primary)

                    if !exercise.proTip.isEmpty {
                        Text("💡 Dica de Ouro: \(exercise.proTip)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.teal)
                            .padding(.top, 2)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.teal.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(14)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func buttonBackground(isCorrect: Bool, isSelected: Bool) -> Color {
        guard isAnswered else { return Color.appBackground }
        if isCorrect { return Color.green }
        if isSelected { return Color.red }
        return Color.appBackground
    }
}

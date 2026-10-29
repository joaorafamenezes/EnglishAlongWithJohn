//
//  IdiomaticExpressionsHubView.swift
//  English along with John - Presentation / IdiomaticExpressions
//

import SwiftUI

/// Hub e Jogo Completo das 49 Expressões Idiomáticas.
/// Fiel à aplicação web (Connectors in English), contendo:
/// 1. Desafio de Significados (Quiz com distratores dinâmicos, rodadas configuráveis e áudio nativo)
/// 2. Dicionário das 49 Expressões com Áudio Nativo, Origem Cultural e Marcação de Maestria.
public struct IdiomaticExpressionsHubView: View {
    @State private var expressions: [IdiomaticExpression] = []
    @State private var selectedTab: Tab = .quiz
    @State private var masteredIds: Set<String> = []

    private let dataSource = LocalIdiomaticExpressionsDataSource()

    public enum Tab: String, CaseIterable, Identifiable {
        case quiz = "Desafio de Significados"
        case catalog = "Guia & Expressões"

        public var id: String { rawValue }
    }

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Header
                IdiomaticHeaderView(totalExpressions: expressions.count)

                // Seletor de Abas
                Picker("Aba", selection: $selectedTab) {
                    ForEach(Tab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)

                // Conteúdo
                if selectedTab == .quiz {
                    IdiomaticQuizSectionView(allExpressions: expressions)
                } else {
                    IdiomaticCatalogSectionView(
                        allExpressions: expressions,
                        masteredIds: $masteredIds
                    )
                }
            }
            .padding(.vertical, 14)
        }
        .background(Color.appBackground)
        .navigationTitle("Expressões Idiomáticas")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            expressions = dataSource.loadExpressions()
            loadMasteredIds()
        }
    }

    private func loadMasteredIds() {
        if let stored = UserDefaults.standard.stringArray(forKey: "mastered_idiomatic_expressions") {
            masteredIds = Set(stored)
        }
    }
}

// MARK: - 1. Header

private struct IdiomaticHeaderView: View {
    let totalExpressions: Int

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                Image(systemName: "quote.bubble.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Expressões Idiomáticas")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Text("\(totalExpressions) expressões reais com áudio nativo e quiz contextual")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(14)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
}

// MARK: - 2. Sub-Modo: Quiz de Significados

private struct IdiomaticQuizSectionView: View {
    let allExpressions: [IdiomaticExpression]

    @State private var roundSize: Int = 10
    @State private var roundQuestions: [IdiomaticExpression] = []
    @State private var questionIndex: Int = 0
    @State private var selectedOptionId: String? = nil
    @State private var score: Int = 0
    @State private var isRoundComplete: Bool = false
    @State private var currentOptions: [IdiomAnswerOption] = []

    private var currentQuestion: IdiomaticExpression? {
        guard questionIndex < roundQuestions.count else { return nil }
        return roundQuestions[questionIndex]
    }

    var body: some View {
        VStack(spacing: 14) {
            if isRoundComplete {
                IdiomRoundCompletedView(
                    score: score,
                    total: roundQuestions.count,
                    onPlayAgain: startRound
                )
            } else if let q = currentQuestion {
                // Card do Quiz
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Expressão \(questionIndex + 1) de \(roundQuestions.count)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("Pontos: \(score)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.purple)
                    }

                    // Expressão com Botão de Áudio
                    HStack(spacing: 8) {
                        Text("\"\(q.expression)\"")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundStyle(.primary)

                        Button(action: {
                            SpeechSynthesizerService.shared.speak(q.expression)
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.subheadline)
                                .foregroundStyle(.purple)
                        }
                        .buttonStyle(.plain)
                    }

                    if let cultural = q.culturalNote, !cultural.isEmpty {
                        Text("Definição em inglês: \(cultural)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)
                    }

                    // Exemplo em Contexto
                    HStack(alignment: .top, spacing: 6) {
                        Button(action: {
                            SpeechSynthesizerService.shared.speak(q.exampleEn)
                        }) {
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.caption2)
                                .foregroundStyle(.purple.opacity(0.8))
                        }
                        .buttonStyle(.plain)

                        Text("Exemplo: \"\(q.exampleEn)\"")
                            .font(.caption2)
                            .italic()
                            .foregroundStyle(.primary.opacity(0.9))
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.purple.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    Text("Qual é o significado em português?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    // 4 Alternativas
                    VStack(spacing: 8) {
                        ForEach(currentOptions) { opt in
                            let isSelected = selectedOptionId == opt.id
                            let isCorrect = opt.id == q.id
                            let isAnswered = selectedOptionId != nil

                            Button(action: {
                                handleAnswer(opt.id, correctId: q.id)
                            }) {
                                HStack {
                                    Text(opt.text)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
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
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .background(optionBg(isAnswered: isAnswered, isCorrect: isCorrect, isSelected: isSelected))
                                .foregroundStyle(isAnswered && (isCorrect || isSelected) ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                            .disabled(isAnswered)
                        }
                    }

                    // Botão Avançar
                    if selectedOptionId != nil {
                        Button(action: advance) {
                            HStack {
                                Text(questionIndex + 1 == roundQuestions.count ? "Ver Resultado da Rodada" : "Próxima Expressão")
                                    .fontWeight(.bold)
                                Image(systemName: "arrow.right")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.purple)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 4)
                    }
                }
                .padding(16)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            if roundQuestions.isEmpty && !allExpressions.isEmpty {
                startRound()
            }
        }
    }

    private func startRound() {
        roundQuestions = allExpressions.shuffled().prefix(roundSize).map { $0 }
        questionIndex = 0
        selectedOptionId = nil
        score = 0
        isRoundComplete = false
        loadOptionsForCurrent()
    }

    private func loadOptionsForCurrent() {
        guard questionIndex < roundQuestions.count else { return }
        let current = roundQuestions[questionIndex]
        var opts: [IdiomAnswerOption] = [IdiomAnswerOption(id: current.id, text: current.meaningPt)]
        let distractors = allExpressions.filter { $0.id != current.id }.shuffled().prefix(3)
        for d in distractors {
            opts.append(IdiomAnswerOption(id: d.id, text: d.meaningPt))
        }
        currentOptions = opts.shuffled()
    }

    private func handleAnswer(_ id: String, correctId: String) {
        selectedOptionId = id
        if id == correctId {
            score += 100
        }
    }

    private func advance() {
        if questionIndex + 1 >= roundQuestions.count {
            isRoundComplete = true
        } else {
            questionIndex += 1
            selectedOptionId = nil
            loadOptionsForCurrent()
        }
    }

    private func optionBg(isAnswered: Bool, isCorrect: Bool, isSelected: Bool) -> Color {
        guard isAnswered else { return Color.appBackground }
        if isCorrect { return Color.green }
        if isSelected { return Color.red }
        return Color.appBackground
    }
}

private struct IdiomAnswerOption: Identifiable {
    let id: String
    let text: String
}

private struct IdiomRoundCompletedView: View {
    let score: Int
    let total: Int
    let onPlayAgain: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 54))
                .foregroundStyle(.yellow)

            Text("Rodada Concluída!")
                .font(.title2)
                .fontWeight(.bold)

            Text("Você fez \(score) pontos de um total de \(total * 100) possíveis.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: onPlayAgain) {
                HStack {
                    Text("Jogar Nova Rodada")
                        .fontWeight(.bold)
                    Image(systemName: "arrow.clockwise")
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(Color.purple)
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 16)
    }
}

// MARK: - 3. Sub-Modo: Dicionário das 49 Expressões

private struct IdiomaticCatalogSectionView: View {
    let allExpressions: [IdiomaticExpression]
    @Binding var masteredIds: Set<String>

    @State private var searchText: String = ""

    private var filteredList: [IdiomaticExpression] {
        if searchText.isEmpty {
            return allExpressions
        }
        let q = searchText.lowercased()
        return allExpressions.filter {
            $0.expression.lowercased().contains(q) ||
            $0.meaningPt.lowercased().contains(q) ||
            ($0.culturalNote?.lowercased().contains(q) ?? false)
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            // Barra de Busca
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Buscar expressão ou tradução...", text: $searchText)
                    .font(.footnote)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(12)
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)

            // Contagem
            HStack {
                Text("\(filteredList.count) expressões encontradas")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(masteredIds.count) dominadas ★")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
            }
            .padding(.horizontal, 16)

            // Lista de Cards
            LazyVStack(spacing: 12) {
                ForEach(filteredList) { item in
                    IdiomCardItemView(
                        item: item,
                        isMastered: masteredIds.contains(item.id),
                        onToggleMastery: {
                            toggleMastered(item.id)
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func toggleMastered(_ id: String) {
        if masteredIds.contains(id) {
            masteredIds.remove(id)
        } else {
            masteredIds.insert(id)
        }
        UserDefaults.standard.set(Array(masteredIds), forKey: "mastered_idiomatic_expressions")
    }
}

private struct IdiomCardItemView: View {
    let item: IdiomaticExpression
    let isMastered: Bool
    let onToggleMastery: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.expression)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Button(action: {
                    SpeechSynthesizerService.shared.speak(item.expression)
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.caption)
                        .foregroundStyle(.purple)
                }
                .buttonStyle(.plain)

                Spacer()
            }

            Text("Significado real: **\(item.meaningPt)**")
                .font(.footnote)
                .foregroundStyle(.primary)

            if let note = item.culturalNote, !note.isEmpty {
                Text("Definição: \(note)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            // Exemplo de uso
            HStack(alignment: .top, spacing: 6) {
                Button(action: {
                    SpeechSynthesizerService.shared.speak(item.exampleEn)
                }) {
                    Image(systemName: "speaker.wave.1.fill")
                        .font(.caption2)
                        .foregroundStyle(.purple.opacity(0.8))
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\"\(item.exampleEn)\"")
                        .font(.caption2)
                        .italic()
                        .foregroundStyle(.primary.opacity(0.9))
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.purple.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Divider()

            // Botão de Maestria
            Button(action: onToggleMastery) {
                HStack(spacing: 6) {
                    Image(systemName: isMastered ? "star.fill" : "star")
                        .font(.caption2)
                    Text(isMastered ? "★ Dominada" : "☆ Marcar como dominada")
                        .font(.caption2)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(isMastered ? Color.green.opacity(0.15) : Color.appBackground)
                .foregroundStyle(isMastered ? Color.green : Color.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

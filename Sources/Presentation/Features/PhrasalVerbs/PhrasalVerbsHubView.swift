//
//  PhrasalVerbsHubView.swift
//  English along with John - Presentation / PhrasalVerbs
//

import SwiftUI

/// Tela Principal e Hub do Jogo de Phrasal Verbs.
public struct PhrasalVerbsHubView: View {
    @State private var selectedSubMode: SubMode = .quiz
    @State private var phrasalVerbs: [PhrasalVerb] = []
    @State private var masteredIds: Set<String> = []
    @State private var selectedLevel: PhrasalVerbLevel = .all

    // Estados do Quiz
    @State private var quizIndex: Int = 0
    @State private var quizScore: Int = 0
    @State private var quizStreak: Int = 0
    @State private var quizLives: Int = 3
    @State private var quizSelectedOption: String? = nil
    @State private var quizFeedbackRevealed: Bool = false
    @State private var isArcade: Bool = false
    @State private var currentQuizOptions: [String] = []

    // Estados do Match
    @State private var matchTiles: [MatchTile] = []
    @State private var matchSelectedTile: MatchTile? = nil
    @State private var matchMatchedPairs: Set<String> = []
    @State private var matchFailedTiles: Set<String> = []
    @State private var matchRoundsWon: Int = 0

    private let dataSource = LocalPhrasalVerbsDataSource()

    public enum SubMode: String, CaseIterable, Identifiable {
        case quiz = "Desafio das Frases"
        case match = "Match Rápido"
        case deck = "Deck Didático"

        public var id: String { rawValue }
    }

    public init() {}

    private var filteredVerbs: [PhrasalVerb] {
        if selectedLevel == .all {
            return phrasalVerbs
        }
        return phrasalVerbs.filter { $0.level == selectedLevel }
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Temático
                headerView

                // Seletor de Modo: Quiz vs Match vs Deck
                Picker("Sub-modo", selection: $selectedSubMode) {
                    ForEach(SubMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Conteúdo do Modo Ativo
                switch selectedSubMode {
                case .quiz:
                    quizView
                case .match:
                    matchView
                case .deck:
                    deckView
                }
            }
            .padding(.vertical)
        }
        .background(Color.appBackground)
        .navigationTitle("Phrasal Verbs Game")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            loadInitialData()
        }
        .onChange(of: selectedLevel) { _, _ in
            quizIndex = 0
            quizFeedbackRevealed = false
            quizSelectedOption = nil
            loadCurrentQuizQuestion()
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var headerView: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: "figure.run.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .padding(8)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Phrasal Verbs Game")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(phrasalVerbs.count) verbos frasais com partículas e contexto real")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    // MARK: - Sub-Modo 1: Quiz das Frases

    @ViewBuilder
    private var quizView: some View {
        VStack(spacing: 16) {
            // Controles de Modo: Zen vs Arcade
            HStack {
                Button(action: { isArcade = false }) {
                    Label("Modo Zen", systemImage: "leaf.fill")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(!isArcade ? Color.green : Color.appCardBackground)
                        .foregroundStyle(!isArcade ? .white : .primary)
                        .clipShape(Capsule())
                }

                Button(action: { isArcade = true }) {
                    Label("Modo Arcade", systemImage: "bolt.fill")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isArcade ? Color.orange : Color.appCardBackground)
                        .foregroundStyle(isArcade ? .white : .primary)
                        .clipShape(Capsule())
                }

                Spacer()

                if isArcade {
                    HStack(spacing: 2) {
                        ForEach(0..<3) { heart in
                            Image(systemName: heart < quizLives ? "heart.fill" : "heart")
                                .foregroundStyle(.red)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding(.horizontal)

            if !filteredVerbs.isEmpty {
                let currentItem = filteredVerbs[quizIndex % filteredVerbs.count]
                let questionSentence = currentItem.maskedSentence

                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Questão \((quizIndex % filteredVerbs.count) + 1) de \(filteredVerbs.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(currentItem.level.rawValue)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.orange.opacity(0.15))
                            .foregroundStyle(.orange)
                            .clipShape(Capsule())
                    }

                    Text(questionSentence)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineSpacing(4)

                    Text("Tradução de apoio: \(currentItem.examplePt)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    // Opções fixas durante a exibição da questão
                    let activeOptions = currentQuizOptions.isEmpty ? generateQuizOptions(correct: currentItem) : currentQuizOptions

                    VStack(spacing: 10) {
                        ForEach(activeOptions, id: \.self) { option in
                            Button(action: {
                                handleQuizOptionSelected(option, correct: currentItem.phrasalVerb, activeOptions: activeOptions)
                            }) {
                                HStack {
                                    Text(option)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    if quizFeedbackRevealed {
                                        if option.lowercased() == currentItem.phrasalVerb.lowercased() {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.green)
                                        } else if quizSelectedOption == option {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.red)
                                        }
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(quizOptionBackground(option, correct: currentItem.phrasalVerb))
                                .foregroundStyle(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(quizFeedbackRevealed)
                        }
                    }
                    .onAppear {
                        if currentQuizOptions.isEmpty {
                            currentQuizOptions = activeOptions
                        }
                    }

                    if quizFeedbackRevealed {
                        // Explicação pedagógica contextual
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: quizSelectedOption?.lowercased() == currentItem.phrasalVerb.lowercased() ? "checkmark.circle.fill" : "info.circle.fill")
                                    .foregroundStyle(quizSelectedOption?.lowercased() == currentItem.phrasalVerb.lowercased() ? .green : .orange)
                                Text(quizSelectedOption?.lowercased() == currentItem.phrasalVerb.lowercased() ? "Correto!" : "Resposta correta:")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }

                            Text("**\(currentItem.phrasalVerb)**: \(currentItem.meaningPt)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)

                            Text("Frase contextual completa: \"\(currentItem.exampleEn)\"")
                                .font(.caption)
                                .italic()
                                .foregroundStyle(.blue)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.appCardBackground.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        Button(action: advanceQuiz) {
                            HStack {
                                Text("Avançar para a próxima")
                                    .fontWeight(.bold)
                                Image(systemName: "arrow.right")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding()
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                .onAppear {
                    if currentQuizOptions.isEmpty && !filteredVerbs.isEmpty {
                        loadCurrentQuizQuestion()
                    }
                }
            }

        }
    }

    // MARK: - Sub-Modo 2: Match Rápido

    @ViewBuilder
    private var matchView: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Associe o Phrasal Verb ao seu significado em português:")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(action: { startNewMatchRound() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.footnote)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(matchTiles) { tile in
                    if !matchMatchedPairs.contains(tile.pairId) {
                        let isSelected = matchSelectedTile?.id == tile.id
                        let isFailed = matchFailedTiles.contains(tile.id)

                        Button(action: { handleMatchTileTap(tile) }) {
                            Text(tile.text)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(isFailed ? .white : (isSelected ? .white : .primary))
                                .frame(maxWidth: .infinity)
                                .frame(height: 64)
                                .padding(6)
                                .background(isFailed ? Color.red : (isSelected ? Color.orange : Color.appCardBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    } else {
                        Color.clear.frame(height: 64)
                    }
                }
            }
            .padding(.horizontal)

            if matchMatchedPairs.count == matchTiles.count / 2 && !matchTiles.isEmpty {
                VStack(spacing: 10) {
                    Text("🎉 Rodada de Phrasal Verbs Concluída!")
                        .font(.headline)
                        .foregroundStyle(.green)
                    Button("Jogar Nova Rodada") {
                        startNewMatchRound()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }

    // MARK: - Sub-Modo 3: Deck Didático

    @ViewBuilder
    private var deckView: some View {
        VStack(spacing: 14) {
            // Seletor de Níveis
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(PhrasalVerbLevel.allCases) { level in
                        Button(action: { selectedLevel = level }) {
                            Text(level.rawValue)
                                .font(.caption)
                                .fontWeight(selectedLevel == level ? .bold : .regular)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedLevel == level ? Color.orange : Color.appCardBackground)
                                .foregroundStyle(selectedLevel == level ? .white : .primary)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
            }

            LazyVStack(spacing: 12) {
                ForEach(filteredVerbs) { verb in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(verb.phrasalVerb)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)

                            Spacer()

                            Text(verb.level.rawValue)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.12))
                                .foregroundStyle(.orange)
                                .clipShape(Capsule())
                        }

                        Text("Significado: \(verb.meaningPt)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\"\(verb.exampleEn)\"")
                                .font(.footnote)
                                .italic()
                                .foregroundStyle(.blue)
                            Text(verb.examplePt)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(14)
                    .background(Color.appCardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Funções Auxiliares

    private func loadInitialData() {
        phrasalVerbs = dataSource.loadPhrasalVerbs()
        loadCurrentQuizQuestion()
        startNewMatchRound()
    }

    private func loadCurrentQuizQuestion() {
        guard !filteredVerbs.isEmpty else {
            currentQuizOptions = []
            return
        }
        let currentItem = filteredVerbs[quizIndex % filteredVerbs.count]
        currentQuizOptions = generateQuizOptions(correct: currentItem)
    }

    private func generateQuizOptions(correct: PhrasalVerb) -> [String] {
        var options = [correct.phrasalVerb]
        let otherVerbs = phrasalVerbs.filter { $0.id != correct.id }
        let distractors = otherVerbs.shuffled().prefix(3).map { $0.phrasalVerb }
        options.append(contentsOf: distractors)
        return options.shuffled()
    }

    private func handleQuizOptionSelected(_ option: String, correct: String, activeOptions: [String]) {
        if currentQuizOptions.isEmpty {
            currentQuizOptions = activeOptions
        }
        quizSelectedOption = option
        quizFeedbackRevealed = true

        if option.lowercased() == correct.lowercased() {
            quizScore += 100
            quizStreak += 1
        } else {
            quizStreak = 0
            if isArcade && quizLives > 0 {
                quizLives -= 1
            }
        }
    }

    private func advanceQuiz() {
        quizFeedbackRevealed = false
        quizSelectedOption = nil
        quizIndex += 1
        loadCurrentQuizQuestion()
    }

    private func quizOptionBackground(_ option: String, correct: String) -> Color {
        guard quizFeedbackRevealed else { return Color.appBackground }
        if option.lowercased() == correct.lowercased() {
            return Color.green.opacity(0.2)
        }
        if quizSelectedOption == option {
            return Color.red.opacity(0.2)
        }
        return Color.appBackground
    }

    private func startNewMatchRound() {
        matchSelectedTile = nil
        matchMatchedPairs.removeAll()
        matchFailedTiles.removeAll()

        let sample = phrasalVerbs.shuffled().prefix(6)
        var newTiles: [MatchTile] = []
        for item in sample {
            newTiles.append(MatchTile(id: "en-\(item.id)", pairId: item.id, text: item.phrasalVerb, lang: .english))
            newTiles.append(MatchTile(id: "pt-\(item.id)", pairId: item.id, text: item.meaningPt, lang: .portuguese))
        }
        matchTiles = newTiles.shuffled()
    }

    private func handleMatchTileTap(_ tile: MatchTile) {
        guard matchFailedTiles.isEmpty else { return }

        if matchSelectedTile?.id == tile.id {
            matchSelectedTile = nil
            return
        }

        guard let first = matchSelectedTile else {
            matchSelectedTile = tile
            return
        }

        if first.lang == tile.lang {
            matchSelectedTile = tile
            return
        }

        if first.pairId == tile.pairId {
            withAnimation {
                matchMatchedPairs.insert(tile.pairId)
                matchSelectedTile = nil
            }
        } else {
            matchFailedTiles = [first.id, tile.id]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation {
                    matchFailedTiles.removeAll()
                    matchSelectedTile = nil
                }
            }
        }
    }
}

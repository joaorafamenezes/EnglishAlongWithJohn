//
//  PhrasalVerbsHubView.swift
//  English along with John - Presentation / PhrasalVerbs
//

import SwiftUI

/// Hub e Game Completo dos Phrasal Verbs (A1 a B2).
/// Fiel à aplicação web (Connectors in English), contendo:
/// 1. Desafio das Frases (Quiz de Lacunas nos modos Zen e Arcade)
/// 2. Match Rápido (Associação por tempo e streaks)
/// 3. Dicionário dos 108 Cards Interativos com Áudio Nativo e Maestria
public struct PhrasalVerbsHubView: View {
    @State private var selectedSubMode: SubMode = .quiz
    @State private var allVerbs: [PhrasalVerb] = []
    @State private var masteredIds: Set<String> = []
    @State private var selectedLevel: PhrasalVerbLevel = .all

    private let dataSource = LocalPhrasalVerbsDataSource()

    public enum SubMode: String, CaseIterable, Identifiable {
        case quiz = "Desafio das Frases"
        case match = "Match Rápido"
        case deck = "Deck dos 108 Verbos"

        public var id: String { rawValue }
    }

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Header com Badge e Ícone
                PhrasalVerbsHeaderView(totalVerbs: allVerbs.count)

                // Seletor de Modo
                Picker("Sub-modo", selection: $selectedSubMode) {
                    ForEach(SubMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)

                // Visualização do Modo Selecionado
                switch selectedSubMode {
                case .quiz:
                    PhrasalVerbQuizSectionView(selectedLevel: selectedLevel)
                case .match:
                    PhrasalVerbMatchSectionView(allVerbs: allVerbs, selectedLevel: selectedLevel)
                case .deck:
                    PhrasalVerbDeckSectionView(
                        allVerbs: allVerbs,
                        masteredIds: $masteredIds,
                        selectedLevel: $selectedLevel
                    )
                }
            }
            .padding(.vertical, 14)
        }
        .background(Color.appBackground)
        .navigationTitle("Phrasal Verbs Academy")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            allVerbs = dataSource.loadPhrasalVerbs()
            loadMasteredIds()
        }
    }

    private func loadMasteredIds() {
        if let stored = UserDefaults.standard.stringArray(forKey: "mastered_phrasal_verbs") {
            masteredIds = Set(stored)
        }
    }
}

// MARK: - 1. Header do Módulo

private struct PhrasalVerbsHeaderView: View {
    let totalVerbs: Int

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                Image(systemName: "figure.run.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Phrasal Verbs Academy")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Text("\(totalVerbs) verbos reais com áudio, match e quiz de preenchimento")
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

// MARK: - 2. Sub-Modo: Quiz de Lacunas (Zen & Arcade)

private struct PhrasalVerbQuizSectionView: View {
    let selectedLevel: PhrasalVerbLevel

    @State private var questions: [PhrasalVerbQuizQuestion] = PhrasalVerbsQuestionsData.questions
    @State private var currentIndex: Int = 0
    @State private var isArcade: Bool = false
    @State private var lives: Int = 3
    @State private var score: Int = 0
    @State private var streak: Int = 0
    @State private var selectedOptionId: String? = nil
    @State private var isAnswered: Bool = false

    private var filteredQuestions: [PhrasalVerbQuizQuestion] {
        if selectedLevel == .all {
            return questions
        }
        let list = questions.filter { $0.level == selectedLevel }
        return list.isEmpty ? questions : list
    }

    private var currentQuestion: PhrasalVerbQuizQuestion? {
        guard !filteredQuestions.isEmpty else { return nil }
        return filteredQuestions[currentIndex % filteredQuestions.count]
    }

    var body: some View {
        VStack(spacing: 14) {
            // Controles de Modo: Zen vs Arcade e Vidas
            HStack {
                Button(action: { isArcade = false }) {
                    Label("Modo Zen", systemImage: "leaf.fill")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(!isArcade ? Color.green : Color.appCardBackground)
                        .foregroundStyle(!isArcade ? .white : .primary)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Button(action: {
                    isArcade = true
                    lives = 3
                }) {
                    Label("Modo Arcade", systemImage: "bolt.fill")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(isArcade ? Color.orange : Color.appCardBackground)
                        .foregroundStyle(isArcade ? .white : .primary)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Spacer()

                if isArcade {
                    HStack(spacing: 3) {
                        ForEach(0..<3) { i in
                            Image(systemName: i < lives ? "heart.fill" : "heart")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)

            if let q = currentQuestion {
                VStack(alignment: .leading, spacing: 14) {
                    // Header da Questão com Botão de Áudio
                    HStack {
                        Text("Questão \((currentIndex % filteredQuestions.count) + 1) de \(filteredQuestions.count)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Button(action: {
                            SpeechSynthesizerService.shared.speak(q.fullSentence)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "speaker.wave.2.fill")
                                Text("Ouvir Frase")
                            }
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.12))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)

                        Text(q.level.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.orange.opacity(0.15))
                            .foregroundStyle(.orange)
                            .clipShape(Capsule())
                    }

                    // Frase com lacuna
                    Text(q.prompt)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineSpacing(3)
                        .foregroundStyle(.primary)

                    Text("Significado: \(q.meaningPt)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    // 4 Opções
                    VStack(spacing: 8) {
                        ForEach(q.options, id: \.id) { (option: QuestionOption) in
                            let isSelected: Bool = selectedOptionId == option.id
                            let isCorrect: Bool = option.id == q.correctOptionId

                            Button(action: {
                                handleOptionTap(optionId: option.id, correctId: q.correctOptionId)
                            }) {
                                HStack {
                                    Text(option.text)
                                        .font(.subheadline)
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
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .background(optionBg(isSelected: isSelected, isCorrect: isCorrect))
                                .foregroundStyle(isAnswered && (isCorrect || isSelected) ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                            .disabled(isAnswered)
                        }
                    }

                    // Feedback Pedagógico Completo
                    if isAnswered {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: selectedOptionId == q.correctOptionId ? "checkmark.circle.fill" : "info.circle.fill")
                                    .foregroundStyle(selectedOptionId == q.correctOptionId ? .green : .orange)
                                Text(selectedOptionId == q.correctOptionId ? "Correto!" : "Resposta correta: \(q.phrasalVerb)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }

                            Text("Tradução: \"\(q.sentenceTranslation)\"")
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text(q.whyCorrect)
                                .font(.caption2)
                                .foregroundStyle(.primary)

                            if !q.teacherTip.isEmpty {
                                Text("💡 Dica do Professor: \(q.teacherTip)")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.orange)
                            }

                            Button(action: advance) {
                                HStack {
                                    Text("Próxima Frase")
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 4)
                        }
                        .padding(14)
                        .background(Color.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(16)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
            }
        }
    }

    private func handleOptionTap(optionId: String, correctId: String) {
        selectedOptionId = optionId
        isAnswered = true
        if optionId == correctId {
            score += 100
            streak += 1
        } else {
            streak = 0
            if isArcade && lives > 0 {
                lives -= 1
            }
        }
    }

    private func advance() {
        isAnswered = false
        selectedOptionId = nil
        currentIndex += 1
    }

    private func optionBg(isSelected: Bool, isCorrect: Bool) -> Color {
        guard isAnswered else { return Color.appBackground }
        if isCorrect { return Color.green }
        if isSelected { return Color.red }
        return Color.appBackground
    }
}

// MARK: - 3. Sub-Modo: Match Rápido (Associação)

private struct PhrasalVerbMatchSectionView: View {
    let allVerbs: [PhrasalVerb]
    let selectedLevel: PhrasalVerbLevel

    @State private var matchTiles: [MatchTile] = []
    @State private var selectedTile: MatchTile? = nil
    @State private var matchedPairIds: Set<String> = []
    @State private var failedTileIds: Set<String> = []
    @State private var roundsWon: Int = 0

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Associe o Phrasal Verb ao seu significado:")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(action: startRound) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(matchTiles) { tile in
                    if !matchedPairIds.contains(tile.pairId) {
                        let isSelected = selectedTile?.id == tile.id
                        let isFailed = failedTileIds.contains(tile.id)

                        Button(action: { handleTileTap(tile) }) {
                            Text(tile.text)
                                .font(.caption)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(isFailed ? .white : (isSelected ? .white : .primary))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .padding(6)
                                .background(isFailed ? Color.red : (isSelected ? Color.orange : Color.appCardBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    } else {
                        Color.clear.frame(height: 60)
                    }
                }
            }
            .padding(.horizontal, 16)

            if matchedPairIds.count == matchTiles.count / 2 && !matchTiles.isEmpty {
                VStack(spacing: 10) {
                    Text("🎉 Rodada de Phrasal Verbs Concluída!")
                        .font(.headline)
                        .foregroundStyle(.green)
                    Button("Jogar Nova Rodada") {
                        startRound()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .onAppear {
            if matchTiles.isEmpty {
                startRound()
            }
        }
    }

    private func startRound() {
        selectedTile = nil
        matchedPairIds.removeAll()
        failedTileIds.removeAll()

        let pool = selectedLevel == .all ? allVerbs : allVerbs.filter { $0.level == selectedLevel }
        let sample = (pool.isEmpty ? allVerbs : pool).shuffled().prefix(6)
        var newTiles: [MatchTile] = []
        for item in sample {
            newTiles.append(MatchTile(id: "en-\(item.id)", pairId: item.id, text: item.phrasalVerb, lang: .english))
            newTiles.append(MatchTile(id: "pt-\(item.id)", pairId: item.id, text: item.meaningPt, lang: .portuguese))
        }
        matchTiles = newTiles.shuffled()
    }

    private func handleTileTap(_ tile: MatchTile) {
        guard failedTileIds.isEmpty else { return }

        if selectedTile?.id == tile.id {
            selectedTile = nil
            return
        }

        guard let first = selectedTile else {
            selectedTile = tile
            return
        }

        if first.lang == tile.lang {
            selectedTile = tile
            return
        }

        if first.pairId == tile.pairId {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                matchedPairIds.insert(tile.pairId)
                selectedTile = nil
            }
            if matchedPairIds.count == matchTiles.count / 2 {
                roundsWon += 1
            }
        } else {
            failedTileIds = [first.id, tile.id]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation {
                    failedTileIds.removeAll()
                    selectedTile = nil
                }
            }
        }
    }
}

// MARK: - 4. Sub-Modo: Deck dos 108 Phrasal Verbs

private struct PhrasalVerbDeckSectionView: View {
    let allVerbs: [PhrasalVerb]
    @Binding var masteredIds: Set<String>
    @Binding var selectedLevel: PhrasalVerbLevel

    @State private var searchText: String = ""

    private var filteredList: [PhrasalVerb] {
        var list = allVerbs
        if selectedLevel != .all {
            list = list.filter { $0.level == selectedLevel }
        }
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            list = list.filter {
                $0.phrasalVerb.lowercased().contains(q) ||
                $0.meaningPt.lowercased().contains(q) ||
                $0.category.lowercased().contains(q) ||
                $0.meaningEn.lowercased().contains(q)
            }
        }
        return list
    }

    var body: some View {
        VStack(spacing: 14) {
            // Barra de Busca
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Buscar phrasal verb, tradução ou categoria...", text: $searchText)
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

            // Filtros de Nível
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(PhrasalVerbLevel.allCases) { level in
                        Button(action: { selectedLevel = level }) {
                            Text(level.rawValue)
                                .font(.caption2)
                                .fontWeight(selectedLevel == level ? .bold : .regular)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedLevel == level ? Color.orange : Color.appCardBackground)
                                .foregroundStyle(selectedLevel == level ? .white : .primary)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }

            // Contador de Verbos
            HStack {
                Text("\(filteredList.count) phrasal verbs")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(masteredIds.count) dominados ★")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
            }
            .padding(.horizontal, 16)

            // Lista de Cards
            LazyVStack(spacing: 12) {
                ForEach(filteredList) { verb in
                    PhrasalVerbCardItemView(
                        verb: verb,
                        isMastered: masteredIds.contains(verb.id),
                        onToggleMastery: {
                            toggleMastered(verb.id)
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
        UserDefaults.standard.set(Array(masteredIds), forKey: "mastered_phrasal_verbs")
    }
}

private struct PhrasalVerbCardItemView: View {
    let verb: PhrasalVerb
    let isMastered: Bool
    let onToggleMastery: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(verb.phrasalVerb)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        Button(action: {
                            SpeechSynthesizerService.shared.speak(verb.phrasalVerb)
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }

                    Text("Significado: \(verb.meaningPt)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(verb.level.rawValue)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.orange.opacity(0.12))
                    .foregroundStyle(.orange)
                    .clipShape(Capsule())
            }

            if !verb.meaningEn.isEmpty {
                Text(verb.meaningEn)
                    .font(.caption2)
                    .italic()
                    .foregroundStyle(.secondary)
            }

            // Exemplos reais
            VStack(alignment: .leading, spacing: 4) {
                ForEach(verb.examples, id: \.self) { ex in
                    HStack(alignment: .top, spacing: 6) {
                        Button(action: {
                            SpeechSynthesizerService.shared.speak(ex)
                        }) {
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.caption2)
                                .foregroundStyle(.blue.opacity(0.8))
                        }
                        .buttonStyle(.plain)

                        Text("• \"\(ex)\"")
                            .font(.caption2)
                            .foregroundStyle(.primary.opacity(0.9))
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            if !verb.teacherTip.isEmpty {
                Text("💡 \(verb.teacherTip)")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }

            Divider()

            // Botão de Maestria
            Button(action: onToggleMastery) {
                HStack(spacing: 6) {
                    Image(systemName: isMastered ? "star.fill" : "star")
                        .font(.caption2)
                    Text(isMastered ? "★ Dominado" : "☆ Marcar como dominado")
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

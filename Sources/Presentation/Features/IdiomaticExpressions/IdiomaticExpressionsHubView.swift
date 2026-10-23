//
//  IdiomaticExpressionsHubView.swift
//  English along with John - Presentation / IdiomaticExpressions
//

import SwiftUI

/// Tela e Hub do Módulo de Expressões Idiomáticas.
public struct IdiomaticExpressionsHubView: View {
    @State private var expressions: [IdiomaticExpression] = []
    @State private var selectedTab: Tab = .quiz
    @State private var quizIndex: Int = 0
    @State private var selectedOptionId: String? = nil
    @State private var isAnswerSubmitted: Bool = false
    @State private var score: Int = 0
    @State private var currentQuizOptions: [IdiomaticExpression] = []

    private let dataSource = LocalIdiomaticExpressionsDataSource()

    public enum Tab: String, CaseIterable, Identifiable {
        case quiz = "Desafio de Significados"
        case catalog = "Guia & Expressões"

        public var id: String { rawValue }
    }

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerView

                // Seletor de Abas
                Picker("Aba", selection: $selectedTab) {
                    ForEach(Tab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if selectedTab == .quiz {
                    quizView
                } else {
                    catalogView
                }
            }
            .padding(.vertical)
        }
        .background(Color.appBackground)
        .navigationTitle("Expressões Idiomáticas")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            expressions = dataSource.loadExpressions()
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var headerView: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: "quote.bubble.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .padding(10)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Expressões Idiomáticas")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Compreenda o inglês natural que você não traduz ao pé da letra")
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

    @ViewBuilder
    private var quizView: some View {
        if !expressions.isEmpty {
            let current = expressions[quizIndex % expressions.count]
            let activeOptions = currentQuizOptions.isEmpty ? generateQuizOptions(correct: current) : currentQuizOptions

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Expressão \((quizIndex % expressions.count) + 1) de \(expressions.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Pontos: \(score)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.purple)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("O que significa:")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("\"\(current.expression)\"")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    if let literal = current.literalMeaningPt {
                        Text("(Tradução literal: *\(literal)*)")
                            .font(.caption)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(spacing: 10) {
                    ForEach(activeOptions, id: \.id) { option in
                        Button(action: {
                            handleOptionTap(option.id, correctId: current.id, activeOptions: activeOptions)
                        }) {
                            HStack {
                                Text(option.meaningPt)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                if isAnswerSubmitted {
                                    if option.id == current.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                    } else if selectedOptionId == option.id {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(optionBackground(option.id, correctId: current.id))
                            .foregroundStyle(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(isAnswerSubmitted)
                    }
                }
                .onAppear {
                    if currentQuizOptions.isEmpty {
                        currentQuizOptions = activeOptions
                    }
                }

                if isAnswerSubmitted {
                    VStack(alignment: .leading, spacing: 8) {
                        if let note = current.culturalNote {
                            HStack(alignment: .top, spacing: 6) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundStyle(.orange)
                                Text("Origem Cultural: \(note)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Button(action: nextQuizQuestion) {
                            HStack {
                                Text("Próxima Expressão")
                                    .fontWeight(.bold)
                                Image(systemName: "arrow.right")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding()
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            .onAppear {
                if currentQuizOptions.isEmpty && !expressions.isEmpty {
                    loadCurrentQuizQuestion()
                }
            }
        }
    }

    @ViewBuilder
    private var catalogView: some View {
        LazyVStack(spacing: 14) {
            ForEach(expressions) { item in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(item.expression)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.purple)
                        Spacer()
                    }

                    Text("Significado real: **\(item.meaningPt)**")
                        .font(.subheadline)

                    if let literal = item.literalMeaningPt {
                        Text("Literal: \(literal)")
                            .font(.caption)
                            .italic()
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\"\(item.exampleEn)\"")
                            .font(.footnote)
                            .italic()
                            .foregroundStyle(.blue)
                        Text(item.examplePt)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    if let note = item.culturalNote {
                        Text("Origem: \(note)")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }
                .padding()
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(.horizontal)
    }

    private func loadInitialData() {
        expressions = dataSource.loadExpressions()
        loadCurrentQuizQuestion()
    }

    private func loadCurrentQuizQuestion() {
        guard !expressions.isEmpty else {
            currentQuizOptions = []
            return
        }
        let current = expressions[quizIndex % expressions.count]
        currentQuizOptions = generateQuizOptions(correct: current)
    }

    private func generateQuizOptions(correct: IdiomaticExpression) -> [IdiomaticExpression] {
        var list = [correct]
        let distractors = expressions.filter { $0.id != correct.id }.shuffled().prefix(3)
        list.append(contentsOf: distractors)
        return list.shuffled()
    }

    private func handleOptionTap(_ id: String, correctId: String, activeOptions: [IdiomaticExpression]) {
        if currentQuizOptions.isEmpty {
            currentQuizOptions = activeOptions
        }
        selectedOptionId = id
        isAnswerSubmitted = true
        if id == correctId {
            score += 100
        }
    }

    private func nextQuizQuestion() {
        isAnswerSubmitted = false
        selectedOptionId = nil
        quizIndex += 1
        loadCurrentQuizQuestion()
    }

    private func optionBackground(_ id: String, correctId: String) -> Color {
        guard isAnswerSubmitted else { return Color.appBackground }
        if id == correctId {
            return Color.green.opacity(0.2)
        }
        if selectedOptionId == id {
            return Color.red.opacity(0.2)
        }
        return Color.appBackground
    }
}

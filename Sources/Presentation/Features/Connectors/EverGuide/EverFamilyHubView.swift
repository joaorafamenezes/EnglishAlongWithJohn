//
//  EverFamilyHubView.swift
//  English along with John - Presentation / Connectors / EverGuide
//

import SwiftUI

/// Hub Dedicado para a Família -Ever & Whereas com Guia e Quiz de Fixação.
public struct EverFamilyHubView: View {
    @State private var selectedTab: EverTab = .guide

    public enum EverTab: String, CaseIterable, Identifiable {
        case guide = "Guia & Regra de Ouro"
        case quiz = "Quiz de Fixação"

        public var id: String { rawValue }
    }

    public init() {}

    public var body: some View {
        VStack(spacing: 16) {
            Picker("Aba", selection: $selectedTab) {
                ForEach(EverTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

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

    @ViewBuilder
    private var everQuizView: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.purple)
                        Text("Desafio Especial -Ever")
                            .font(.headline)
                    }

                    Text("Identifique o conectivo ideal para cada contexto semântico:")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                VStack(spacing: 12) {
                    quizCard(
                        prompt: "_____ happens during the deploy, keep the communication channel open.",
                        answer: "Whatever",
                        options: ["Whatever", "Whenever", "Wherever", "Whoever"],
                        tip: "Refere-se a qualquer evento/coisa que aconteça ('no matter what')."
                    )

                    quizCard(
                        prompt: "Senior engineers mentor juniors, _____ interns focus on learning fundamentals.",
                        answer: "Whereas",
                        options: ["Whereas", "Wherever", "Whatever", "Whenever"],
                        tip: "Contraste analítico e formal direto entre dois grupos ('ao passo que')."
                    )

                    quizCard(
                        prompt: "Call the emergency phone line _____ you encounter a critical severity 1 incident.",
                        answer: "Whenever",
                        options: ["Whenever", "Whoever", "Whereas", "Whatever"],
                        tip: "Refere-se ao tempo e momento ('toda vez que / no momento em que')."
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }

    @ViewBuilder
    private func quizCard(prompt: String, answer: String, options: [String], tip: String) -> some View {
        EverQuestionItemView(prompt: prompt, answer: answer, options: options, tip: tip)
    }
}

private struct EverQuestionItemView: View {
    let prompt: String
    let answer: String
    let options: [String]
    let tip: String

    @State private var selected: String? = nil
    @State private var revealed: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(prompt)
                .font(.subheadline)
                .fontWeight(.semibold)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selected = option
                        revealed = true
                    }) {
                        HStack {
                            Text(option)
                                .font(.caption)
                                .fontWeight(.bold)
                            Spacer()
                            if revealed {
                                if option == answer {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.green)
                                } else if selected == option {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .padding(10)
                        .background(revealed ? (option == answer ? Color.green.opacity(0.18) : (selected == option ? Color.red.opacity(0.18) : Color.appBackground)) : Color.appBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .disabled(revealed)
                }
            }

            if revealed {
                Text("Dica: \(tip)")
                    .font(.caption2)
                    .foregroundStyle(.purple)
                    .padding(.top, 2)
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

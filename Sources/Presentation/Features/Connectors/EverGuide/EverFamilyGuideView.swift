//
//  EverFamilyGuideView.swift
//  English along with John - Presentation / Connectors
//

import SwiftUI

/// Modal interativo com o guia mnemônico da Família -ever.
public struct EverFamilyGuideView: View {
    @Environment(\.dismiss) private var dismiss
    private let isModal: Bool
    private let items = EverFamilyItem.standardGuide

    public init(isModal: Bool = true) {
        self.isModal = isModal
    }

    public var body: some View {
        if isModal {
            NavigationStack {
                contentView
                    .navigationTitle("Guia da Família -EVER")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Fechar") {
                                dismiss()
                            }
                        }
                    }
            }
        } else {
            contentView
        }
    }

    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Banner da Regra de Ouro do Teacher John
                ruleOfThumbCard

                // Cards Comparativos
                VStack(spacing: 14) {
                    ForEach(items) { item in
                        guideItemCard(item: item)
                    }
                }
            }
            .padding()
        }
        .background(Color.appBackground)
    }

    @ViewBuilder
    private var ruleOfThumbCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "key.horizontal.fill")
                    .foregroundStyle(.orange)
                Text("Regra de Ouro do Teacher John")
                    .font(.headline)
            }

            Text("Pergunte a si mesmo o que a lacuna representa:")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text("• **Pessoa**: Who ➔ **Whoever** ('any person who')")
                Text("• **Lugar**: Where ➔ **Wherever** ('in any place where')")
                Text("• **Tempo**: When ➔ **Whenever** ('every time that')")
                Text("• **Coisa / Evento**: What ➔ **Whatever** ('no matter what')")
                Text("• **Modo / Grau**: How ➔ **However** ('por mais que + adjetivo')")
                Text("• **Contraste Analítico**: Where + as ➔ **Whereas** ('ao passo que')")
            }
            .font(.footnote)
            .padding(.top, 4)
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func guideItemCard(item: EverFamilyItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.word)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)

                Spacer()

                Text(item.targetRole)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }

            Text("Significado: \(item.meaning)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Mnemônico: \(item.mnemonic)")
                .font(.caption)
                .italic()
                .foregroundStyle(.primary)

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Text(item.exampleEn)
                    .font(.footnote)
                    .fontWeight(.medium)
                Text(item.examplePt)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    EverFamilyGuideView()
}

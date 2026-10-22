//
//  ConnectorsMatchView.swift
//  English along with John - Presentation / Connectors / Match
//

import SwiftUI

public struct MatchTile: Identifiable, Equatable, Hashable, Sendable {
    public let id: String
    public let pairId: String
    public let text: String
    public let lang: Lang

    public enum Lang: Sendable, Equatable, Hashable {
        case english
        case portuguese
    }

    public init(id: String, pairId: String, text: String, lang: Lang) {
        self.id = id
        self.pairId = pairId
        self.text = text
        self.lang = lang
    }
}

/// Jogo de Associação Rápida (Match Rápido) para Conectivos.
public struct ConnectorsMatchView: View {
    @State private var tiles: [MatchTile] = []
    @State private var selectedTile: MatchTile? = nil
    @State private var matchedPairIds: Set<String> = []
    @State private var failedTileIds: Set<String> = []
    @State private var score: Int = 0
    @State private var streak: Int = 0
    @State private var roundsWon: Int = 0
    @State private var isRoundComplete: Bool = false

    private let repository: any ConnectorsRepositoryProtocol

    public init(repository: any ConnectorsRepositoryProtocol) {
        self.repository = repository
    }

    public var body: some View {
        VStack(spacing: 16) {
            // Header com Pontos e Sequência (Streak)
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Pontuação")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("\(score)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }

                Spacer()

                VStack(alignment: .center, spacing: 2) {
                    Text("Streak")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("\(streak)x")
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("Rodadas")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("\(roundsWon)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.purple)
                }
            }
            .padding(14)
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            Text("Selecione um conectivo em inglês e combine com sua tradução:")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Grade de Peças (Match Grid)
            if isRoundComplete {
                roundCompleteView
            } else {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(tiles) { tile in
                        if !matchedPairIds.contains(tile.pairId) {
                            tileButton(tile: tile)
                        } else {
                            // Espaço reservado invisível para manter layout limpo
                            Color.clear
                                .frame(height: 72)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.vertical)
        .background(Color.appBackground)
        .navigationTitle("Match Rápido")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await startNewRound()
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private func tileButton(tile: MatchTile) -> some View {
        let isSelected = selectedTile?.id == tile.id
        let isFailed = failedTileIds.contains(tile.id)

        Button(action: {
            handleTileTap(tile)
        }) {
            VStack {
                Text(tile.text)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(isFailed ? .white : (isSelected ? .white : .primary))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .padding(8)
            .background(
                isFailed ? Color.red : (isSelected ? Color.blue : Color.appCardBackground)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var roundCompleteView: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.yellow)

            Text("Rodada Concluída!")
                .font(.title2)
                .fontWeight(.bold)

            Text("Excelente velocidade de associação! Você dominou todos os pares desta rodada.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                Task {
                    await startNewRound()
                }
            }) {
                HStack {
                    Text("Próxima Rodada")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.forward.circle.fill")
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }

    // MARK: - Lógica do Jogo

    private func handleTileTap(_ tile: MatchTile) {
        guard failedTileIds.isEmpty else { return }

        // Se tocou na mesma peça, desmarca
        if selectedTile?.id == tile.id {
            selectedTile = nil
            return
        }

        // Se é a primeira peça do par
        guard let first = selectedTile else {
            selectedTile = tile
            return
        }

        // Se tocou em duas peças do mesmo idioma, troca a seleção
        if first.lang == tile.lang {
            selectedTile = tile
            return
        }

        // Verifica se formam o par correto
        if first.pairId == tile.pairId {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                matchedPairIds.insert(tile.pairId)
                selectedTile = nil
                score += 100 + (streak * 20)
                streak += 1
            }

            // Verifica se limpou a rodada
            let totalPairs = tiles.count / 2
            if matchedPairIds.count == totalPairs {
                roundsWon += 1
                isRoundComplete = true
            }
        } else {
            // Par incorreto: sinaliza erro e reseta streak
            streak = 0
            failedTileIds = [first.id, tile.id]

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation {
                    failedTileIds.removeAll()
                    selectedTile = nil
                }
            }
        }
    }

    private func startNewRound() async {
        selectedTile = nil
        matchedPairIds.removeAll()
        failedTileIds.removeAll()
        isRoundComplete = false

        if let catalog = try? await repository.fetchCatalog() {
            let sample = catalog.shuffled().prefix(6)
            var newTiles: [MatchTile] = []

            for item in sample {
                newTiles.append(MatchTile(id: "en-\(item.id)", pairId: item.id, text: item.connector, lang: .english))
                newTiles.append(MatchTile(id: "pt-\(item.id)", pairId: item.id, text: item.translation, lang: .portuguese))
            }

            tiles = newTiles.shuffled()
        }
    }
}

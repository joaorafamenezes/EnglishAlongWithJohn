//
//  ConnectorsDeckView.swift
//  English along with John - Presentation / Connectors / Deck
//

import SwiftUI

/// Deck de Estudo dos 81 Conectivos com Flashcards Interativos e sistema de maestria.
/// Fiel ao design e métricas da aplicação web (Connectors in English).
public struct ConnectorsDeckView: View {
    @State private var allConnectors: [Connector] = []
    @State private var selectedFamily: ConnectorFamily? = nil
    @State private var searchText: String = ""
    @State private var flippedCardIds: Set<String> = []
    @State private var masteredIds: Set<String> = []
    @State private var filterMastery: MasteryFilter = .all

    private let repository: any ConnectorsRepositoryProtocol

    public enum MasteryFilter: String, CaseIterable, Identifiable {
        case all = "Todos"
        case learning = "Ainda Estudando"
        case mastered = "Dominados ★"

        public var id: String { rawValue }
    }

    public init(repository: any ConnectorsRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Cálculos de Progresso e Métricas

    private var masteredCount: Int {
        allConnectors.filter { masteredIds.contains($0.id) }.count
    }

    private var totalCount: Int {
        allConnectors.count
    }

    private var unmasteredCount: Int {
        max(0, totalCount - masteredCount)
    }

    private var masteryPercentage: Int {
        guard totalCount > 0 else { return 0 }
        return Int((Double(masteredCount) / Double(totalCount)) * 100)
    }

    private func progressWidth(totalWidth: CGFloat) -> CGFloat {
        guard totalCount > 0 else { return 0 }
        let ratio = CGFloat(masteredCount) / CGFloat(totalCount)
        return totalWidth * min(1.0, max(0.0, ratio))
    }

    private func categoryCount(for family: ConnectorFamily) -> Int {
        allConnectors.filter { $0.family == family }.count
    }

    private func categoryMasteredCount(for family: ConnectorFamily) -> Int {
        allConnectors.filter { $0.family == family && masteredIds.contains($0.id) }.count
    }

    private var filteredConnectors: [Connector] {
        var list = allConnectors

        if let selectedFamily = selectedFamily {
            list = list.filter { $0.family == selectedFamily }
        }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            list = list.filter { connector in
                connector.connector.lowercased().contains(query) ||
                connector.translation.lowercased().contains(query) ||
                connector.grammarRule.lowercased().contains(query) ||
                connector.notes.lowercased().contains(query)
            }
        }

        switch filterMastery {
        case .all:
            break
        case .learning:
            list = list.filter { !masteredIds.contains($0.id) }
        case .mastered:
            list = list.filter { masteredIds.contains($0.id) }
        }

        return list
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Header com Título e Barra de Progresso Geral
                headerProgressSection

                // Campo de Busca
                searchBarSection

                // Seletor de Status (Todos, Estudando, Dominados)
                statusSelectorSection

                // Filtros de Categoria (com contadores individuais)
                categoryChipsSection

                // Contagem de Conectivos Encontrados
                HStack {
                    Text("\(filteredConnectors.count) conectivos encontrados")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Toque no card para virar e ver regras")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)

                // Grid dos 81 Flashcards
                LazyVStack(spacing: 14) {
                    ForEach(filteredConnectors) { connector in
                        connectorFlashcard(connector: connector)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 12)
        }
        .background(Color.appBackground)
        .navigationTitle("Deck dos 81 Conectivos")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let list = try? await repository.fetchCatalog() {
                allConnectors = list
                masteredIds = Set(list.filter { $0.isMastered }.map { $0.id })
            }
        }
    }

    // MARK: - 1. Header com Progresso Geral

    @ViewBuilder
    private var headerProgressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Deck de Estudo dos 81 Conectivos")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            Text("Consulte as regras de ouro, traduções e exemplos reais da área de TI e do cotidiano. Vire os cartões para testar sua memória.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineSpacing(2)

            // Barra de Progresso
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Progresso Geral")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(masteredCount) / \(totalCount) dominados (\(masteryPercentage)%)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.primary.opacity(0.08))
                            .frame(height: 8)

                        Capsule()
                            .fill(Color.green)
                            .frame(width: progressWidth(totalWidth: geo.size.width), height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding(12)
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
    }

    // MARK: - 2. Campo de Busca

    @ViewBuilder
    private var searchBarSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Buscar por conectivo (ex: Although, Meanwhile), tradução ou regra...", text: $searchText)
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
    }

    // MARK: - 3. Seletor de Status (Todos / Estudando / Dominados)

    @ViewBuilder
    private var statusSelectorSection: some View {
        HStack(spacing: 8) {
            statusPill(
                title: "Todos (\(totalCount))",
                isSelected: filterMastery == .all
            ) {
                filterMastery = .all
            }

            statusPill(
                title: "Ainda Estudando (\(unmasteredCount))",
                isSelected: filterMastery == .learning
            ) {
                filterMastery = .learning
            }

            statusPill(
                title: "Dominados ★ (\(masteredCount))",
                isSelected: filterMastery == .mastered
            ) {
                filterMastery = .mastered
            }
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func statusPill(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption2)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.appCardBackground)
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - 4. Categorias com Contadores Individuais

    @ViewBuilder
    private var categoryChipsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                categoryChip(
                    title: "Todos (\(totalCount))",
                    isSelected: selectedFamily == nil
                ) {
                    selectedFamily = nil
                }

                ForEach(ConnectorFamily.allCases, id: \.self) { family in
                    categoryChip(
                        title: "\(family.displayName) \(categoryMasteredCount(for: family))/\(categoryCount(for: family))",
                        isSelected: selectedFamily == family
                    ) {
                        selectedFamily = family
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func categoryChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption2)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.orange : Color.appCardBackground)
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - 5. Flashcard Individual

    @ViewBuilder
    private func connectorFlashcard(connector: Connector) -> some View {
        let isFlipped = flippedCardIds.contains(connector.id)
        let isMastered = masteredIds.contains(connector.id)

        VStack(alignment: .leading, spacing: 12) {
            // Header do Card: Número (#01) e Categoria
            HStack {
                Text("#\(String(format: "%02d", connector.number))")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)

                Spacer()

                Text(connector.family.displayName)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.12))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }

            // Frente vs Verso
            if !isFlipped {
                // FRENTE DO CARD
                VStack(alignment: .leading, spacing: 6) {
                    Text(connector.connector)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(.primary)

                    Text("Clique para virar e ver regras e exemplos")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        flippedCardIds.insert(connector.id)
                    }
                }
            } else {
                // VERSO DO CARD (Detalhado)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(connector.connector)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                            Text("Tradução: \(connector.translation)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                flippedCardIds.remove(connector.id)
                            }
                        }) {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    // Regra Gramatical
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Regra de Uso:")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        Text(connector.grammarRule)
                            .font(.footnote)
                            .foregroundStyle(.primary)
                    }

                    // Dica / Observação
                    if !connector.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Dica de Aplicação:")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            Text(connector.notes)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    // Exemplos Reais
                    if !connector.examples.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Exemplos em Contexto:")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                            ForEach(connector.examples, id: \.self) { example in
                                Text("• \"\(example)\"")
                                    .font(.caption2)
                                    .italic()
                                    .foregroundStyle(.primary.opacity(0.85))
                            }
                        }
                    }
                }
            }

            Divider()

            // Botão de Dominado (Estilo do Web Game)
            Button(action: {
                toggleMastery(for: connector.id)
            }) {
                HStack(spacing: 6) {
                    Image(systemName: isMastered ? "star.fill" : "star")
                        .font(.caption)
                    Text(isMastered ? "★ Dominado" : "☆ Marcar como dominado")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isMastered ? Color.green.opacity(0.18) : Color.appBackground)
                .foregroundStyle(isMastered ? Color.green : Color.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isMastered ? Color.green.opacity(0.5) : Color.primary.opacity(0.1), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isMastered ? Color.green.opacity(0.4) : Color.clear, lineWidth: 1.5)
        )
    }

    private func toggleMastery(for connectorId: String) {
        Task {
            if let isNowMastered = try? await repository.toggleMasteredId(connectorId) {
                if isNowMastered {
                    masteredIds.insert(connectorId)
                } else {
                    masteredIds.remove(connectorId)
                }
            }
        }
    }
}

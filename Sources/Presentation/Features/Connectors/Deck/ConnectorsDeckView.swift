//
//  ConnectorsDeckView.swift
//  English along with John - Presentation / Connectors / Deck
//

import SwiftUI

/// Deck dos 81 Conectivos com Flashcards Interativos e sistema de maestria.
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
        case learning = "Em Aprendizado"
        case mastered = "Dominados"

        public var id: String { rawValue }
    }

    public init(repository: any ConnectorsRepositoryProtocol) {
        self.repository = repository
    }

    private var filteredConnectors: [Connector] {
        allConnectors.filter { connector in
            let matchesSearch = searchText.isEmpty ||
                connector.connector.localizedCaseInsensitiveContains(searchText) ||
                connector.translation.localizedCaseInsensitiveContains(searchText)

            let matchesFamily = selectedFamily == nil || connector.family == selectedFamily

            let isMastered = masteredIds.contains(connector.id)
            let matchesMastery: Bool
            switch filterMastery {
            case .all: matchesMastery = true
            case .learning: matchesMastery = !isMastered
            case .mastered: matchesMastery = isMastered
            }

            return matchesSearch && matchesFamily && matchesMastery
        }
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Barra de Busca e Filtro de Maestria
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Buscar por conectivo ou tradução...", text: $searchText)
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

                    // Seletor de Filtro: Todos, Aprendizado, Dominados
                    Picker("Filtro", selection: $filterMastery) {
                        ForEach(MasteryFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)

                // Filtros por Família de Conectivos
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        familyChip(title: "Todas as Categorias", isSelected: selectedFamily == nil) {
                            selectedFamily = nil
                        }
                        ForEach(ConnectorFamily.allCases, id: \.self) { family in
                            familyChip(title: family.displayName, isSelected: selectedFamily == family) {
                                selectedFamily = family
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Header de Contagem
                HStack {
                    Text("\(filteredConnectors.count) conectivos encontrados")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Toque no card para ver regras e exemplos")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // Lista de Flashcards
                LazyVStack(spacing: 14) {
                    ForEach(filteredConnectors) { connector in
                        connectorCard(connector: connector)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
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

    // MARK: - Subviews

    @ViewBuilder
    private func familyChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.appCardBackground)
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private func connectorCard(connector: Connector) -> some View {
        let isFlipped = flippedCardIds.contains(connector.id)
        let isMastered = masteredIds.contains(connector.id)

        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(connector.family.displayName)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())

                Spacer()

                Button(action: {
                    toggleMastery(for: connector.id)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isMastered ? "checkmark.seal.fill" : "seal")
                            .foregroundStyle(isMastered ? .green : .secondary)
                        Text(isMastered ? "Dominado" : "Marcar Dominado")
                            .font(.caption2)
                            .foregroundStyle(isMastered ? .green : .secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.appBackground)
                    .clipShape(Capsule())
                }
            }

            // Frente: Conectivo em inglês e Tradução
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(connector.connector)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    Text(connector.translation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: isFlipped ? "chevron.up.circle.fill" : "chevron.down.circle")
                    .font(.title3)
                    .foregroundStyle(.blue)
            }

            // Verso expandido: Regras gramaticais e frases
            if isFlipped {
                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Regra Gramatical & Uso:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Text(connector.grammarRule)
                        .font(.footnote)
                        .foregroundStyle(.primary)

                    if !connector.notes.isEmpty {
                        Text("Dica do John: \(connector.notes)")
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .padding(.top, 2)
                    }

                    if let firstExample = connector.examples.first {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Exemplo:")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            Text("\"\(firstExample)\"")
                                .font(.footnote)
                                .italic()
                                .foregroundStyle(.blue)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
                if flippedCardIds.contains(connector.id) {
                    flippedCardIds.remove(connector.id)
                } else {
                    flippedCardIds.insert(connector.id)
                }
            }
        }
    }

    private func toggleMastery(for id: String) {
        Task {
            let nextState = !masteredIds.contains(id)
            if nextState {
                masteredIds.insert(id)
            } else {
                masteredIds.remove(id)
            }
            try? await repository.toggleMasteredId(id)
        }
    }
}

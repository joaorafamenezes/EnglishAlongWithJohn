//
//  ConnectorsRepository.swift
//  English along with John - Data / Connectors
//

import Foundation

/// Implementação Concreta do Repositório de Conectivos com persistência local (Offline-First).
/// Utiliza `actor` para isolamento de estado nativo e concorrência segura em Swift 6.
public actor ConnectorsRepository: ConnectorsRepositoryProtocol {
    private let dataSource: LocalConnectorsDataSource
    private let userDefaults: UserDefaults
    private let masteredStorageKey = "connectors_mastered_ids"
    private var inMemoryMastered: Set<String>

    public init(
        dataSource: LocalConnectorsDataSource = LocalConnectorsDataSource(),
        userDefaults: UserDefaults = .standard
    ) {
        self.dataSource = dataSource
        self.userDefaults = userDefaults

        if let saved = userDefaults.array(forKey: masteredStorageKey) as? [String] {
            self.inMemoryMastered = Set(saved)
        } else {
            self.inMemoryMastered = []
        }
    }

    public func fetchCatalog() async throws -> [Connector] {
        let catalog = dataSource.loadCatalog()
        return catalog.map { item in
            item.withMastered(inMemoryMastered.contains(item.id))
        }
    }

    public func fetchExercises(config: SessionConfig) async throws -> [ConnectorExercise] {
        let allExercises = dataSource.loadExercises()

        // 1. Filtragem por Família / Tópico
        var filtered: [ConnectorExercise]
        switch config.familyFilter {
        case .all:
            filtered = allExercises
        case .family(let family):
            filtered = allExercises.filter { $0.family == family }
        case .everFamily:
            let everIds: Set<String> = ["whatever", "whenever", "wherever", "whoever", "however", "whereas"]
            filtered = allExercises.filter { exercise in
                exercise.id.hasPrefix("q-ever-") || everIds.contains(exercise.connectorId)
            }
        }

        // 2. Filtro de Dominados ("Ocultar itens dominados")
        if config.hideMastered && config.familyFilter != .everFamily {
            filtered = filtered.filter { exercise in
                !inMemoryMastered.contains(exercise.connectorId)
            }
        }

        // 3. Embaralhamento e limitação de quantidade
        let shuffled = filtered.shuffled()
        let targetCount = min(config.questionCount, shuffled.count)
        return Array(shuffled.prefix(targetCount))
    }

    public func fetchEverFamilyGuide() async -> [EverFamilyItem] {
        return EverFamilyItem.standardGuide
    }

    public func getMasteredIds() async throws -> Set<String> {
        return inMemoryMastered
    }

    public func toggleMasteredId(_ id: String) async throws -> Bool {
        let isNowMastered: Bool
        if inMemoryMastered.contains(id) {
            inMemoryMastered.remove(id)
            isNowMastered = false
        } else {
            inMemoryMastered.insert(id)
            isNowMastered = true
        }

        userDefaults.set(Array(inMemoryMastered), forKey: masteredStorageKey)
        return isNowMastered
    }

    public func saveSessionScore(score: Int, bestStreak: Int, mode: GameMode) async throws {
        let historyKey = "connectors_high_score_\(mode.rawValue)"
        let previousHigh = userDefaults.integer(forKey: historyKey)
        if score > previousHigh {
            userDefaults.set(score, forKey: historyKey)
        }
    }
}

extension ConnectorsRepository {
    public nonisolated func loadSampleExercise() -> ConnectorExercise {
        LocalConnectorsDataSource().loadExercises()[0]
    }
}

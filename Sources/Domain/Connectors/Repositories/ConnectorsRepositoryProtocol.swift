//
//  ConnectorsRepositoryProtocol.swift
//  English along with John - Domain / Connectors
//

import Foundation

/// Contrato abstrato de dados para o deck de conectivos, sessões e persistência de domínio.
public protocol ConnectorsRepositoryProtocol: Sendable {
    /// Obtém todos os conectivos catalogados (com status de dominado).
    func fetchCatalog() async throws -> [Connector]

    /// Obtém os exercícios com base nas configurações da sessão e filtro de dominados.
    func fetchExercises(config: SessionConfig) async throws -> [ConnectorExercise]

    /// Obtém o guia mnemônico da Família -ever.
    func fetchEverFamilyGuide() async -> [EverFamilyItem]

    /// Obtém o conjunto de identificadores de conectivos dominados pelo aluno.
    func getMasteredIds() async throws -> Set<String>

    /// Alterna o status de domínio de um conectivo (salvo localmente).
    func toggleMasteredId(_ id: String) async throws -> Bool

    /// Salva o resultado final de uma sessão no histórico local.
    func saveSessionScore(score: Int, bestStreak: Int, mode: GameMode) async throws
}

//
//  LocalConnectorsDataSource.swift
//  English along with John - Data / Connectors
//

import Foundation

/// Fonte de dados local nativa contendo o catálogo completo dos 81 conectivos e o banco de exercícios
/// portados diretamente do projeto de referência (Connectors in English).
public final class LocalConnectorsDataSource: Sendable {

    public init() {}

    // MARK: - Catálogo dos 81 Conectivos
    public func loadCatalog() -> [Connector] {
        return ConnectorsCatalogData.allConnectors
    }

    // MARK: - Banco Geral de Exercícios
    public func loadExercises() -> [ConnectorExercise] {
        return ConnectorsQuestionsData.questions + EverQuestionsData.questions
    }

    // MARK: - Banco Exclusivo da Família -Ever
    public func loadEverExercises() -> [ConnectorExercise] {
        return EverQuestionsData.questions
    }
}

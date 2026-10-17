//
//  Connector.swift
//  English along with John - Domain / Connectors
//

import Foundation

/// Entidade de Domínio representando um conectivo do catálogo pedagógico.
public struct Connector: Identifiable, Sendable, Equatable {
    public let id: String
    public let number: Int
    public let connector: String
    public let translation: String
    public let family: ConnectorFamily
    public let grammarRule: String
    public let notes: String
    public let examples: [String]
    public let isMastered: Bool

    public init(
        id: String,
        number: Int,
        connector: String,
        translation: String,
        family: ConnectorFamily,
        grammarRule: String,
        notes: String,
        examples: [String],
        isMastered: Bool = false
    ) {
        self.id = id
        self.number = number
        self.connector = connector
        self.translation = translation
        self.family = family
        self.grammarRule = grammarRule
        self.notes = notes
        self.examples = examples
        self.isMastered = isMastered
    }

    public func withMastered(_ mastered: Bool) -> Connector {
        Connector(
            id: id,
            number: number,
            connector: connector,
            translation: translation,
            family: family,
            grammarRule: grammarRule,
            notes: notes,
            examples: examples,
            isMastered: mastered
        )
    }
}

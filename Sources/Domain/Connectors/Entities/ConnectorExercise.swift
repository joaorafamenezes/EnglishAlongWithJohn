//
//  ConnectorExercise.swift
//  English along with John - Domain / Connectors
//

import Foundation

public struct ConnectorExerciseOption: Identifiable, Sendable, Equatable {
    public let id: String
    public let text: String

    public init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}

/// Entidade de exercício prático de conectivo (fill-in-the-blank).
public struct ConnectorExercise: Identifiable, Sendable, Equatable {
    public let id: String
    public let prompt: String
    public let options: [ConnectorExerciseOption]
    public let correctOptionId: String
    public let connectorId: String
    public let connectorTerm: String
    public let family: ConnectorFamily
    public let translation: String
    public let explanation: String
    public let fullSentence: String
    public let sentenceTranslation: String
    public let whyCorrect: String
    public let whyOthersFail: String
    public let proTip: String

    public init(
        id: String,
        prompt: String,
        options: [ConnectorExerciseOption],
        correctOptionId: String,
        connectorId: String,
        connectorTerm: String,
        family: ConnectorFamily,
        translation: String,
        explanation: String,
        fullSentence: String,
        sentenceTranslation: String,
        whyCorrect: String,
        whyOthersFail: String,
        proTip: String
    ) {
        self.id = id
        self.prompt = prompt
        self.options = options
        self.correctOptionId = correctOptionId
        self.connectorId = connectorId
        self.connectorTerm = connectorTerm
        self.family = family
        self.translation = translation
        self.explanation = explanation
        self.fullSentence = fullSentence
        self.sentenceTranslation = sentenceTranslation
        self.whyCorrect = whyCorrect
        self.whyOthersFail = whyOthersFail
        self.proTip = proTip
    }

    public func isCorrect(optionId: String?) -> Bool {
        guard let optionId = optionId else { return false }
        return optionId == correctOptionId
    }
}

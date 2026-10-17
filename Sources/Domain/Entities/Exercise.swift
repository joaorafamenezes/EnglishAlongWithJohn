//
//  Exercise.swift
//  English along with John - Domain Layer
//

import Foundation

/// Entidade de exercício prático associado a uma lição.
public struct Exercise: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let prompt: String
    public let options: [String]
    public let correctOptionIndex: Int
    public let explanation: String
    public let audioExampleURL: URL?

    public init(
        id: UUID = UUID(),
        prompt: String,
        options: [String],
        correctOptionIndex: Int,
        explanation: String,
        audioExampleURL: URL? = nil
    ) {
        self.id = id
        self.prompt = prompt
        self.options = options
        self.correctOptionIndex = correctOptionIndex
        self.explanation = explanation
        self.audioExampleURL = audioExampleURL
    }

    public func validateAnswer(index: Int) -> Bool {
        return index == correctOptionIndex
    }
}

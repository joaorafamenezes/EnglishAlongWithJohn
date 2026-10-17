//
//  Lesson.swift
//  English along with John - Domain Layer
//

import Foundation

/// Entidade central de domínio que representa uma Lição/Aula do professor John.
/// Imutável, livre de frameworks de terceiros e em conformidade com `Sendable`.
public struct Lesson: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let title: String
    public let topic: String
    public let summary: String
    public let level: ProficiencyLevel
    public let audioPodcastURL: URL?
    public let durationInSeconds: Int
    public let exercises: [Exercise]
    public let isCompleted: Bool
    public let releaseDate: Date

    public init(
        id: UUID = UUID(),
        title: String,
        topic: String,
        summary: String,
        level: ProficiencyLevel,
        audioPodcastURL: URL? = nil,
        durationInSeconds: Int,
        exercises: [Exercise] = [],
        isCompleted: Bool = false,
        releaseDate: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.topic = topic
        self.summary = summary
        self.level = level
        self.audioPodcastURL = audioPodcastURL
        self.durationInSeconds = durationInSeconds
        self.exercises = exercises
        self.isCompleted = isCompleted
        self.releaseDate = releaseDate
    }

    /// Retorna uma nova instância atualizada com status de conclusão.
    public func markedAsCompleted() -> Lesson {
        Lesson(
            id: self.id,
            title: self.title,
            topic: self.topic,
            summary: self.summary,
            level: self.level,
            audioPodcastURL: self.audioPodcastURL,
            durationInSeconds: self.durationInSeconds,
            exercises: self.exercises,
            isCompleted: true,
            releaseDate: self.releaseDate
        )
    }
}

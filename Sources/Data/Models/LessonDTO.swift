//
//  LessonDTO.swift
//  English along with John - Data Layer
//

import Foundation

/// Objeto de Transferência de Dados (DTO) para decodificação da API REST.
public struct LessonDTO: Codable, Sendable {
    public let id: String
    public let title: String
    public let topic: String
    public let summary: String
    public let level: String
    public let audioUrl: String?
    public let durationSeconds: Int
    public let exercises: [ExerciseDTO]
    public let isCompleted: Bool
    public let releaseDate: String

    public struct ExerciseDTO: Codable, Sendable {
        public let id: String
        public let prompt: String
        public let options: [String]
        public let correctOptionIndex: Int
        public let explanation: String
        public let audioExampleUrl: String?

        public func toDomain() -> Exercise {
            Exercise(
                id: UUID(uuidString: id) ?? UUID(),
                prompt: prompt,
                options: options,
                correctOptionIndex: correctOptionIndex,
                explanation: explanation,
                audioExampleURL: audioExampleUrl.flatMap { URL(string: $0) }
            )
        }
    }

    /// Mapeador puro do DTO para a Entidade de Domínio.
    public func toDomain() -> Lesson {
        let mappedLevel: ProficiencyLevel
        switch level.lowercased() {
        case "beginner", "a1", "a2": mappedLevel = .beginner
        case "intermediate", "b1", "b2": mappedLevel = .intermediate
        case "advanced", "c1": mappedLevel = .advanced
        case "business": mappedLevel = .business
        default: mappedLevel = .intermediate
        }

        let dateFormatter = ISO8601DateFormatter()
        let parsedDate = dateFormatter.date(from: releaseDate) ?? Date()

        return Lesson(
            id: UUID(uuidString: id) ?? UUID(),
            title: title,
            topic: topic,
            summary: summary,
            level: mappedLevel,
            audioPodcastURL: audioUrl.flatMap { URL(string: $0) },
            durationInSeconds: durationSeconds,
            exercises: exercises.map { $0.toDomain() },
            isCompleted: isCompleted,
            releaseDate: parsedDate
        )
    }
}

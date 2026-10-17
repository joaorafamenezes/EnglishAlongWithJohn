//
//  MockLessonRepository.swift
//  English along with John - Data Layer / Mocks
//

import Foundation

/// Dublê de Teste (Test Double) / Repositório In-Memory com suporte para Previews e Testes Unitários.
public final class MockLessonRepository: LessonRepositoryProtocol, @unchecked Sendable {
    public var stubbedLesson: Lesson?
    public var shouldThrowError: Error?
    public var simulatedDelayNanoseconds: UInt64 = 0
    public private(set) var saveLessonProgressCalledWith: (lessonId: UUID, completed: Bool)?
    public private(set) var fetchTodayLessonCallCount: Int = 0

    public init(
        stubbedLesson: Lesson? = MockLessonRepository.sampleLesson,
        shouldThrowError: Error? = nil,
        simulatedDelayNanoseconds: UInt64 = 0
    ) {
        self.stubbedLesson = stubbedLesson
        self.shouldThrowError = shouldThrowError
        self.simulatedDelayNanoseconds = simulatedDelayNanoseconds
    }

    public func fetchTodayLesson() async throws -> Lesson {
        fetchTodayLessonCallCount += 1
        
        if simulatedDelayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        }

        if let error = shouldThrowError {
            throw error
        }

        guard let lesson = stubbedLesson else {
            throw LessonDomainError.lessonNotFound
        }

        return lesson
    }

    public func fetchLesson(by id: UUID) async throws -> Lesson {
        if let error = shouldThrowError {
            throw error
        }
        guard let lesson = stubbedLesson, lesson.id == id else {
            throw LessonDomainError.lessonNotFound
        }
        return lesson
    }

    public func saveLessonProgress(lessonId: UUID, completed: Bool) async throws {
        if let error = shouldThrowError {
            throw error
        }
        saveLessonProgressCalledWith = (lessonId, completed)
        if var lesson = stubbedLesson, lesson.id == lessonId {
            stubbedLesson = completed ? lesson.markedAsCompleted() : lesson
        }
    }

    // MARK: - Seed Data para Previews e Testes Rápidos
    public static var sampleLesson: Lesson {
        Lesson(
            id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!,
            title: "Mastering Casual Small Talk with John",
            topic: "Social English & Daily Conversations",
            summary: "Aprenda como iniciar e manter conversas naturais em cafeterias e ambientes corporativos sem parecer robótico.",
            level: .intermediate,
            audioPodcastURL: URL(string: "https://cdn.englishwithjohn.com/audio/ep42_small_talk.mp3"),
            durationInSeconds: 480, // 8 minutos
            exercises: [
                Exercise(
                    prompt: "Qual a melhor réplica quando alguém em Nova York pergunta: 'How's it going?'",
                    options: [
                        "I am going to the supermarket.",
                        "Good, how are you doing?",
                        "My health is optimal today.",
                        "Yes, it goes well."
                    ],
                    correctOptionIndex: 1,
                    explanation: "'Good, how are you doing?' ou 'Pretty good, you?' são as respostas mais naturais no dia a dia norte-americano."
                ),
                Exercise(
                    prompt: "O que significa a expressão 'Catch you later' usada pelo John ao final do áudio?",
                    options: [
                        "Vou te pegar correndo.",
                        "Até mais / Te vejo mais tarde.",
                        "Preciso segurar sua bolsa.",
                        "Esqueci meu casaco com você."
                    ],
                    correctOptionIndex: 1,
                    explanation: "'Catch you later' é uma despedida informal amplamente utilizada no inglês cotidiano."
                )
            ],
            isCompleted: false,
            releaseDate: Date()
        )
    }
}

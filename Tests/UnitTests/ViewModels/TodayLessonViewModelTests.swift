//
//  TodayLessonViewModelTests.swift
//  English along with John - Tests / UnitTests
//

import Testing
import Foundation

@Suite("Suíte de Testes: TodayLessonViewModel")
@MainActor
struct TodayLessonViewModelTests {

    @Test("Deve transitar para o estado loaded ao executar onAppear com sucesso")
    func testOnAppearSuccess() async {
        // Arrange
        let sampleLesson = MockLessonRepository.sampleLesson
        let mockRepo = MockLessonRepository(stubbedLesson: sampleLesson)
        let useCase = FetchTodayLessonUseCase(repository: mockRepo)
        let coordinator = AppCoordinator()
        let sut = TodayLessonViewModel(fetchTodayLessonUseCase: useCase, coordinator: coordinator)

        #expect(sut.state == .idle)

        // Act
        await sut.onAppear()

        // Assert
        #expect(sut.state == .loaded(sampleLesson))
    }

    @Test("Deve transitar para o estado error quando o Caso de Uso falhar")
    func testOnAppearFailure() async {
        // Arrange
        let mockRepo = MockLessonRepository(shouldThrowError: LessonDomainError.networkUnavailable)
        let useCase = FetchTodayLessonUseCase(repository: mockRepo)
        let coordinator = AppCoordinator()
        let sut = TodayLessonViewModel(fetchTodayLessonUseCase: useCase, coordinator: coordinator)

        // Act
        await sut.onAppear()

        // Assert
        if case .error(let message) = sut.state {
            #expect(message == LessonDomainError.networkUnavailable.localizedDescription)
        } else {
            Issue.record("O estado esperado era .error, mas recebeu \(sut.state)")
        }
    }

    @Test("Deve alternar o estado de áudio corretamente")
    func testToggleAudioPlayback() {
        // Arrange
        let mockRepo = MockLessonRepository()
        let useCase = FetchTodayLessonUseCase(repository: mockRepo)
        let sut = TodayLessonViewModel(fetchTodayLessonUseCase: useCase)

        #expect(!sut.isPlayingAudio)

        // Act & Assert
        sut.toggleAudioPlayback()
        #expect(sut.isPlayingAudio)

        sut.toggleAudioPlayback()
        #expect(!sut.isPlayingAudio)
    }

    @Test("Deve acionar a navegação no Coordinator ao tocar em iniciar exercícios")
    func testNavigationToExercises() {
        // Arrange
        let sampleLesson = MockLessonRepository.sampleLesson
        let mockRepo = MockLessonRepository(stubbedLesson: sampleLesson)
        let useCase = FetchTodayLessonUseCase(repository: mockRepo)
        let coordinator = AppCoordinator()
        let sut = TodayLessonViewModel(fetchTodayLessonUseCase: useCase, coordinator: coordinator)

        // Act
        sut.didTapStartExercises(lesson: sampleLesson)

        // Assert
        #expect(coordinator.path.count == 1)
        #expect(coordinator.path.first == .exerciseSession(lessonId: sampleLesson.id))
    }
}

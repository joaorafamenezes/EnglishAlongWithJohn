//
//  AppRoute.swift
//  English along with John - Presentation / Navigation
//

import Foundation

/// Destinos tipados de navegação para a pilha do NavigationStack.
public enum AppRoute: Hashable, Sendable {
    case todayLesson
    case lessonDetail(id: UUID)
    case exerciseSession(lessonId: UUID)
    case pronunciationDrill(audioUrl: URL?)
    case studentProfile
    case connectorsHub
    case connectorPractice(sessionId: UUID)
}

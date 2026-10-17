//
//  EnglishAlongWithJohnApp.swift
//  English along with John - App Entry Point
//

import SwiftUI

@main
struct EnglishAlongWithJohnApp: App {
    // Instanciação do Container no topo da árvore de execução (Composition Root)
    @State private var container: AppContainer = {
        let coordinator = AppCoordinator()
        let repository = MockLessonRepository()
        return AppContainer(coordinator: coordinator, lessonRepository: repository)
    }()

    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(container: container)
        }
    }
}

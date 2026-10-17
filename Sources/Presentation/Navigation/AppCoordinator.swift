//
//  AppCoordinator.swift
//  English along with John - Presentation / Navigation
//

import SwiftUI
import Observation

/// Contrato para o coordenador/roteador principal de fluxos do app.
@MainActor
public protocol AppCoordinatorProtocol: AnyObject, Sendable {
    var path: [AppRoute] { get set }
    func navigate(to route: AppRoute)
    func pop()
    func popToRoot()
}

/// Implementação do Coordinator para SwiftUI usando NavigationStack orientada a rotas tipadas.
/// Desacopla as Views da hierarquia e do conhecimento de para onde navegar.
@Observable
@MainActor
public final class AppCoordinator: AppCoordinatorProtocol {
    public var path: [AppRoute] = []

    public init() {}

    public func navigate(to route: AppRoute) {
        path.append(route)
    }

    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    public func popToRoot() {
        path.removeAll()
    }
}

//
//  GameMode.swift
//  English along with John - Domain / Connectors
//

import Foundation

/// Modos de jogo e estudo disponíveis na Prática de Conectivos.
public enum GameMode: String, Codable, CaseIterable, Sendable {
    case zen = "zen"
    case arcade = "arcade"

    public var title: String {
        switch self {
        case .zen: return "Modo Zen"
        case .arcade: return "Desafio Arcade"
        }
    }

    public var subtitle: String {
        switch self {
        case .zen: return "Treino guiado sem pressão, sem limite de tempo e sem perda de vidas."
        case .arcade: return "18s por questão, 3 vidas, bônus de agilidade e multiplicador de streak."
        }
    }

    public var iconName: String {
        switch self {
        case .zen: return "leaf.fill"
        case .arcade: return "flame.fill"
        }
    }
}

/// Configurações selecionadas pelo aluno para a sessão de conectivos.
public struct SessionConfig: Sendable, Equatable {
    public var mode: GameMode
    public var familyFilter: ConnectorFamilyFilter
    public var questionCount: Int
    public var hideMastered: Bool

    public init(
        mode: GameMode = .zen,
        familyFilter: ConnectorFamilyFilter = .all,
        questionCount: Int = 10,
        hideMastered: Bool = false
    ) {
        self.mode = mode
        self.familyFilter = familyFilter
        self.questionCount = questionCount
        self.hideMastered = hideMastered
    }
}

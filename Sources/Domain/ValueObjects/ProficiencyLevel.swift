//
//  ProficiencyLevel.swift
//  English along with John - Domain Layer
//

import Foundation

/// Value Object que encapsula o nível de proficiência linguística do aluno.
public enum ProficiencyLevel: String, Codable, Sendable, CaseIterable {
    case beginner = "Iniciante (A1-A2)"
    case intermediate = "Intermediário (B1-B2)"
    case advanced = "Avançado (C1)"
    case business = "Inglês para Negócios"
    
    public var badgeColorHex: String {
        switch self {
        case .beginner: return "#10B981"
        case .intermediate: return "#3B82F6"
        case .advanced: return "#8B5CF6"
        case .business: return "#F59E0B"
        }
    }
}

//
//  ConnectorFamily.swift
//  English along with John - Domain / Connectors
//

import Foundation

/// Categorias e famílias sintáticas dos conectivos da língua inglesa.
public enum ConnectorFamily: String, Codable, CaseIterable, Sendable {
    case contrast = "contrast"
    case cause = "cause"
    case condition = "condition"
    case addition = "addition"
    case time = "time"
    case purpose = "purpose"
    case example = "example"
    case emphasis = "emphasis"
    case substitution = "substitution"
    case summary = "summary"

    /// Título amigável em português para exibição nas telas.
    public var localizedTitle: String {
        switch self {
        case .contrast: return "Contraste & Concessão"
        case .cause: return "Causa & Motivo"
        case .condition: return "Condição & Hipótese"
        case .addition: return "Adição & Continuidade"
        case .time: return "Tempo & Cronologia"
        case .purpose: return "Propósito & Finalidade"
        case .example: return "Exemplificação"
        case .emphasis: return "Ênfase & Destaque"
        case .substitution: return "Substituição & Alternativa"
        case .summary: return "Resumo & Conclusão"
        }
    }

    /// Ícone representativo do SF Symbols.
    public var iconName: String {
        switch self {
        case .contrast: return "arrow.left.arrow.right"
        case .cause: return "questionmark.circle"
        case .condition: return "arrow.triangle.branch"
        case .addition: return "plus.circle"
        case .time: return "clock"
        case .purpose: return "target"
        case .example: return "lightbulb"
        case .emphasis: return "exclamationmark.bubble"
        case .substitution: return "arrow.2.squarepath"
        case .summary: return "doc.plaintext"
        }
    }

    /// Cor de apoio para o Badge da categoria.
    public var accentColorHex: String {
        switch self {
        case .contrast: return "#EF4444"    // Vermelho
        case .cause: return "#F59E0B"       // Âmbar
        case .condition: return "#10B981"   // Esmeralda
        case .addition: return "#3B82F6"    // Azul
        case .time: return "#8B5CF6"        // Violeta
        case .purpose: return "#EC4899"     // Rosa
        case .example: return "#EAB308"     // Amarelo
        case .emphasis: return "#6366F1"    // Índigo
        case .substitution: return "#14B8A6" // Ciano
        case .summary: return "#64748B"     // Ardósia
        }
    }
}

/// Filtro selecionável na sessão de estudo.
public enum ConnectorFamilyFilter: Equatable, Hashable, Sendable {
    case all
    case family(ConnectorFamily)
    case everFamily // Tópico especial da Família -ever

    public var title: String {
        switch self {
        case .all: return "Todas as Famílias"
        case .family(let family): return family.localizedTitle
        case .everFamily: return "Família -EVER (Especial)"
        }
    }
}

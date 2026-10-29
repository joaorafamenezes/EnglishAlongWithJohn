//
//  PhrasalVerb.swift
//  English along with John - Domain / PhrasalVerbs
//

import Foundation

public enum PhrasalVerbLevel: String, Sendable, CaseIterable, Identifiable {
    case all = "Todos"
    case a1 = "A1 - Básico"
    case a2 = "A2 - Elementar"
    case b1 = "B1 - Intermediário"
    case b2 = "B2 - Intermediário Superior"
    case c1 = "C1 - Avançado"

    public var id: String { rawValue }
}

/// Entidade de domínio representando um Phrasal Verb didático.
public struct PhrasalVerb: Identifiable, Sendable, Equatable {
    public let id: String
    public let verb: String
    public let particle: String
    public let phrasalVerb: String
    public let meaningPt: String
    public let level: PhrasalVerbLevel
    public let exampleEn: String
    public let examplePt: String
    public let isMastered: Bool
    public let customMaskedSentence: String?
    public let meaningEn: String
    public let category: String
    public let examples: [String]
    public let teacherTip: String

    public init(
        id: String,
        verb: String,
        particle: String,
        phrasalVerb: String,
        meaningPt: String,
        level: PhrasalVerbLevel,
        exampleEn: String,
        examplePt: String,
        isMastered: Bool = false,
        customMaskedSentence: String? = nil,
        meaningEn: String = "",
        category: String = "Geral",
        examples: [String] = [],
        teacherTip: String = ""
    ) {
        self.id = id
        self.verb = verb
        self.particle = particle
        self.phrasalVerb = phrasalVerb
        self.meaningPt = meaningPt
        self.level = level
        self.exampleEn = exampleEn
        self.examplePt = examplePt
        self.isMastered = isMastered
        self.customMaskedSentence = customMaskedSentence
        self.meaningEn = meaningEn
        self.category = category
        self.examples = examples.isEmpty ? [exampleEn] : examples
        self.teacherTip = teacherTip
    }

    /// Retorna a frase em inglês com o phrasal verb mascarado pela lacuna "_____".
    public var maskedSentence: String {
        if let custom = customMaskedSentence, !custom.isEmpty {
            return custom
        }
        return PhrasalVerbMasker.mask(
            sentence: exampleEn,
            phrasalVerb: phrasalVerb,
            verb: verb,
            particle: particle
        )
    }

    public func withMastered(_ mastered: Bool) -> PhrasalVerb {
        PhrasalVerb(
            id: id,
            verb: verb,
            particle: particle,
            phrasalVerb: phrasalVerb,
            meaningPt: meaningPt,
            level: level,
            exampleEn: exampleEn,
            examplePt: examplePt,
            isMastered: mastered,
            customMaskedSentence: customMaskedSentence,
            meaningEn: meaningEn,
            category: category,
            examples: examples,
            teacherTip: teacherTip
        )
    }
}

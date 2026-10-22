//
//  IdiomaticExpression.swift
//  English along with John - Domain / IdiomaticExpressions
//

import Foundation

/// Entidade de domínio para Expressões Idiomáticas.
public struct IdiomaticExpression: Identifiable, Sendable, Equatable {
    public let id: String
    public let expression: String
    public let meaningPt: String
    public let literalMeaningPt: String?
    public let exampleEn: String
    public let examplePt: String
    public let culturalNote: String?
    public let isMastered: Bool

    public init(
        id: String,
        expression: String,
        meaningPt: String,
        literalMeaningPt: String? = nil,
        exampleEn: String,
        examplePt: String,
        culturalNote: String? = nil,
        isMastered: Bool = false
    ) {
        self.id = id
        self.expression = expression
        self.meaningPt = meaningPt
        self.literalMeaningPt = literalMeaningPt
        self.exampleEn = exampleEn
        self.examplePt = examplePt
        self.culturalNote = culturalNote
        self.isMastered = isMastered
    }

    public func withMastered(_ mastered: Bool) -> IdiomaticExpression {
        IdiomaticExpression(
            id: id,
            expression: expression,
            meaningPt: meaningPt,
            literalMeaningPt: literalMeaningPt,
            exampleEn: exampleEn,
            examplePt: examplePt,
            culturalNote: culturalNote,
            isMastered: mastered
        )
    }
}

//
//  LocalIdiomaticExpressionsDataSource.swift
//  English along with John - Data / IdiomaticExpressions
//

import Foundation

public final class LocalIdiomaticExpressionsDataSource: Sendable {
    public init() {}

    public func loadExpressions() -> [IdiomaticExpression] {
        return IdiomaticExpressionsData.expressions
    }
}

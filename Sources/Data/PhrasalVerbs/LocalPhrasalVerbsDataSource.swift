//
//  LocalPhrasalVerbsDataSource.swift
//  English along with John - Data / PhrasalVerbs
//

import Foundation

public final class LocalPhrasalVerbsDataSource: Sendable {
    public init() {}

    public func loadPhrasalVerbs() -> [PhrasalVerb] {
        return PhrasalVerbsCatalogData.items.map { item in
            PhrasalVerb(
                id: item.id,
                verb: item.verb,
                particle: item.particle,
                phrasalVerb: item.phrasalVerb,
                meaningPt: item.meaningPt,
                level: item.level,
                exampleEn: item.examples.first ?? item.phrasalVerb,
                examplePt: item.meaningPt,
                meaningEn: item.meaningEn,
                category: item.category,
                examples: item.examples,
                teacherTip: item.teacherTip
            )
        }
    }
}

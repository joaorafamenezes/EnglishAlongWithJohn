//
//  PhrasalVerbMaskerTests.swift
//  English along with John - Tests / PhrasalVerbs
//

import Testing
import Foundation
@testable import EnglishAlongWithJohn

@Suite("Suíte de Testes: PhrasalVerbMasker e Ocultação da Resposta")
struct PhrasalVerbMaskerTests {

    @Test("Deve mascarar phrasal verb em forma base (ex: give up)")
    func testMaskBaseForm() {
        let sentence = "Don't give up on fixing this bug; you are almost there."
        let masked = PhrasalVerbMasker.mask(
            sentence: sentence,
            phrasalVerb: "Give up",
            verb: "give",
            particle: "up"
        )
        #expect(masked == "Don't _____ on fixing this bug; you are almost there.")
        #expect(!masked.lowercased().contains("give up"))
    }

    @Test("Deve mascarar phrasal verb no passado irregular/regular (figured out, carried out, came across, turned down)")
    func testMaskPastTenseForms() {
        // figure out -> figured out
        let s1 = "The team finally figured out what caused the memory leak."
        let m1 = PhrasalVerbMasker.mask(sentence: s1, phrasalVerb: "Figure out", verb: "figure", particle: "out")
        #expect(m1 == "The team finally _____ what caused the memory leak.")
        #expect(!m1.lowercased().contains("figured out"))

        // carry out -> carried out
        let s2 = "The QA engineers carried out a comprehensive regression suite."
        let m2 = PhrasalVerbMasker.mask(sentence: s2, phrasalVerb: "Carry out", verb: "carry", particle: "out")
        #expect(m2 == "The QA engineers _____ a comprehensive regression suite.")
        #expect(!m2.lowercased().contains("carried out"))

        // come across -> came across
        let s3 = "While reviewing the pull request, I came across a missing security check."
        let m3 = PhrasalVerbMasker.mask(sentence: s3, phrasalVerb: "Come across", verb: "come", particle: "across")
        #expect(m3 == "While reviewing the pull request, I _____ a missing security check.")
        #expect(!m3.lowercased().contains("came across"))

        // turn down -> turned down
        let s4 = "He turned down the job offer because he preferred remote work."
        let m4 = PhrasalVerbMasker.mask(sentence: s4, phrasalVerb: "Turn down", verb: "turn", particle: "down")
        #expect(m4 == "He _____ the job offer because he preferred remote work.")
        #expect(!m4.lowercased().contains("turned down"))
    }

    @Test("Deve mascarar phrasal verbs com objeto intercalado (separáveis)")
    func testMaskSeparableForms() {
        let sentence = "He turned it down immediately."
        let masked = PhrasalVerbMasker.mask(sentence: sentence, phrasalVerb: "Turn down", verb: "turn", particle: "down")
        #expect(masked.contains("_____"))
        #expect(!masked.lowercased().contains("turned it down"))
    }

    @Test("Todas as questões do LocalPhrasalVerbsDataSource devem ocultar a resposta na maskedSentence")
    func testAllDataSourceItemsMaskAnswersProperly() {
        let dataSource = LocalPhrasalVerbsDataSource()
        let verbs = dataSource.loadPhrasalVerbs()

        #expect(!verbs.isEmpty)

        for verb in verbs {
            let masked = verb.maskedSentence

            // Deve conter a lacuna "_____"
            #expect(masked.contains("_____"), "O item \(verb.id) não gerou a lacuna: \(masked)")

            // Não deve conter o phrasal verb completo na frase mascarada
            #expect(!masked.lowercased().contains(verb.phrasalVerb.lowercased()),
                    "A frase mascarada do item \(verb.id) ainda exibe a resposta: \(masked)")
        }
    }

    @Test("customMaskedSentence deve ter prioridade sobre o mascarador automático quando fornecido")
    func testCustomMaskedSentencePrecedence() {
        let verb = PhrasalVerb(
            id: "custom-test",
            verb: "test",
            particle: "out",
            phrasalVerb: "Test out",
            meaningPt: "Testar",
            level: .b1,
            exampleEn: "Let's test out the feature in staging.",
            examplePt: "Vamos testar a funcionalidade em staging.",
            customMaskedSentence: "Custom: Let's _____ the feature in staging."
        )

        #expect(verb.maskedSentence == "Custom: Let's _____ the feature in staging.")
    }

    @Test("withMastered preserva customMaskedSentence")
    func testWithMasteredPreservesCustomMaskedSentence() {
        let verb = PhrasalVerb(
            id: "mastered-test",
            verb: "figure",
            particle: "out",
            phrasalVerb: "Figure out",
            meaningPt: "Descobrir",
            level: .b1,
            exampleEn: "The team finally figured out what caused the leak.",
            examplePt: "A equipe descobriu o vazamento.",
            isMastered: false,
            customMaskedSentence: "The team finally _____ what caused the leak."
        )

        let mastered = verb.withMastered(true)
        #expect(mastered.isMastered == true)
        #expect(mastered.customMaskedSentence == "The team finally _____ what caused the leak.")
        #expect(mastered.maskedSentence == "The team finally _____ what caused the leak.")
    }
}

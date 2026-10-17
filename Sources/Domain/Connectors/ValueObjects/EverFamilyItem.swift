//
//  EverFamilyItem.swift
//  English along with John - Domain / Connectors
//

import Foundation

/// Item do guia mnemônico da Família `-ever` (Whatever, Whenever, Wherever, Whoever, However vs Whereas).
public struct EverFamilyItem: Identifiable, Sendable, Equatable {
    public var id: String { word.lowercased() }
    public let word: String
    public let meaning: String
    public let targetRole: String
    public let mnemonic: String
    public let exampleEn: String
    public let examplePt: String
    public let connectorId: String

    public init(
        word: String,
        meaning: String,
        targetRole: String,
        mnemonic: String,
        exampleEn: String,
        examplePt: String,
        connectorId: String
    ) {
        self.word = word
        self.meaning = meaning
        self.targetRole = targetRole
        self.mnemonic = mnemonic
        self.exampleEn = exampleEn
        self.examplePt = examplePt
        self.connectorId = connectorId
    }

    /// Itens canônicos extraídos da base original com contexto corporativo e de tecnologia.
    public static let standardGuide: [EverFamilyItem] = [
        EverFamilyItem(
            word: "Whatever",
            meaning: "o que quer que / qualquer coisa",
            targetRole: "Coisas, ações, eventos ou objetos",
            mnemonic: "What + ever = qualquer coisa que seja / no matter what",
            exampleEn: "Whatever happens during the demo, keep calm and explain the architecture.",
            examplePt: "O que quer que aconteça durante a demonstração, mantenha a calma e explique a arquitetura.",
            connectorId: "whatever"
        ),
        EverFamilyItem(
            word: "Whenever",
            meaning: "quando quer que / sempre que",
            targetRole: "Tempo, momentos, ocasiões ou frequência",
            mnemonic: "When + ever = qualquer momento que seja / every time that",
            exampleEn: "Whenever the CI pipeline fails, an alert is sent to our squad Slack channel.",
            examplePt: "Sempre que a pipeline de CI falha, um alerta é enviado para o canal da nossa squad no Slack.",
            connectorId: "whenever"
        ),
        EverFamilyItem(
            word: "Wherever",
            meaning: "onde quer que / onde quer que seja",
            targetRole: "Lugares, localizações geográficas ou espaciais",
            mnemonic: "Where + ever = qualquer lugar que seja / in any place where",
            exampleEn: "With cloud workstations, software engineers can code securely from wherever they are.",
            examplePt: "Com estações em nuvem, engenheiros de software podem programar com segurança de onde quer que estejam.",
            connectorId: "wherever"
        ),
        EverFamilyItem(
            word: "Whoever",
            meaning: "quem quer que / qualquer pessoa que",
            targetRole: "Pessoas, sujeitos humanos ou agentes",
            mnemonic: "Who + ever = qualquer pessoa que seja / any person who",
            exampleEn: "Whoever authored this pull request followed all clean code principles.",
            examplePt: "Quem quer que tenha criado este pull request seguiu todos os princípios de código limpo.",
            connectorId: "whoever"
        ),
        EverFamilyItem(
            word: "However",
            meaning: "como quer que / por mais que (e contudo)",
            targetRole: "Modo ('como quer que') ou Grau de intensidade ('por mais que + adjetivo')",
            mnemonic: "How + ever = de qualquer maneira que seja / por mais [adjetivo] que seja",
            exampleEn: "However difficult the legacy migration seems, breaking it into smaller stories ensures success.",
            examplePt: "Por mais difícil que a migração do legado pareça, dividi-la em histórias menores garante o sucesso.",
            connectorId: "however"
        ),
        EverFamilyItem(
            word: "Whereas",
            meaning: "ao passo que / enquanto que",
            targetRole: "Contraste analítico direto entre dois fatos ou abordagens",
            mnemonic: "Where + as = ao passo que / enquanto que (CUIDADO: não é lugar! É contraste direto)",
            exampleEn: "Scrum focuses on short timeboxed iterations, whereas Kanban emphasizes continuous workflow.",
            examplePt: "O Scrum foca em iterações curtas e com prazo, ao passo que o Kanban enfatiza o fluxo contínuo de trabalho.",
            connectorId: "whereas"
        )
    ]
}

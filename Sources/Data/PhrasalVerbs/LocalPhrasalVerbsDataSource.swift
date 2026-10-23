//
//  LocalPhrasalVerbsDataSource.swift
//  English along with John - Data / PhrasalVerbs
//

import Foundation

public final class LocalPhrasalVerbsDataSource: Sendable {
    public init() {}

    public func loadPhrasalVerbs() -> [PhrasalVerb] {
        return [
            PhrasalVerb(
                id: "give-up",
                verb: "give",
                particle: "up",
                phrasalVerb: "Give up",
                meaningPt: "Desistir / Parar de tentar",
                level: .a2,
                exampleEn: "Don't give up on fixing this bug; you are almost there.",
                examplePt: "Não desista de corrigir esse bug; você está quase lá.",
                customMaskedSentence: "Don't _____ on fixing this bug; you are almost there."
            ),
            PhrasalVerb(
                id: "figure-out",
                verb: "figure",
                particle: "out",
                phrasalVerb: "Figure out",
                meaningPt: "Descobrir / Compreender / Encontrar a solução",
                level: .b1,
                exampleEn: "The team finally figured out what caused the memory leak.",
                examplePt: "A equipe finalmente descobriu o que causou o vazamento de memória.",
                customMaskedSentence: "The team finally _____ what caused the memory leak."
            ),
            PhrasalVerb(
                id: "look-forward-to",
                verb: "look",
                particle: "forward to",
                phrasalVerb: "Look forward to",
                meaningPt: "Aguardar ansiosamente / Estar na expectativa",
                level: .b1,
                exampleEn: "We look forward to presenting the new architecture to the stakeholders.",
                examplePt: "Aguardamos ansiosamente para apresentar a nova arquitetura às partes interessadas.",
                customMaskedSentence: "We _____ presenting the new architecture to the stakeholders."
            ),
            PhrasalVerb(
                id: "run-out-of",
                verb: "run",
                particle: "out of",
                phrasalVerb: "Run out of",
                meaningPt: "Ficar sem / Esgotar",
                level: .a2,
                exampleEn: "The database will run out of storage if we don't clean old logs.",
                examplePt: "O banco de dados ficará sem armazenamento se não limparmos logs antigos.",
                customMaskedSentence: "The database will _____ storage if we don't clean old logs."
            ),
            PhrasalVerb(
                id: "carry-out",
                verb: "carry",
                particle: "out",
                phrasalVerb: "Carry out",
                meaningPt: "Executar / Realizar (tarefa, plano, teste)",
                level: .b2,
                exampleEn: "The QA engineers carried out a comprehensive regression suite.",
                examplePt: "Os engenheiros de QA executaram uma suíte de regressão abrangente.",
                customMaskedSentence: "The QA engineers _____ a comprehensive regression suite."
            ),
            PhrasalVerb(
                id: "call-off",
                verb: "call",
                particle: "off",
                phrasalVerb: "Call off",
                meaningPt: "Cancelar",
                level: .b1,
                exampleEn: "They had to call off the deployment due to an unexpected production outage.",
                examplePt: "Eles tiveram que cancelar o deploy devido a uma interrupção inesperada em produção.",
                customMaskedSentence: "They had to _____ the deployment due to an unexpected production outage."
            ),
            PhrasalVerb(
                id: "bring-up",
                verb: "bring",
                particle: "up",
                phrasalVerb: "Bring up",
                meaningPt: "Mencionar / Levantar um assunto",
                level: .b2,
                exampleEn: "Please bring up this performance bottleneck during the retrospective.",
                examplePt: "Por favor, mencione esse gargalo de desempenho durante a retrospectiva.",
                customMaskedSentence: "Please _____ this performance bottleneck during the retrospective."
            ),
            PhrasalVerb(
                id: "put-off",
                verb: "put",
                particle: "off",
                phrasalVerb: "Put off",
                meaningPt: "Adiar / Postergar",
                level: .b1,
                exampleEn: "We shouldn't put off refactoring this legacy module any longer.",
                examplePt: "Não devemos mais adiar a refatoração deste módulo legado.",
                customMaskedSentence: "We shouldn't _____ refactoring this legacy module any longer."
            ),
            PhrasalVerb(
                id: "catch-up",
                verb: "catch",
                particle: "up",
                phrasalVerb: "Catch up",
                meaningPt: "Alcançar / Atualizar-se / Ficar a par",
                level: .b1,
                exampleEn: "Let's schedule a 1:1 meeting to catch up on sprint goals.",
                examplePt: "Vamos agendar uma reunião 1:1 para nos atualizarmos sobre as metas da sprint.",
                customMaskedSentence: "Let's schedule a 1:1 meeting to _____ on sprint goals."
            ),
            PhrasalVerb(
                id: "come-across",
                verb: "come",
                particle: "across",
                phrasalVerb: "Come across",
                meaningPt: "Deparar-se com / Encontrar por acaso",
                level: .b2,
                exampleEn: "While reviewing the pull request, I came across a missing security check.",
                examplePt: "Enquanto revisava o pull request, deparei-me com uma verificação de segurança ausente.",
                customMaskedSentence: "While reviewing the pull request, I _____ a missing security check."
            ),
            PhrasalVerb(
                id: "get-along-with",
                verb: "get",
                particle: "along with",
                phrasalVerb: "Get along with",
                meaningPt: "Dar-se bem com alguém",
                level: .a2,
                exampleEn: "It is essential that developers and designers get along with each other.",
                examplePt: "É essencial que desenvolvedores e designers se deem bem uns com os outros.",
                customMaskedSentence: "It is essential that developers and designers _____ each other."
            ),
            PhrasalVerb(
                id: "turn-down",
                verb: "turn",
                particle: "down",
                phrasalVerb: "Turn down",
                meaningPt: "Recusar / Rejeitar uma oferta ou proposta",
                level: .b1,
                exampleEn: "He turned down the job offer because he preferred remote work.",
                examplePt: "Ele recusou a oferta de trabalho porque preferia trabalho remoto.",
                customMaskedSentence: "He _____ the job offer because he preferred remote work."
            )
        ]
    }
}

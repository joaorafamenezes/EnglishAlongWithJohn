//
//  LocalIdiomaticExpressionsDataSource.swift
//  English along with John - Data / IdiomaticExpressions
//

import Foundation

public final class LocalIdiomaticExpressionsDataSource: Sendable {
    public init() {}

    public func loadExpressions() -> [IdiomaticExpression] {
        return [
            IdiomaticExpression(
                id: "piece-of-cake",
                expression: "A piece of cake",
                meaningPt: "Muito fácil / Moleza",
                literalMeaningPt: "Um pedaço de bolo",
                exampleEn: "Deploying this SwiftUI update was a piece of cake thanks to our CI pipeline.",
                examplePt: "Fazer o deploy dessa atualização SwiftUI foi moleza graças ao nosso pipeline de CI.",
                culturalNote: "Uma das expressões mais populares no inglês informal norte-americano e britânico."
            ),
            IdiomaticExpression(
                id: "bite-the-bullet",
                expression: "Bite the bullet",
                meaningPt: "Encarar uma situação difícil / Aguentar firme",
                literalMeaningPt: "Morder a bala",
                exampleEn: "We had to bite the bullet and rewrite the entire authentication layer.",
                examplePt: "Tivemos que encarar a situação e reescrever toda a camada de autenticação.",
                culturalNote: "Origina-se dos tempos em que soldados mordiam balas de chumbo para suportar a dor de cirurgias em campo de batalha."
            ),
            IdiomaticExpression(
                id: "hit-the-nail-on-the-head",
                expression: "Hit the nail on the head",
                meaningPt: "Acertar em cheio / Ter toda razão",
                literalMeaningPt: "Bater o prego na cabeça",
                exampleEn: "Your analysis of the system architecture hit the nail on the head.",
                examplePt: "Sua análise da arquitetura do sistema acertou em cheio.",
                culturalNote: "Usada constantemente em reuniões de alinhamento e revisões técnicas."
            ),
            IdiomaticExpression(
                id: "under-the-weather",
                expression: "Under the weather",
                meaningPt: "Indisposto / Meio doente",
                literalMeaningPt: "Sob o clima",
                exampleEn: "The tech lead is feeling under the weather today, so he is resting.",
                examplePt: "O líder técnico está se sentindo indisposto hoje, então está descansando.",
                culturalNote: "Expressão náutica antiga onde marinheiros desciam para os conveses inferiores para fugir do mau tempo."
            ),
            IdiomaticExpression(
                id: "cut-corners",
                expression: "Cut corners",
                meaningPt: "Fazer de qualquer jeito / Pegar atalhos arriscados",
                literalMeaningPt: "Cortar esquinas",
                exampleEn: "Never cut corners when it comes to user privacy and secure encryption.",
                examplePt: "Nunca faça as coisas de qualquer jeito quando se trata de privacidade do usuário e criptografia segura.",
                culturalNote: "Forte conotação negativa em engenharia e negócios quando se sacrifica qualidade por velocidade."
            ),
            IdiomaticExpression(
                id: "break-the-ice",
                expression: "Break the ice",
                meaningPt: "Quebrar o gelo / Iniciar uma conversa",
                literalMeaningPt: "Quebrar o gelo",
                exampleEn: "The mentor used a quick trivia game to break the ice with the new interns.",
                examplePt: "O mentor usou um jogo rápido de perguntas para quebrar o gelo com os novos estagiários.",
                culturalNote: "Navios quebra-gelo abriam caminho nos portos congelados para permitir o comércio."
            ),
            IdiomaticExpression(
                id: "burn-the-midnight-oil",
                expression: "Burn the midnight oil",
                meaningPt: "Trabalhar ou estudar até tarde da noite",
                literalMeaningPt: "Queimar o óleo da meia-noite",
                exampleEn: "The squad burned the midnight oil to prepare the product demo on time.",
                examplePt: "O squad trabalhou até tarde da noite para preparar a demonstração do produto a tempo.",
                culturalNote: "Refere-se ao consumo do óleo das lamparinas antes da invenção da luz elétrica."
            ),
            IdiomaticExpression(
                id: "see-eye-to-eye",
                expression: "See eye to eye",
                meaningPt: "Concordar plenamente / Estar em sintonia",
                literalMeaningPt: "Ver olho a olho",
                exampleEn: "The product manager and the architect saw eye to eye on the roadmap.",
                examplePt: "O gerente de produto e o arquiteto concordaram plenamente com o roadmap.",
                culturalNote: "Expressão muito antiga de harmonia e entendimento mútuo."
            )
        ]
    }
}

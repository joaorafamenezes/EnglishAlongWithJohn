//
//  LocalConnectorsDataSource.swift
//  English along with John - Data / Connectors
//

import Foundation

/// Fonte de dados local nativa contendo o catálogo de conectivos e banco de questões
/// portados diretamente do repositório de referência com contexto de engenharia/tech.
public final class LocalConnectorsDataSource: Sendable {

    public init() {}

    // MARK: - Catálogo de Conectivos
    public func loadCatalog() -> [Connector] {
        return [
            Connector(
                id: "above-all",
                number: 1,
                connector: "Above all",
                translation: "Acima de tudo",
                family: .emphasis,
                grammarRule: "Usado para destacar a prioridade máxima ou o ponto mais importante de uma argumentação.",
                notes: "Muito comum em liderança técnica e decisões estratégicas de arquitetura.",
                examples: [
                    "Above all, we must ensure the safety and reliability of our production servers.",
                    "Above all, keep user data protected and compliant with privacy regulations."
                ]
            ),
            Connector(
                id: "actually",
                number: 2,
                connector: "Actually",
                translation: "Na verdade",
                family: .emphasis,
                grammarRule: "Usado para corrigir uma falsa impressão ou esclarecer a realidade dos fatos.",
                notes: "Muito utilizado em reuniões de status quando a realidade difere da estimativa inicial.",
                examples: [
                    "Actually, the release was deployed ahead of schedule.",
                    "You thought the bug was in the frontend, but actually it was a database lock."
                ]
            ),
            Connector(
                id: "afterwards",
                number: 3,
                connector: "Afterwards",
                translation: "Posteriormente / Depois disso",
                family: .time,
                grammarRule: "Advérbio de tempo que se refere a um momento subsequente.",
                notes: "Frequentemente usado para descrever o fluxo após deploys ou cerimônias.",
                examples: [
                    "We will conduct the Daily Standup first; afterwards, we can discuss the blocker.",
                    "They deployed the hotfix and monitored the metrics immediately afterwards."
                ]
            ),
            Connector(
                id: "all-in-all",
                number: 4,
                connector: "All in all",
                translation: "De tudo em tudo / Em suma",
                family: .summary,
                grammarRule: "Usado para fazer uma avaliação geral equilibrada após considerar aspectos positivos e negativos.",
                notes: "Perfeito para retrospectivas de Sprint e fechamento de trimestre (QBR).",
                examples: [
                    "All in all, the sprint was successful despite the mid-week outage.",
                    "All in all, the migration to microservices brought significant scalability."
                ]
            ),
            Connector(
                id: "along-with",
                number: 5,
                connector: "Along with",
                translation: "Junto com",
                family: .addition,
                grammarRule: "Indica companhia, inclusão ou anexo de um elemento a outro.",
                notes: "Frequentemente usado para pacotes, dependências e colaboração entre squads.",
                examples: [
                    "The Scrum Master held the Retrospective along with the developers and QAs.",
                    "When you buy a new iPhone, the charger won't come along with the phone."
                ]
            ),
            Connector(
                id: "although",
                number: 6,
                connector: "Although",
                translation: "Embora",
                family: .contrast,
                grammarRule: "Conjunção subordinativa concessiva. Requer obrigatoriamente oração completa (sujeito + verbo).",
                notes: "Ex: 'Although it's raining' (certo) vs 'Although the rain' (errado; use 'Despite').",
                examples: [
                    "Although the release deadline was tight, the team delivered zero critical bugs.",
                    "Although microservices add complexity, they enable autonomous squad scaling."
                ]
            ),
            Connector(
                id: "whereas",
                number: 7,
                connector: "Whereas",
                translation: "Ao passo que / Enquanto que",
                family: .contrast,
                grammarRule: "Estabelece um contraste analítico direto entre dois fatos, abordagens ou filosofias.",
                notes: "CUIDADO: não indica lugar! É uma conjunção de contraste formal.",
                examples: [
                    "Scrum focuses on short timeboxed iterations, whereas Kanban emphasizes continuous workflow.",
                    "SQL databases provide ACID guarantees, whereas NoSQL solutions prioritize horizontal partitioning."
                ]
            ),
            Connector(
                id: "whoever",
                number: 8,
                connector: "Whoever",
                translation: "Quem quer que / Qualquer pessoa que",
                family: .emphasis,
                grammarRule: "Pronome relativo composto que atua como sujeito ou objeto humano ('any person who').",
                notes: "Membro nobre da Família -ever com foco estrito em pessoas.",
                examples: [
                    "Whoever is on call tonight must monitor the PagerDuty latency alerts.",
                    "Whoever authored this pull request followed all clean code principles."
                ]
            ),
            Connector(
                id: "whatever",
                number: 9,
                connector: "Whatever",
                translation: "O que quer que / Qualquer coisa que",
                family: .emphasis,
                grammarRule: "Refere-se a coisas, ações, eventos ou objetos indefinidos ('no matter what').",
                notes: "Membro da Família -ever com foco em eventos e objetos.",
                examples: [
                    "Whatever happens during the production demo, remain calm and explain the fallback plan.",
                    "Choose whatever cloud provider best aligns with your team's compliance requirements."
                ]
            ),
            Connector(
                id: "whenever",
                number: 10,
                connector: "Whenever",
                translation: "Quando quer que / Sempre que",
                family: .time,
                grammarRule: "Refere-se a momentos, ocasiões temporais ou frequência ('every time that').",
                notes: "Membro da Família -ever para automações de CI/CD e triggers.",
                examples: [
                    "Whenever the CI pipeline fails, an alert is sent to our squad Slack channel.",
                    "Whenever a new PR is opened, automated unit tests execute immediately."
                ]
            ),
            Connector(
                id: "wherever",
                number: 11,
                connector: "Wherever",
                translation: "Onde quer que / Em qualquer lugar que",
                family: .emphasis,
                grammarRule: "Refere-se a locais geográficos ou posições espaciais ('in any place where').",
                notes: "Membro da Família -ever para trabalho remoto e infraestrutura distribuída.",
                examples: [
                    "With cloud workstations, software engineers can code securely from wherever they are.",
                    "Wherever your users are located, edge computing reduces response latency."
                ]
            ),
            Connector(
                id: "however",
                number: 12,
                connector: "However",
                translation: "Contudo / Por mais que",
                family: .contrast,
                grammarRule: "Usado como conjunção adversativa ('contudo') ou intensificador ('por mais [adjetivo] que').",
                notes: "Ex: 'However difficult the migration seems, breaking it into smaller tasks ensures success.'",
                examples: [
                    "We planned to release on Friday; however, QA discovered a regression in the auth flow.",
                    "However complex the refactoring appears, strong unit tests give us full confidence."
                ]
            )
        ]
    }

    // MARK: - Banco de Questões de Prática
    public func loadExercises() -> [ConnectorExercise] {
        return [
            ConnectorExercise(
                id: "q-user-along-with-iphone",
                prompt: "When you buy a new iPhone, you need to buy the charger separately. It won't come _____ the phone.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "along with"),
                    ConnectorExerciseOption(id: "b", text: "instead of"),
                    ConnectorExerciseOption(id: "c", text: "because of"),
                    ConnectorExerciseOption(id: "d", text: "in order to")
                ],
                correctOptionId: "a",
                connectorId: "along-with",
                connectorTerm: "along with",
                family: .addition,
                translation: "Junto com",
                explanation: "'Along with' indica que algo acompanha ou vem anexado a outro item.",
                fullSentence: "When you buy a new iPhone, you need to buy the charger separately. It won't come along with the phone.",
                sentenceTranslation: "Quando você compra um novo iPhone, precisa comprar o carregador separadamente. Ele não virá junto com o telefone.",
                whyCorrect: "'Along with' expressa inclusão e acompanhamento físico ('junto com o telefone').",
                whyOthersFail: "'Instead of' significa 'em vez de'. 'Because of' indica causa ('por causa de'). 'In order to' expressa finalidade ('a fim de').",
                proTip: "Lembre-se: 'Along with' funciona como 'together with'. Muito usado para pacotes e entregas conjuntas."
            ),
            ConnectorExercise(
                id: "q-user-along-with-scrum",
                prompt: "The Scrum Master held the Retrospective _____ the developers and the QAs.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "apart from"),
                    ConnectorExerciseOption(id: "b", text: "along with"),
                    ConnectorExerciseOption(id: "c", text: "due to"),
                    ConnectorExerciseOption(id: "d", text: "instead of")
                ],
                correctOptionId: "b",
                connectorId: "along-with",
                connectorTerm: "along with",
                family: .addition,
                translation: "Junto com",
                explanation: "'Along with' estabelece a colaboração conjunta de várias pessoas em uma mesma reunião.",
                fullSentence: "The Scrum Master held the Retrospective along with the developers and the QAs.",
                sentenceTranslation: "O Scrum Master realizou a Retrospectiva junto com os desenvolvedores e os QAs.",
                whyCorrect: "'Along with' denota companhia e colaboração mútua no evento da Sprint.",
                whyOthersFail: "'Apart from' significa 'além de / à parte de'. 'Due to' expressa motivo. 'Instead of' significa substituição.",
                proTip: "Use 'along with' sempre que quiser enfatizar que múltiplos papéis ou áreas participaram de uma cerimônia."
            ),
            ConnectorExercise(
                id: "q-user-above-all-prod",
                prompt: "_____ we must ensure the safety and reliability of our production servers before enabling new features.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "Above all"),
                    ConnectorExerciseOption(id: "b", text: "Even though"),
                    ConnectorExerciseOption(id: "c", text: "Otherwise"),
                    ConnectorExerciseOption(id: "d", text: "Whereas")
                ],
                correctOptionId: "a",
                connectorId: "above-all",
                connectorTerm: "Above all",
                family: .emphasis,
                translation: "Acima de tudo",
                explanation: "'Above all' destaca a prioridade máxima absoluta de um sistema.",
                fullSentence: "Above all we must ensure the safety and reliability of our production servers before enabling new features.",
                sentenceTranslation: "Acima de tudo, devemos garantir a segurança e a confiabilidade de nossos servidores de produção antes de ativar novos recursos.",
                whyCorrect: "'Above all' é o conectivo de ênfase usado no topo de uma lista de prioridades técnicas.",
                whyOthersFail: "'Even though' exige uma oração concessiva. 'Otherwise' indica alternativa. 'Whereas' faz contraste direto.",
                proTip: "Em liderança e arquitetura, 'Above all' introduz o requisito não-funcional inegociável."
            ),
            ConnectorExercise(
                id: "q-user-although-deadline",
                prompt: "_____ the release deadline was tight, the engineering team delivered zero critical bugs.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "Despite"),
                    ConnectorExerciseOption(id: "b", text: "Although"),
                    ConnectorExerciseOption(id: "c", text: "Because of"),
                    ConnectorExerciseOption(id: "d", text: "In spite of")
                ],
                correctOptionId: "b",
                connectorId: "although",
                connectorTerm: "Although",
                family: .contrast,
                translation: "Embora",
                explanation: "'Although' introduz oração subordinada com sujeito ('the release deadline') e verbo ('was').",
                fullSentence: "Although the release deadline was tight, the engineering team delivered zero critical bugs.",
                sentenceTranslation: "Embora o prazo de lançamento estivesse apertado, a equipe de engenharia entregou zero bugs críticos.",
                whyCorrect: "A lacuna é seguida por oração completa ('sujeito + verbo'), exigindo 'Although'.",
                whyOthersFail: "'Despite' e 'In spite of' exigem substantivo direto (ex: 'Despite the tight deadline'), nunca oração direta.",
                proTip: "Armadilha clássica de prova e entrevistas: se tiver sujeito e verbo conjugado depois da lacuna, use 'Although'!"
            ),
            ConnectorExercise(
                id: "q-ever-whoever-oncall",
                prompt: "_____ is on call tonight must monitor the PagerDuty alerts and respond to any latency spikes immediately.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "Whoever"),
                    ConnectorExerciseOption(id: "b", text: "Whenever"),
                    ConnectorExerciseOption(id: "c", text: "Wherever"),
                    ConnectorExerciseOption(id: "d", text: "Whatever")
                ],
                correctOptionId: "a",
                connectorId: "whoever",
                connectorTerm: "Whoever",
                family: .emphasis,
                translation: "Quem quer que / Qualquer pessoa que",
                explanation: "'Whoever' refere-se a uma pessoa ('any person who') que atua como sujeito.",
                fullSentence: "Whoever is on call tonight must monitor the PagerDuty alerts and respond to any latency spikes immediately.",
                sentenceTranslation: "Quem quer que esteja de plantão hoje à noite deve monitorar os alertas do PagerDuty e responder a qualquer pico de latência imediatamente.",
                whyCorrect: "A lacuna ocupa a posição de sujeito humano que desempenha a função de plantonista ('Whoever').",
                whyOthersFail: "'Whenever' é tempo. 'Wherever' é lugar. 'Whatever' é coisa ou evento.",
                proTip: "Dica de ouro da Família -Ever: A lacuna é uma pessoa? Se sim, a resposta é 'Whoever'!"
            ),
            ConnectorExercise(
                id: "q-ever-whoever-pr-review",
                prompt: "_____ authored this pull request followed clean architecture principles and wrote excellent automated unit tests.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "Whatever"),
                    ConnectorExerciseOption(id: "b", text: "Whoever"),
                    ConnectorExerciseOption(id: "c", text: "Whenever"),
                    ConnectorExerciseOption(id: "d", text: "Wherever")
                ],
                correctOptionId: "b",
                connectorId: "whoever",
                connectorTerm: "Whoever",
                family: .emphasis,
                translation: "Quem quer que / Qualquer pessoa que",
                explanation: "'Whoever' refere-se ao autor humano do Pull Request.",
                fullSentence: "Whoever authored this pull request followed clean architecture principles and wrote excellent automated unit tests.",
                sentenceTranslation: "Quem quer que tenha criado este pull request seguiu os princípios de arquitetura limpa e escreveu excelentes testes unitários.",
                whyCorrect: "'Whoever' é o pronome que faz referência ao desenvolvedor (pessoa) autor do PR.",
                whyOthersFail: "As demais opções representam coisa ('Whatever'), tempo ('Whenever') e local ('Wherever').",
                proTip: "Pergunte a si mesmo: 'Posso trocar por Any person who?' Se sim, a resposta é 'Whoever'."
            ),
            ConnectorExercise(
                id: "q-ever-whenever-ci",
                prompt: "_____ the CI pipeline fails, an alert is sent to our squad Slack channel.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "Whenever"),
                    ConnectorExerciseOption(id: "b", text: "Whoever"),
                    ConnectorExerciseOption(id: "c", text: "Wherever"),
                    ConnectorExerciseOption(id: "d", text: "Whereas")
                ],
                correctOptionId: "a",
                connectorId: "whenever",
                connectorTerm: "Whenever",
                family: .time,
                translation: "Quando quer que / Sempre que",
                explanation: "'Whenever' expressa tempo ou frequência repetida ('every time that').",
                fullSentence: "Whenever the CI pipeline fails, an alert is sent to our squad Slack channel.",
                sentenceTranslation: "Sempre que a pipeline de CI falha, um alerta é enviado para o canal da nossa squad no Slack.",
                whyCorrect: "A oração descreve uma condição temporal recorrente ('every time that the pipeline fails').",
                whyOthersFail: "'Whoever' é pessoa. 'Wherever' é lugar. 'Whereas' é contraste analítico.",
                proTip: "Pense em 'When + ever' = sempre que acontecer no tempo."
            ),
            ConnectorExercise(
                id: "q-ever-wherever-cloud",
                prompt: "With cloud workstations, software engineers can code securely from _____ they are located.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "whenever"),
                    ConnectorExerciseOption(id: "b", text: "wherever"),
                    ConnectorExerciseOption(id: "c", text: "whoever"),
                    ConnectorExerciseOption(id: "d", text: "whatever")
                ],
                correctOptionId: "b",
                connectorId: "wherever",
                connectorTerm: "wherever",
                family: .emphasis,
                translation: "Onde quer que",
                explanation: "'Wherever' indica qualquer localização geográfica ou espacial ('in any place where').",
                fullSentence: "With cloud workstations, software engineers can code securely from wherever they are located.",
                sentenceTranslation: "Com estações de trabalho em nuvem, engenheiros de software podem programar com segurança de onde quer que estejam localizados.",
                whyCorrect: "A preposição 'from' e o particípio 'located' deixam explícito que o alvo da frase é um lugar físico/espacial.",
                whyOthersFail: "'Whenever' é momento temporal. 'Whoever' é pessoa. 'Whatever' é objeto/evento.",
                proTip: "Se a lacuna tratar de localização física ou remota ('in any place'), escolha 'Wherever'."
            ),
            ConnectorExercise(
                id: "q-ever-whereas-scrum-kanban",
                prompt: "Scrum focuses on short timeboxed iterations, _____ Kanban emphasizes a continuous workflow.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "wherever"),
                    ConnectorExerciseOption(id: "b", text: "whereas"),
                    ConnectorExerciseOption(id: "c", text: "whoever"),
                    ConnectorExerciseOption(id: "d", text: "whatever")
                ],
                correctOptionId: "b",
                connectorId: "whereas",
                connectorTerm: "whereas",
                family: .contrast,
                translation: "Ao passo que / Enquanto que",
                explanation: "'Whereas' conecta duas orações fazendo contraste analítico entre dois modelos de trabalho.",
                fullSentence: "Scrum focuses on short timeboxed iterations, whereas Kanban emphasizes a continuous workflow.",
                sentenceTranslation: "O Scrum foca em iterações curtas com prazos definidos, ao passo que o Kanban enfatiza o fluxo contínuo de trabalho.",
                whyCorrect: "'Whereas' é a conjunção exata para comparar lado a lado duas metodologias contrastantes.",
                whyOthersFail: "'Wherever' significa 'onde quer que' (lugar), gerando erro semântico grave nesta comparação.",
                proTip: "Cuidado clássico: apesar de começar com 'where', 'whereas' NÃO tem relação com lugar! Significa 'ao passo que'."
            ),
            ConnectorExercise(
                id: "q-ever-whatever-demo",
                prompt: "_____ happens during the production demo, remain calm and walk the stakeholders through the fallback plan.",
                options: [
                    ConnectorExerciseOption(id: "a", text: "Whatever"),
                    ConnectorExerciseOption(id: "b", text: "Whoever"),
                    ConnectorExerciseOption(id: "c", text: "Whenever"),
                    ConnectorExerciseOption(id: "d", text: "Wherever")
                ],
                correctOptionId: "a",
                connectorId: "whatever",
                connectorTerm: "Whatever",
                family: .emphasis,
                translation: "O que quer que / Qualquer coisa que",
                explanation: "'Whatever' refere-se a eventos ou acontecimentos inesperados ('no matter what').",
                fullSentence: "Whatever happens during the production demo, remain calm and walk the stakeholders through the fallback plan.",
                sentenceTranslation: "O que quer que aconteça durante a demonstração de produção, mantenha a calma e apresente o plano de contingência aos stakeholders.",
                whyCorrect: "O verbo 'happens' requer um sujeito que represente acontecimentos, coisas ou eventos ('Whatever').",
                whyOthersFail: "'Whoever' seria pessoa. 'Whenever' seria tempo. 'Wherever' seria local.",
                proTip: "Coisa, evento ou imprevisto ocorrendo? Use 'Whatever' ('no matter what happens')."
            )
        ]
    }
}

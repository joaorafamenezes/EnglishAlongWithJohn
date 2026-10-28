//
//  ConnectorsCatalogData.swift
//  English along with John - Data / Connectors
//

import Foundation

public enum ConnectorsCatalogData {
    public static let allConnectors: [Connector] = [
        Connector(
            id: "above-all",
            number: 1,
            connector: "Above all",
            translation: "Acima de tudo",
            family: .emphasis,
            grammarRule: "Usado para destacar a prioridade máxima ou o ponto mais importante de uma argumentação.",
            notes: "Muito comum em liderança técnica e decisões estratégicas de arquitetura.",
            examples: ["Above all, we must ensure the safety and reliability of our production servers.", "Above all, keep the user data protected and compliant with privacy regulations.", "He values honesty above all else in any partnership."]
        ),
        Connector(
            id: "actually",
            number: 2,
            connector: "Actually",
            translation: "Na verdade",
            family: .emphasis,
            grammarRule: "Usado para corrigir uma falsa impressão, esclarecer a realidade dos fatos ou introduzir um dado surpreendente.",
            notes: "Muito utilizado em reuniões de status quando a realidade difere da estimativa inicial.",
            examples: ["Actually the truth is worse than you can imagine.", "Actually our budget is almost done.", "You said that your project was on time. But, actually, your project is running out of time.", "When you said that you love me, actually it’s not totally true.", "Yesterday I needed to go to the office by car, because the bus had already left. Actually, I didn't want to take the bus; I prefer driving."]
        ),
        Connector(
            id: "afterwards",
            number: 3,
            connector: "Afterwards",
            translation: "Posteriormente / Depois / Depois disso",
            family: .time,
            grammarRule: "Advérbio de tempo que se refere a um momento subsequente. Costuma aparecer no início, no meio com conectivo ou no fim da oração.",
            notes: "Frequentemente usado como advérbio no início ou no fim de sentenças: 'I'll call you afterwards', 'We had dinner and went for a walk afterwards'.",
            examples: ["I went to the gym and afterwards I went home.", "We had dinner and went for a walk afterwards.", "She apologized afterwards.", "I'll call you afterwards.", "Afterwards you finish your tasks, call me.", "I want to go home, afterwards go to bed and fall asleep.", "I'll finish my English class and call you afterwards.", "We will conduct the Daily Standup first; afterwards, we can discuss the blocker in a breakout room.", "They deployed the hotfix and checked the monitoring metrics immediately afterwards."]
        ),
        Connector(
            id: "all-in-all",
            number: 4,
            connector: "All in all",
            translation: "De tudo em tudo / Em suma",
            family: .summary,
            grammarRule: "Usado para fazer uma avaliação geral equilibrada após considerar aspectos positivos e negativos.",
            notes: "Perfeito para retrospectivas de Sprint e fechamento de trimestre (QBR).",
            examples: ["All in all, the sprint was successful despite the mid-week outage.", "It was a challenging release, but all in all, the client was satisfied with the performance.", "All in all, the migration to microservices brought significant scalability improvements."]
        ),
        Connector(
            id: "along-with",
            number: 5,
            connector: "Along with",
            translation: "Junto com",
            family: .addition,
            grammarRule: "Indica companhia, inclusão ou anexo de um elemento a outro.",
            notes: "Frequentemente usado para anexos de relatórios, acompanhantes e colaboração entre squads.",
            examples: ["A: Hello my friend, it’s good to see you. But I need to go home now. B: I can walk along with you if you want.", "I made an appointment in a restaurant, and Cinthia will go along with me.", "When you send your project report, along with it you can share your graphics for me.", "The Scrum Master made the Retrospective along with the developers and the QAs.", "When you buy a new iPhone, you need to buy the charger separately. It won't come along with the phone."]
        ),
        Connector(
            id: "although",
            number: 6,
            connector: "Although",
            translation: "Embora",
            family: .contrast,
            grammarRule: "Conjunção subordinativa concessiva. Requer obrigatoriamente oração completa (sujeito + verbo). Nunca usar seguido de substantivo direto.",
            notes: "Ex: 'Although it's raining' (certo) vs 'Although the rain' (errado; use 'Despite the rain').",
            examples: ["Although it’s raining, I’m going to the beach.", "Although it’s harder than I thought, I will make it by myself.", "Although you are a hard person, I still love you.", "Although the day isn’t so good, we need to go out and see the clouds.", "Although you didn’t come to the party, it was good.", "Although the release deadline was tight, the engineering team delivered zero critical bugs."]
        ),
        Connector(
            id: "apart-from",
            number: 7,
            connector: "Apart from",
            translation: "Excetuando / Excluindo",
            family: .substitution,
            grammarRule: "Equivale a 'except for' ou 'other than'. Indica a exclusão deliberada de um elemento do restante do conjunto.",
            notes: "Usado para isolar exceções em relatórios de testes e listas de requisitos.",
            examples: ["Apart from a few minor CSS bugs, the application is ready for deploy.", "Apart from the database migration, all deployment steps were automated.", "Apart from John, the whole backend squad attended the architectural planning session."]
        ),
        Connector(
            id: "as-a-result",
            number: 8,
            connector: "As a result",
            translation: "Como resultado",
            family: .cause,
            grammarRule: "Conector de transição que introduz o efeito direto ou a consequência lógica de uma causa antecedente.",
            notes: "Geralmente aparece no início de uma oração após ponto final ou ponto e vírgula, seguido de vírgula.",
            examples: ["You didn’t do your job correctly. As a result, our clients are calling us with many problems.", "I read the book that you lent me and, as a result, I can discover many different things.", "As a result of your question, we could find the right answer.", "Grêmio lost one more match on Saturday, and as a result, the manager was fired.", "The squad automated the regression suite. As a result, release cycle time dropped by 50%."]
        ),
        Connector(
            id: "as-far-as",
            number: 9,
            connector: "As far as",
            translation: "Pelo que / Até onde",
            family: .condition,
            grammarRule: "Locução conjuntiva que delimita o alcance do conhecimento ou informação disponível ('as far as I know').",
            notes: "Essencial para reuniões de alinhamento quando não se quer prometer certeza absoluta.",
            examples: ["As far as I know, Rebeca delivered the project on time.", "As far as he told me, Michael Jackson bought that house when he was alive.", "As far as Carlos said, the enterprise will cancel the project and everyone will be reallocated.", "As far as the client said to me, the problem is it's screen that doesn't work. It had been working the day before yesterday, and yesterday didn't work either.", "As far as the infrastructure metrics show, the cluster is operating within normal memory limits."]
        ),
        Connector(
            id: "as-long-as",
            number: 10,
            connector: "As long as",
            translation: "Contanto que / Desde que",
            family: .condition,
            grammarRule: "Expressa uma condição contínua indispensável. Equivale a 'provided that'.",
            notes: "Muito usado em acordos de nível de serviço (SLA) e definições de pronto (DoD).",
            examples: ["As long as you do your homework, you will pass the exam.", "Things will be easier as long as you do your job.", "You can work remotely as long as you attend the daily standup and deliver your Sprint goals."]
        ),
        Connector(
            id: "as-well",
            number: 11,
            connector: "As well",
            translation: "Também (no fim da frase)",
            family: .addition,
            grammarRule: "Advérbio aditivo colocado tradicionalmente no final da oração para adicionar um elemento.",
            notes: "Equivale a 'too', soando ligeiramente mais polido.",
            examples: ["I know that's a hard subject, I need to study more as well.", "Can I go with you to the mall as well?", "A: Hi. I would like to order the daily plate, please. B: Oh nice, I like this plate. I would like to as well.", "I was invited to the party as well.", "The backend needs an update, and we should upgrade the frontend dependencies as well."]
        ),
        Connector(
            id: "as-well-as",
            number: 12,
            connector: "As well as",
            translation: "Assim como / Bem como",
            family: .addition,
            grammarRule: "Liga dois elementos em paralelo. Quando liga sujeitos, o verbo concorda com o primeiro sujeito.",
            notes: "Comum na descrição de responsabilidades de papéis ágeis e squads interdisciplinares.",
            examples: ["As well as the moon is bright, your eyes are the light that bright my side.", "You need to come down and take a breath, as well as me.", "The team needs a software developer as well as a QA.", "He is responsible for Sprint Planning as well as Backlog Refinement.", "Our CI pipeline executes unit tests as well as security vulnerability scans."]
        ),
        Connector(
            id: "at-all",
            number: 13,
            connector: "At all",
            translation: "Mesmo (enfatizar no fim da frase) / De forma alguma",
            family: .emphasis,
            grammarRule: "Expressão intensificadora comumente posicionada no final de frases negativas ou afirmativas enfáticas.",
            notes: "Em frases negativas significa 'de jeito nenhum / absolutamente nada'; em linguagem coloquial enfática reforça o sentimento geral.",
            examples: ["I really need this job, at all.", "My job is harder nowadays. I need a vacation soon, at all.", "Sometimes you only need to stop and look at the flowers. It’s pretty good, at all.", "You need to know London, I loved going there last year. It’s the best place I ever had before, at all.", "The legacy API is not scalable at all, so we decided to rewrite it in Go."]
        ),
        Connector(
            id: "at-last",
            number: 14,
            connector: "At last",
            translation: "Por fim / Finalmente",
            family: .time,
            grammarRule: "Expressa a ocorrência de algo muito esperado após demora, esforço ou ansiedade.",
            notes: "Carrega alívio emocional. Diferente de 'lastly' (que apenas enumera o último item de uma lista).",
            examples: ["Like I said, this year was hard for us. At last I would like to inform you that no one will be fired because of this.", "Renato Gaúcho signed with Grêmio at last.", "A: Houston we have a problem… B: few minutes later… C: It’s late, but we found the problem at last.", "The meeting ended at last.", "After three hours of deep debugging, we resolved the race condition at last."]
        ),
        Connector(
            id: "at-least",
            number: 15,
            connector: "At least",
            translation: "Pelo menos",
            family: .emphasis,
            grammarRule: "Indica uma quantidade mínima satisfatória ou um aspecto consolador diante de uma dificuldade.",
            notes: "Excelente para destacar avanços parciais em retrospectivas.",
            examples: ["Oh my gosh! The ship is sinking. At least they let the men in the end, probably we're gonna save ourselves.", "A: Hey John, you are very late. Don’t you have shame? B: No! I came at least.", "A: The final exams will be tomorrow. B: Really! Did you study enough? C: Although I didn’t study enough, at least I studied Math, the hardest one.", "I don’t know which more sentences I can write using AT LEAST. At least I made some.", "We didn't complete all user stories, but at least we finished the core payment feature."]
        ),
        Connector(
            id: "because",
            number: 16,
            connector: "Because",
            translation: "Porque (introduz oração)",
            family: .cause,
            grammarRule: "Conjunção explicativa/causal seguida obrigatoriamente de uma oração completa (sujeito + verbo).",
            notes: "Responde diretamente à pergunta 'Why?'. Não confundir com 'Because of' (que exige substantivo).",
            examples: ["I hate you, because you are so childish.", "The developer will be late today because the traffic is awful.", "We rolled back the deployment because the database connection timed out."]
        ),
        Connector(
            id: "because-of",
            number: 17,
            connector: "Because of",
            translation: "Por causa de (seguido de substantivo)",
            family: .cause,
            grammarRule: "Preposição composta causal. Deve ser seguida diretamente de substantivo, pronome ou gerúndio. Nunca de oração com verbo conjugado.",
            notes: "Ex: 'Because of the rain' (correto) vs 'Because of it is raining' (errado).",
            examples: ["The doctor said you are better now because of physical activity.", "I’m crying because of what you said.", "Sometimes the rain falls because of your lies.", "The release was delayed because of unexpected network latency."]
        ),
        Connector(
            id: "beforehand",
            number: 18,
            connector: "Beforehand",
            translation: "De antemão / Previamente",
            family: .time,
            grammarRule: "Advérbio de tempo que indica antecipação em relação a um evento futuro.",
            notes: "Indispensável no planejamento ágil: refinar histórias de antemão evita bloqueios na Sprint.",
            examples: ["Please review the architectural design document beforehand.", "Setting up test databases beforehand ensures smooth automated testing.", "We prepared all configuration secrets beforehand so deployment took under two minutes."]
        ),
        Connector(
            id: "besides",
            number: 19,
            connector: "Besides",
            translation: "Além disso",
            family: .addition,
            grammarRule: "Conector aditivo e argumentativo. Introduz uma razão suplementar de peso.",
            notes: "Cuidado: 'beside' (sem 's') significa 'ao lado de'; 'besides' (com 's') significa 'além disso'.",
            examples: ["A: You need to clean the kitchen at all. B: OK. I gonna do that. A: Besides, clean the room too.", "A: The manager said to work late today. B: Besides, he said he will buy some pizzas when we need to work late.", "I don’t really want to go out tonight; It’s freezing outside. Besides, I have an early meeting tomorrow.", "This cache layer reduces database load; besides, it cuts down API response time to under 50ms."]
        ),
        Connector(
            id: "but",
            number: 20,
            connector: "But",
            translation: "Mas / Porém",
            family: .contrast,
            grammarRule: "Conjunção coordenativa adversativa fundamental que liga duas orações de ideias contrastantes.",
            notes: "O conector de oposição mais universal da língua inglesa.",
            examples: ["He is my friend. He has a beautiful house on the beach, but he doesn’t go there so much.", "It was hard to fix that problem, but I could handle it.", "It was hard to fix that problem, but I could manage it.", "A: Hey John, It’s so dark in this street, don’t you think? B: Yeh, but we need to go through this way.", "The refactoring was complex, but the code is much cleaner now."]
        ),
        Connector(
            id: "consequently",
            number: 21,
            connector: "Consequently",
            translation: "Consequentemente",
            family: .cause,
            grammarRule: "Conector formal que estabelece uma relação causal direta de causa e efeito.",
            notes: "Tom formal, muito valorizado em documentações de arquitetura (ADR) e relatórios de post-mortem.",
            examples: ["The third-party payment gateway went down; consequently, checkout transactions failed.", "We optimized our Docker build stages; consequently, image sizes dropped from 1.2GB to 85MB.", "He missed several project deadlines and, consequently, lost the client's trust."]
        ),
        Connector(
            id: "currently",
            number: 22,
            connector: "Currently",
            translation: "Atualmente",
            family: .time,
            grammarRule: "Falso amigo clássico! 'Currently' significa 'atualmente / no momento presente'. 'Actually' significa 'na verdade'.",
            notes: "Nunca use 'actually' querendo dizer 'atualmente'. Use 'currently'!",
            examples: ["Currently, our clients are satisfied with our products.", "Currently, we need to find a new market to explore.", "Our company is currently worried about forest deforestation.", "We are currently migrating our monolithic services to a Kubernetes cluster."]
        ),
        Connector(
            id: "definitely",
            number: 23,
            connector: "Definitely",
            translation: "Definitivamente / Com certeza",
            family: .emphasis,
            grammarRule: "Advérbio de modo e certeza que confirma categoricamente uma declaração sem margem para dúvida.",
            notes: "Atenção à grafia em inglês: D-E-F-I-N-I-T-E-L-Y (com 'i', nunca com 'a').",
            examples: ["Definitely, we can learn English with teacher Michele.", "My team made a POC (Proof of Concept) and, definitely, we can build the program.", "We should definitely write integration tests before releasing this feature to production."]
        ),
        Connector(
            id: "despite",
            number: 24,
            connector: "Despite",
            translation: "Apesar de (sem verbo)",
            family: .contrast,
            grammarRule: "Preposição concessiva. Seguido obrigatoriamente de substantivo, pronome ou gerúndio (-ing). Nunca use 'despite of' — o 'of' não existe aqui!",
            notes: "Correto: 'Despite the delay' ou 'In spite of the delay'. Errado: 'Despite of'.",
            examples: ["Despite the tight deadline, the squad delivered all sprint commitments.", "Despite having limited cloud resources, the microservice handled high traffic smoothly.", "The team kept high morale despite several unexpected production bugs."]
        ),
        Connector(
            id: "due-to",
            number: 25,
            connector: "Due to",
            translation: "Devido a",
            family: .cause,
            grammarRule: "Locução prepositiva causal sinônima de 'caused by' ou 'because of'. Seguido de substantivo.",
            notes: "Muito frequente em comunicações de status de incidentes e sustentação.",
            examples: ["Due to an outage, all the programs were stopped.", "The deployment was postponed due to unexpected database migration issues.", "Due to high user concurrency on Black Friday, we auto-scaled our server pods."]
        ),
        Connector(
            id: "equally",
            number: 26,
            connector: "Equally",
            translation: "Igualmente / Do mesmo modo",
            family: .addition,
            grammarRule: "Advérbio que estabelece equivalência ou peso proporcional entre dois fatores.",
            notes: "Útil ao priorizar histórias de usuário ou requisitos não-funcionais.",
            examples: ["System security and performance are equally important for our enterprise clients.", "Both frontend responsiveness and backend reliability are equally valued by the team.", "Junior developers and senior architects are equally encouraged to propose improvements."]
        ),
        Connector(
            id: "even",
            number: 27,
            connector: "Even",
            translation: "Mesmo / Até mesmo / Ainda que",
            family: .emphasis,
            grammarRule: "Advérbio intensificador que expressa surpresa ou um caso extremo.",
            notes: "Pode ser posicionado antes de verbos, adjetivos ou substantivos para realçar algo inesperado.",
            examples: ["We couldn’t fix the bug, not even me.", "You should go to England, even alone.", "Even a small syntax typo can break the entire deployment build pipeline."]
        ),
        Connector(
            id: "even-if",
            number: 28,
            connector: "Even if",
            translation: "Mesmo se / Ainda que (hipotético)",
            family: .condition,
            grammarRule: "Introduz uma condição extrema ou hipotética que não altera o desfecho da oração principal.",
            notes: "'Even if' trata de possibilidade futura/hipotética; 'Even though' trata de um fato concreto real.",
            examples: ["I will go to the party, even if you won’t go.", "Even if you can’t finish your job until next Friday, I can help you next week.", "Even if the client requests changes at the last minute, our CI/CD pipeline allows safe rollbacks."]
        ),
        Connector(
            id: "even-though",
            number: 29,
            connector: "Even though",
            translation: "Embora / Apesar de que (fato real)",
            family: .contrast,
            grammarRule: "Conjunção concessiva enfática que introduz um fato real que contrasta com a oração principal.",
            notes: "Mais forte e enfático que 'although'. Exige oração completa (sujeito + verbo).",
            examples: ["Even though I don’t like vegetables, I eat them.", "Even though I don’t have much money, I will go out tonight.", "Even though you don’t like me, I respect you, at all, because you are a good person.", "Even though we married a long time ago, I still love you as the first day we met.", "Even though the codebase was legacy, we managed to add modern automated tests."]
        ),
        Connector(
            id: "for",
            number: 30,
            connector: "For",
            translation: "Pois / Visto que (conector coordenativo)",
            family: .cause,
            grammarRule: "Conjunção coordenativa formal (uma das FANBOYS: For, And, Nor, But, Or, Yet, So). Introduz o motivo explicativo.",
            notes: "Soa literário e formal. É sempre precedido por vírgula quando liga orações independentes.",
            examples: ["He took an umbrella, for dark clouds were gathering.", "We stopped testing, for the server was down.", "The architect paused the migration, for high data inconsistency was detected."]
        ),
        Connector(
            id: "for-instance",
            number: 31,
            connector: "For instance",
            translation: "Por exemplo",
            family: .example,
            grammarRule: "Locução conectiva usada para exemplificar ou ilustrar uma afirmação anterior. Sinônimo exato de 'for example'.",
            notes: "Pode vir no início, no meio entre vírgulas, ou no fim da oração.",
            examples: ["A: I don’t understand what you are saying. B: Let me explain again, for instance: ...", "For instance, if you vote for that candidate, you won’t eat rump steak.", "For instance, when the developer finishes the program, he could do other things.", "You can configure multiple caching strategies; for instance, Redis for sessions and CloudFront for assets."]
        ),
        Connector(
            id: "furthermore",
            number: 32,
            connector: "Furthermore",
            translation: "Além disso / De mais a mais",
            family: .addition,
            grammarRule: "Conector aditivo formal que adiciona um argumento relevante para reforçar uma tese.",
            notes: "Muito usado em propostas comerciais, relatórios técnicos e apresentações executivas.",
            examples: ["The new database engine reduces query latency; furthermore, it offers built-in multi-region replication.", "Our team completed all user stories on time; furthermore, we improved overall unit test coverage by 15%."]
        ),
        Connector(
            id: "hence",
            number: 33,
            connector: "Hence",
            translation: "Portanto / Por isso / Daí",
            family: .cause,
            grammarRule: "Advérbio conectivo formal que indica decorrência lógica e direta de uma causa explicada antes.",
            notes: "Muito comum em documentação de engenharia e matemática. Equivale a 'therefore'.",
            examples: ["A: Hey John, what happened to you? B: Well, I was working and not feeling well, hence I needed to go home.", "The feature wasn’t done in time, hence we need to reschedule the project.", "My son Nícolas didn’t do the homework, hence he will not play video games today.", "The legacy library has unpatched security vulnerabilities, hence we must upgrade immediately."]
        ),
        Connector(
            id: "however",
            number: 34,
            connector: "However",
            translation: "Contudo / No entanto / Como quer que / Por mais que",
            family: .contrast,
            grammarRule: "Possui 2 usos essenciais: 1) Conector adversativo ('contudo/no entanto', seguido de vírgula); 2) Membro da Família -Ever com sentido de modo ou intensidade ('como quer que / por mais que + adjetivo').",
            notes: "Membro essencial da Família -Ever ('These are worth learning together: Whatever, Whenever, Wherever, Whoever, However'). Ex: 'However hard it is...' (por mais difícil que seja) e 'However you do it...' (como quer que faça).",
            examples: ["There's heavy traffic ahead; however, I don’t have another way.", "However hard the challenge seems, our agile squad finds a way to deliver value.", "You can organize your code however you think is cleanest.", "The load test showed high memory usage; however, cpu throttling remained within acceptable thresholds."]
        ),
        Connector(
            id: "if",
            number: 35,
            connector: "If",
            translation: "Se (uma condição direta)",
            family: .condition,
            grammarRule: "Conjunção condicional básica para orações condicionais (Zero, First, Second, Third Conditionals).",
            notes: "Usa-se 'if' para condições de causa-efeito; use 'whether' quando há duas opções explícitas em escolha.",
            examples: ["If you do that, I will never talk to you again.", "A: Hey Nick, will you go to the party? B: Hey dad, if you go there I’ll go too.", "A: Hey Batman, how will you save Gotham? Penguin is so clever. B: I don’t know, at all; however, if he does something wrong, I will catch him.", "If the pull request passes all automated CI checks, the tech lead will merge it."]
        ),
        Connector(
            id: "in-advance",
            number: 36,
            connector: "In advance",
            translation: "Antecipadamente / Com antecedência",
            family: .time,
            grammarRule: "Locução adverbial temporal que indica ação prévia ou preparatória antes de um evento futuro.",
            notes: "Comum na etiqueta de e-mails corporativos ('Thank you in advance for your assistance').",
            examples: ["Please let me know in advance if you can’t attend the sprint review.", "Thank you in advance for your help.", "Please inform me in advance about any architectural changes.", "You need to pay in advance if you want to have a consulting meeting with him."]
        ),
        Connector(
            id: "in-case",
            number: 37,
            connector: "In case",
            translation: "No caso de / Para o caso de",
            family: .condition,
            grammarRule: "Expressa precaução diante de uma possibilidade que pode ou não acontecer no futuro.",
            notes: "'In case' difere de 'if': fazemos algo 'in case' por precaução ANTES do evento acontecer.",
            examples: ["In case the airplane falls, we need to take the parachute and jump out of the plane.", "Take this shotgun, it's for your protection, in case someone invades your home.", "Here, take this exam to your doctor, just in case.", "We configured automated database snapshots every hour, in case we need disaster recovery."]
        ),
        Connector(
            id: "in-contrast",
            number: 38,
            connector: "In contrast",
            translation: "Ao contrário de / Em contraste",
            family: .contrast,
            grammarRule: "Expressão conectiva que estabelece uma comparação frontal entre duas entidades com características opostas.",
            notes: "Pode ser usado isolado com vírgula ou como 'in contrast to/with + substantivo'.",
            examples: ["In contrast to the old SQL database, the new document store scales horizontally with ease.", "Sprint velocity was low last month. In contrast, this sprint the squad surpassed all story point targets."]
        ),
        Connector(
            id: "in-fact",
            number: 39,
            connector: "In fact",
            translation: "Na verdade / De fato",
            family: .emphasis,
            grammarRule: "Conector de esclarecimento e ênfase. Usado para confirmar a verdade ou retificar uma suposição.",
            notes: "Muito natural tanto no início de frase quanto no final como termo conclusivo.",
            examples: ["In fact, I’m not Paola Bracho; I’m an Usurpadora.", "Carlos Daniel Bracho is a liar, in fact.", "In fact, Brazil is the only country five-time champion of football.", "In fact, refactoring this legacy code will save hundreds of server hours each month."]
        ),
        Connector(
            id: "in-order-to",
            number: 40,
            connector: "In order to",
            translation: "A fim de / Para",
            family: .purpose,
            grammarRule: "Locução que expressa finalidade ou propósito deliberado. Seguido obrigatoriamente de verbo no infinitivo (base form).",
            notes: "Para oração com sujeito próprio, use 'in order that' ou 'so that'.",
            examples: ["I came to work in person in order to finish the project.", "You are being hired in order to improve the deployment process.", "I’m here in order to help you.", "I helped my son in order to pass the exam.", "We implemented Redis caching in order to reduce response latency."]
        ),
        Connector(
            id: "in-short",
            number: 41,
            connector: "In short",
            translation: "Para resumir / Em suma",
            family: .summary,
            grammarRule: "Conector conclusivo curto que condensa uma explicação longa em poucas palavras.",
            notes: "Ideal para resumos executivos de atas de reunião e pull requests.",
            examples: ["In short, the database migration succeeded without downtime.", "The server crashed, the backup failed, and the DNS was down. In short, it was a rough day."]
        ),
        Connector(
            id: "in-spite-of",
            number: 42,
            connector: "In spite of",
            translation: "Apesar de (com 'of')",
            family: .contrast,
            grammarRule: "Locução prepositiva concessiva idêntica a 'despite'. Seguido de substantivo, pronome ou verbo no gerúndio (-ing).",
            notes: "Lembrete: 'In spite OF' tem 'of'; 'Despite' NUNCA tem 'of'!",
            examples: ["In spite of what you said, he could understand.", "In spite of the bad weather, the outdoor company event was enjoyable.", "The squad delivered the milestone on time in spite of unexpected team reallocations."]
        ),
        Connector(
            id: "indeed",
            number: 43,
            connector: "Indeed",
            translation: "De fato / Realmente",
            family: .emphasis,
            grammarRule: "Advérbio de confirmação e reforço positivo de uma ideia já expressa anteriormente.",
            notes: "Usado tanto no início quanto no fim da frase para validar uma afirmação factual.",
            examples: ["The team made significant progress this sprint. Indeed, they completed all high-priority backlog items ahead of schedule.", "Indeed the Product Owner canceled the project, because of the new regulations.", "The performance metrics are impressive indeed."]
        ),
        Connector(
            id: "instead-of",
            number: 44,
            connector: "Instead of",
            translation: "Em vez de / Ao invés de",
            family: .substitution,
            grammarRule: "Preposição de substituição ou escolha alternativa. Exige verbo no gerúndio (-ing) ou substantivo.",
            notes: "Correto: 'Instead of going' (com -ing). Errado: 'Instead of go'.",
            examples: ["Maybe you should stay home instead of going out tonight.", "You should agree with me instead of what she said, it’s unfair.", "We can hire one more backend developer instead of a frontend developer.", "The squad chose to implement automated end-to-end tests instead of manual QA testing."]
        ),
        Connector(
            id: "likewise",
            number: 45,
            connector: "Likewise",
            translation: "Semelhante a / Igualmente / Da mesma forma",
            family: .addition,
            grammarRule: "Advérbio e conector que denota paralelismo, reciprocidade ou ação análoga ('in the same way').",
            notes: "Muito usado em respostas educadas ('Nice to meet you' -> 'Likewise') e em padrões técnicos comparados.",
            examples: ["Senior engineers must review their pull requests. Likewise, junior developers are expected to follow the same testing standards.", "A: Thank you for helping me, your team is incredible. B: Likewise. Let’s keep in touch and work together in other opportunities.", "Improving test coverage reduces bugs in production. Likewise, clear documentation speeds up developer onboarding."]
        ),
        Connector(
            id: "meanwhile",
            number: 46,
            connector: "Meanwhile",
            translation: "Enquanto isso / Nesse meio tempo",
            family: .time,
            grammarRule: "Advérbio de transição escrito em uma única palavra. Indica ações simultâneas ocorrendo em lugares ou equipes diferentes.",
            notes: "Perfeito para coordenar trabalhos paralelos de frontend e backend.",
            examples: ["The frontend engineers started building the user interface. Meanwhile, the backend team set up the database schemas and authentication endpoints.", "The Grêmio team are training now, meanwhile the coach Renato Portalupi is in his official presentation in the Training Center.", "You are asleep, meanwhile I cleaned the kitchen.", "The QA squad ran manual smoke tests. Meanwhile, the DevOps engineer provisioned the staging server."]
        ),
        Connector(
            id: "whoever",
            number: 47,
            connector: "Whoever",
            translation: "Quem quer que / Qualquer pessoa que",
            family: .emphasis,
            grammarRule: "Pronome relativo composto com o sufixo '-ever'. Refere-se a qualquer pessoa, sem especificar quem ('any person who' / 'no matter who'). Exerce função de sujeito ou objeto.",
            notes: "Membro essencial da Família -Ever ('These are worth learning together: Whatever, Whenever, Wherever, Whoever, However'). Muito comum em regras de equipe, plantões de suporte e governança.",
            examples: ["Whoever authored this pull request followed all clean code principles and unit test guidelines.", "Whoever is on call this weekend must monitor the production alerts in PagerDuty.", "Whoever discovers the root cause of the bug should document it in the post-mortem report.", "Send the architecture meeting invite to whoever is leading the squad this sprint."]
        ),
        Connector(
            id: "mostly",
            number: 48,
            connector: "Mostly",
            translation: "Na maioria / Em grande parte",
            family: .emphasis,
            grammarRule: "Advérbio de proporção predominante. Equivale a 'mainly' ou 'largely'.",
            notes: "Usado para caracterizar a composição de squads, linguagens do stack ou hábitos.",
            examples: ["Mostly I study until late.", "The team is mostly composed of backend developers, with only two UI specialists.", "Most of our backend microservices are written in TypeScript and Node.js."]
        ),
        Connector(
            id: "nevertheless",
            number: 49,
            connector: "Nevertheless",
            translation: "Contudo / Não obstante (muito formal)",
            family: .contrast,
            grammarRule: "Conector adversativo de alta formalidade. Sinaliza concessão forte ('despite what has just been said').",
            notes: "Comum em relatórios executivos e auditorias de conformidade.",
            examples: ["The architectural migration carried high risks; nevertheless, the leadership team approved the investment.", "We encountered several network timeouts; nevertheless, the batch job completed successfully."]
        ),
        Connector(
            id: "no-longer",
            number: 50,
            connector: "No longer",
            translation: "Não mais",
            family: .time,
            grammarRule: "Locução adverbial temporal que expressa cessação definitiva de um estado, hábito ou condição passada.",
            notes: "Posiciona-se geralmente antes do verbo principal ou após o verbo 'to be'.",
            examples: ["He no longer works at the consultancy.", "I no longer eat junk food.", "That feature is no longer available in the latest release.", "The tech lead said the QA is no longer available for manual testing tasks, only for automated tests."]
        ),
        Connector(
            id: "nonetheless",
            number: 51,
            connector: "Nonetheless",
            translation: "Ainda assim / Não obstante",
            family: .contrast,
            grammarRule: "Advérbio de concessão formal idêntico a 'nevertheless'. Indica que uma dificuldade não impediu o resultado.",
            notes: "Sempre escrito como uma única palavra sem espaços.",
            examples: ["The refactoring was demanding; nonetheless, it yielded a 40% improvement in code readability.", "Cloud expenses were higher this quarter; nonetheless, customer acquisition grew exponentially."]
        ),
        Connector(
            id: "nor",
            number: 52,
            connector: "Nor",
            translation: "Nem (conecta ideias negativas)",
            family: .contrast,
            grammarRule: "Conjunção coordenativa que conecta duas ideias negativas. Frequentemente forma o par correlativo 'neither... nor'.",
            notes: "Quando 'nor' inicia uma oração independente, provoca inversão sujeito-verbo (ex: 'nor do I').",
            examples: ["I like neither coffee nor tea.", "I like neither vegetables nor fruit.", "We like neither Java nor Spring frameworks.", "The server did not respond to ping requests, nor did it write any crash logs to the disk."]
        ),
        Connector(
            id: "on-the-other-hand",
            number: 53,
            connector: "On the other hand",
            translation: "Por outro lado",
            family: .contrast,
            grammarRule: "Locução conectiva de contraste usada para ponderar uma perspectiva oposta ou um contraponto.",
            notes: "Frequentemente usada em conjunto com 'on the one hand' para avaliar trade-offs arquiteturais.",
            examples: ["The car is cheap. On the other hand, it uses a lot of fuel.", "I didn’t like this house. On the other hand, I liked the kitchen.", "Monoliths are simpler to deploy initially. On the other hand, microservices scale teams more independently."]
        ),
        Connector(
            id: "on-the-whole",
            number: 54,
            connector: "On the whole",
            translation: "No todo / Em geral / Em linhas gerais",
            family: .summary,
            grammarRule: "Expressão avaliativa que sintetiza o julgamento global após ponderar prós e contras.",
            notes: "Significa 'generally speaking' ou 'all things considered'.",
            examples: ["On the whole, the project was a success, despite a few delays.", "There were minor bugs, but on the whole, the sprint went well.", "The team is performing well, on the whole.", "On the whole, our quarter is doing great. We’ll deliver everything we planned at the beginning."]
        ),
        Connector(
            id: "only-if",
            number: 55,
            connector: "Only if",
            translation: "Apenas se / Só se (condição estrita)",
            family: .condition,
            grammarRule: "Introduz uma condição estrita e exclusiva: a ação principal ocorre sob aquela condição e sob nenhuma outra.",
            notes: "Se 'Only if' iniciar a frase, a oração principal sofre inversão (ex: 'Only if tests pass will we deploy').",
            examples: ["We will deploy the release only if all tests pass.", "I will take the role only if it allows remote work.", "You can speak to the client only if the manager approves.", "I’m going to the party, only if Cinthia goes too."]
        ),
        Connector(
            id: "or",
            number: 56,
            connector: "Or",
            translation: "Ou (alternativa)",
            family: .condition,
            grammarRule: "Conjunção coordenativa de disjunção que liga termos ou orações indicando alternativa ou escolha.",
            notes: "Pode formar o par 'either... or' para indicar alternativas exclusivas.",
            examples: ["Do you prefer coffee or tea?", "Both are good for me, coffee or tea.", "We can store application sessions in Redis or in encrypted cookies.", "You should submit the pull request today, or the release manager will hold it until next week."]
        ),
        Connector(
            id: "otherwise",
            number: 57,
            connector: "Otherwise",
            translation: "Senão / Caso contrário",
            family: .condition,
            grammarRule: "Advérbio conectivo que introduz a consequência negativa caso a condição anterior não seja cumprida.",
            notes: "Equivale a 'or else' ou 'if not'. Muito comum em avisos de prazos e bloqueios.",
            examples: ["We need to fix this blocker today; otherwise, the sprint deadline will slip.", "Write down the credentials; otherwise, you might forget them.", "Hurry up, otherwise we'll miss the daily meeting.", "A: We are going to Spain next week. B: Cool! What do you do if your luggage disappears on the plane? A: First, I’ll call the flight attendant, otherwise I will call 911 and they fight (eles que lutem) HAHAHAHA its a joke.", "Make sure to commit your changes; otherwise, you may lose work during branch checkout."]
        ),
        Connector(
            id: "particularly",
            number: 58,
            connector: "Particularly",
            translation: "Particularmente / Em especial",
            family: .emphasis,
            grammarRule: "Advérbio de especificação que destaca um item dentro de uma categoria mais ampla.",
            notes: "Sinônimo exato de 'especially'.",
            examples: ["The engineering leadership was impressed by the team, particularly the junior developer who solved the memory leak.", "Database query optimization is crucial, particularly for high-traffic e-commerce checkout endpoints."]
        ),
        Connector(
            id: "rather-than",
            number: 59,
            connector: "Rather (than)",
            translation: "Preferível do que / Em vez de",
            family: .substitution,
            grammarRule: "Locução conjuntiva de preferência que contrasta duas opções, favorecendo uma em detrimento da outra.",
            notes: "Expressa escolha consciente baseada em valor ou prioridade.",
            examples: ["I prefer coffee rather than tea. But I like tea too.", "When I was younger, I preferred to play soccer rather than hide and seek.", "Friday is a day that I like cleaning at home. I prefer to start in the office rather than the kitchen.", "We decided to use asynchronous message queues rather than direct HTTP coupling between microservices."]
        ),
        Connector(
            id: "since",
            number: 60,
            connector: "Since",
            translation: "Desde (tempo) / Visto que (causa)",
            family: .cause,
            grammarRule: "Possui duas funções vitais: 1) Marcador temporal de ponto de partida com Present Perfect; 2) Conjunção causal ('visto que / já que').",
            notes: "No início da oração frequentemente significa 'já que / visto que'; com anos e datas indica tempo.",
            examples: ["Since I was born, I have known myself.", "I have known Cinthia since 2024.", "I have been working at GFT since 2022.", "Since the database credentials expired, the backend could not establish connections.", "Since we already met our sprint goal early, we started researching the next architectural POC."]
        ),
        Connector(
            id: "so",
            number: 61,
            connector: "So",
            translation: "Assim / Por isso / Então",
            family: .cause,
            grammarRule: "Conjunção coordenativa de resultado direto (uma das FANBOYS). Liga uma razão ao seu resultado.",
            notes: "É o conector de resultado mais comum e coloquial do inglês.",
            examples: ["It was raining heavily, so we decided to stay indoors.", "I woke up late, so I missed the morning bus.", "She studied consistently every day, so she passed the exam.", "My son was at a party and decided to come home earlier, so I decided to pick him up and bring him home.", "Actually, I’m not working as a software developer, so I don’t code anymore.", "I can’t come in advance, so I called Leo Messi to inform you. Do you know him?", "The server CPU reached 95%, so the auto-scaler launched two additional instances."]
        ),
        Connector(
            id: "so-that",
            number: 62,
            connector: "So that",
            translation: "A fim de que / De modo que",
            family: .purpose,
            grammarRule: "Conjunção de finalidade seguida de oração completa com verbo modal (can, could, may, might, will, would).",
            notes: "Diferente de 'in order to' (que recebe verbo no infinitivo), 'so that' recebe oração com sujeito e modal.",
            examples: ["We are here now, so that we can cook.", "I am taking detailed notes so that I can remember the action items later.", "The DevOps engineer automated the test pipeline so that developers can deploy with confidence.", "We added comprehensive logging so that we can diagnose production errors quickly."]
        ),
        Connector(
            id: "such",
            number: 63,
            connector: "Such",
            translation: "Tal / Tão (enfático antes de substantivo)",
            family: .emphasis,
            grammarRule: "Modificador enfático usado antes de [artigo + adjetivo + substantivo] ('such a good day').",
            notes: "Cuidado: 'so' modifica adjetivos puros ('so good'); 'such' modifica expressões nominais ('such a good team').",
            examples: ["It was such a good movie that I watched it twice.", "She is such a talented developer.", "They faced such difficult challenges during the project.", "Yesterday was such a good day, so that we could go out and have fun with our friends.", "You said to me that the company was such an amazing place to work. Actually, it isn't a good place to work, it’s awful."]
        ),
        Connector(
            id: "such-as",
            number: 64,
            connector: "Such as",
            translation: "Tal como / Como por exemplo",
            family: .example,
            grammarRule: "Locução prepositiva usada para introduzir exemplos específicos de uma categoria ampla. Equivale a 'for example' ou 'including'.",
            notes: "Pode ser dividida em construções como 'such frameworks as Scrum', embora 'frameworks such as Scrum' seja mais frequente.",
            examples: ["I enjoy outdoor activities, such as hiking and cycling.", "We use agile tools, such as Jira and Confluence.", "Many programming languages, such as Python and JavaScript, are popular today.", "When we manage projects, it’s necessary to use some frameworks such as Scrum and SAFe.", "People are afraid of dealing with wild animals such as Tigers, Lions and Snakes. Although they are wild, you can raise one of them in your own home... It's a joke!"]
        ),
        Connector(
            id: "summing-up",
            number: 65,
            connector: "Summing up",
            translation: "Resumindo / Em suma",
            family: .summary,
            grammarRule: "Locução participial que introduz a síntese de ideias debatidas anteriormente.",
            notes: "Excelente para fechamentos de reuniões de alinhamento com clientes.",
            examples: ["Summing up, the team has successfully resolved all high-priority blockers for this sprint.", "Summing up our architectural review, migrating to GraphQL will solve client-side over-fetching."]
        ),
        Connector(
            id: "thats-why",
            number: 66,
            connector: "That's why",
            translation: "Por isso / É por isso que",
            family: .cause,
            grammarRule: "Conector de causa e explicação que liga um fato anterior ao seu efeito direto. Equivale a 'that is the reason why'.",
            notes: "Muito coloquial e natural na fala diária e reuniões técnicas.",
            examples: ["I was tired. That's why I went to bed early.", "Yesterday was a bad day, Grêmio lost the match. That’s why I drank a lot.", "You didn’t fix the table on MongoDB. That's why the problem wasn’t solved.", "Our automated tests caught the breaking change early; that's why nothing broke in production."]
        ),
        Connector(
            id: "then",
            number: 67,
            connector: "Then",
            translation: "Então / Em seguida / Assim",
            family: .time,
            grammarRule: "Advérbio que estabelece sequência cronológica ou consequência lógica de passos encadeados.",
            notes: "Padrão clássico: 'First..., Then...'. Indispensável para documentar pipelines e fluxos de usuário.",
            examples: ["First, I reviewed the requirements. Then, I started development.", "We held the Sprint Planning meeting. Then, the team began working on the user stories.", "I was talking to my colleague and then you called me.", "First run the database migrations; then restart the application server pods."]
        ),
        Connector(
            id: "therefore",
            number: 68,
            connector: "Therefore",
            translation: "Portanto / Por esta razão",
            family: .cause,
            grammarRule: "Advérbio conjuntivo formal que expressa uma dedução lógica irrefutável ou resultado formal.",
            notes: "Muito empregado em atas de reuniões corporativas e decisões de design arquitetural.",
            examples: ["The client requested new scope; therefore, the sprint deadline was renegotiated.", "Automated test coverage is under 30%; therefore, we cannot approve production deployment yet."]
        ),
        Connector(
            id: "though",
            number: 69,
            connector: "Though",
            translation: "Embora / No entanto (comum no final da frase)",
            family: .contrast,
            grammarRule: "No início de frase equivale a 'although'. No inglês falado natural, é muito frequentemente colocado NO FINAL da frase com sentido de 'however / but'.",
            notes: "A posição final é extremamente comum no dia a dia: 'It was tough. I did it, though'.",
            examples: ["Though it was raining, we went for a walk.", "The meeting was long. It was productive, though.", "I don't usually drink coffee. I had one this morning, though.", "It was a very tough day. I did everything that I needed to, though.", "When I go to my friend Samuel Eto'o, I’ll tell him what you said. I don’t like to go there, though.", "Next Sunday Grêmio will play with Palmeiras. We're gonna win, though.", "I didn’t like this house. I liked the garden, though."]
        ),
        Connector(
            id: "thus",
            number: 70,
            connector: "Thus",
            translation: "Dessa forma / Desta maneira / Portanto",
            family: .cause,
            grammarRule: "Advérbio formal de causa e consequência. Muito comum na redação de relatórios técnicos e documentos acadêmicos.",
            notes: "Pode ser seguido de oração completa ou de gerúndio ('thus reducing...').",
            examples: ["The system was upgraded. Thus, performance improved.", "The squad increased automation coverage. Thus, manual effort was reduced.", "The team improved backlog refinement, thus reducing the number of blocked stories.", "We introduced edge caching, thus decreasing round-trip latency for global users."]
        ),
        Connector(
            id: "to-sum-up",
            number: 71,
            connector: "To sum up",
            translation: "Para resumir / Em resumo / Em suma",
            family: .summary,
            grammarRule: "Locução conectiva no infinitivo usada para recapitular os pontos centrais de uma argumentação.",
            notes: "Usada no início da oração final, seguida de vírgula.",
            examples: ["To sum up, we need to reduce our cloud infrastructure costs.", "To sum up, the project was successful despite the difficulties.", "To sum up, there are three main reasons for this architectural decision.", "To sum up, I think we need more time to finish the project.", "To sum up, after all that you said, you finished the deployment in production."]
        ),
        Connector(
            id: "towards",
            number: 72,
            connector: "Towards",
            translation: "Em direção a / Rumo a",
            family: .purpose,
            grammarRule: "Preposição de movimento, direção física ou progresso orientado a um objetivo.",
            notes: "Muito comum no inglês britânico ('towards'); em inglês americano usa-se frequentemente 'toward' sem o 's'.",
            examples: ["He walked towards the door.", "She was driving towards London.", "We arrived towards the end of the meeting.", "We are working towards our quarterly sprint goal.", "Let’s build a new software toward the next generation of clients."]
        ),
        Connector(
            id: "unless",
            number: 73,
            connector: "Unless",
            translation: "A menos que / A não ser que",
            family: .condition,
            grammarRule: "Conjunção condicional negativa equivalente a 'IF NOT'. Nunca use negação dupla dentro da oração com unless.",
            notes: "Regra de ouro: 'Unless you study' = 'If you do not study'.",
            examples: ["Unless you study, you won't pass the exam.", "Unless you hurry, you'll miss the bus.", "You can't enter unless you have a ticket.", "Do not merge code into the master branch unless all CI automated pipeline checks pass."]
        ),
        Connector(
            id: "unlike",
            number: 74,
            connector: "Unlike",
            translation: "Diferentemente de / Ao contrário de",
            family: .contrast,
            grammarRule: "Preposição que expressa distinção ou contraste entre duas entidades ('UNLIKE = different from'). Seguido de substantivo ou pronome.",
            notes: "Excelente para contrastar empregos anteriores, paradigmas de linguagens ou arquiteturas.",
            examples: ["Unlike my brother, I enjoy cooking.", "Unlike other cars, this one is very economical.", "Unlike my father, I don't like working on weekends.", "Unlike John, Mary likes coffee.", "Unlike most people, I prefer working at night.", "Unlike my previous job, my current job is fully remote.", "Unlike relational SQL databases, MongoDB stores records as flexible JSON-like documents."]
        ),
        Connector(
            id: "whatever",
            number: 75,
            connector: "Whatever",
            translation: "O que quer que seja / Qualquer coisa que / Tanto faz",
            family: .emphasis,
            grammarRule: "Pronome ou determinante relativo indefinido que expressa ausência de restrição para coisas, ações ou eventos ('anything that' / 'no matter what').",
            notes: "Membro da Família -Ever ('These are worth learning together: Whatever, Whenever, Wherever, Whoever, However'). Foco: Coisas e ações. Em respostas curtas informais denota 'tanto faz'.",
            examples: ["Choose whatever tools you need to build the microservice.", "Whatever happens during the demo, keep calm and explain the architectural reasoning.", "A: Which cloud provider do you prefer? B: — Whatever the client selects.", "Take whatever time you need to review the pull request.", "Deploy whatever version has been approved by QA."]
        ),
        Connector(
            id: "whenever",
            number: 76,
            connector: "Whenever",
            translation: "Quando quer que seja / Sempre que",
            family: .time,
            grammarRule: "Conjunção temporal que indica repetição contínua ('every time that') ou qualquer momento temporal arbitrário ('at any time').",
            notes: "Membro da Família -Ever ('These are worth learning together: Whatever, Whenever, Wherever, Whoever, However'). Foco: Tempo e ocasiões. Muito comum em webhooks e automação de CI/CD.",
            examples: ["Whenever the continuous integration pipeline fails, an alert is sent to Slack.", "Whenever I drink coffee late at night, I can't sleep.", "Call me whenever you need help with the agile ceremonies.", "Whenever new commits are pushed to main, automated tests run in the background.", "You can trigger the deploy whenever you are ready."]
        ),
        Connector(
            id: "whereas",
            number: 77,
            connector: "Whereas",
            translation: "Ao passo que / Enquanto que",
            family: .contrast,
            grammarRule: "Conjunção subordinativa formal que contrapõe dois fatos, métodos ou características simultâneas na mesma oração.",
            notes: "Essencial no estudo comparativo com Wherever e However ('These are worth learning together'). CUIDADO: Começa com 'Where-', mas NÃO expressa lugar! É 100% focado em contraste analítico direto entre duas ideias, métodos ou tecnologias ('ao passo que / enquanto que').",
            examples: ["Scrum focuses on short timeboxed iterations, whereas Kanban emphasizes continuous workflow.", "Relational databases guarantee ACID transactions, whereas NoSQL document stores offer flexible horizontal scaling.", "Monolithic architectures simplify initial deployment, whereas microservices provide independent scaling and squad autonomy.", "Junior developers often focus on coding speed, whereas senior engineers prioritize clean architecture, testability, and maintainability.", "Synchronous REST calls block until a response arrives, whereas asynchronous message queues process events decoupled in the background.", "John likes working from home, whereas Mary prefers working in the office."]
        ),
        Connector(
            id: "wherever",
            number: 78,
            connector: "Wherever",
            translation: "Onde quer que seja / Onde quer que / Em qualquer lugar",
            family: .emphasis,
            grammarRule: "Conjunção ou advérbio que denota ausência total de restrição espacial ou geográfica ('in or to any place').",
            notes: "Membro da Família -Ever ('These are worth learning together: Whatever, Whenever, Wherever, Whoever, However'). Foco: Lugares e localização. Ideal para trabalho remoto e cloud.",
            examples: ["With a cloud workstation, you can code securely from wherever you are in the world.", "Wherever there is a performance bottleneck in our microservices, we implement Redis caching.", "You can deploy the container wherever the latency is lowest.", "Wherever you go in this clean architecture codebase, dependencies point inwards to domain entities.", "Our database replicas ensure data is accessible wherever users connect."]
        ),
        Connector(
            id: "whether",
            number: 79,
            connector: "Whether",
            translation: "Se (duas opções ou mais alternativas)",
            family: .condition,
            grammarRule: "Conjunção usada para introduzir alternativas explícitas ou dúvidas entre duas ou mais possibilidades ('whether X or Y').",
            notes: "Regra clássica: use 'whether' (e não 'if') após preposições, antes de infinitivos com 'to', ou com 'or not' explícito.",
            examples: ["I don't know whether he'll come or not.", "We need to decide whether to stay or leave.", "I don't know whether to stay or leave.", "I don't know whether to go.", "She can't decide whether to accept the offer.", "The engineering squad must decide whether to refactor the legacy codebase or rebuild it using Go microservices."]
        ),
        Connector(
            id: "while",
            number: 80,
            connector: "While",
            translation: "Enquanto (tempo) / Embora (contraste)",
            family: .time,
            grammarRule: "Conector versátil com 3 usos: 1) Ações simultâneas de mesma duração; 2) 'Durante o tempo em que'; 3) Concessão/contraste ('embora').",
            notes: "Quando usado no sentido temporal, requer tempos contínuos (Past/Present Continuous).",
            examples: ["I was studying while my son was watching TV.", "I listen to podcasts while I'm working.", "I like coffee, while my brother prefers tea.", "I was cooking while my wife was watching TV.", "I prefer working remotely, while my colleague prefers the office.", "While I understand your point, I disagree.", "While the project was successful, it was very expensive.", "I fell asleep while I was watching TV.", "While the QA team tested the API endpoints, developers fixed the CSS styling bugs."]
        ),
        Connector(
            id: "yet",
            number: 81,
            connector: "Yet",
            translation: "Ainda (tempo) / Contudo / No entanto (contraste)",
            family: .contrast,
            grammarRule: "Dois usos cruciais: 1) Advérbio temporal no fim de frases negativas/interrogativas com Present Perfect ('ainda/já'); 2) Conjunção adversativa ('mas/contudo').",
            notes: "Como conector adversativo (FANBOYS), une orações com elegância: 'simple, yet powerful'.",
            examples: ["I haven't finished yet.", "She hasn't arrived yet.", "Have you finished yet?", "I haven't eaten yet.", "He is very young, yet he is extremely experienced.", "The task was difficult, yet we managed to finish it.", "The microservice design was simple, yet resilient to high database spikes."]
        ),
    ]
}

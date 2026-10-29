//
//  PhrasalVerbsQuestionsData.swift
//  English along with John - Data / PhrasalVerbs
//

import Foundation

public struct QuestionOption: Identifiable, Sendable, Equatable, Hashable {
    public let id: String
    public let text: String

    public init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}

public struct PhrasalVerbQuizQuestion: Identifiable, Sendable, Equatable {
    public let id: String
    public let prompt: String
    public let options: [QuestionOption]
    public let correctOptionId: String
    public let phrasalVerb: String
    public let level: PhrasalVerbLevel
    public let meaningEn: String
    public let meaningPt: String
    public let fullSentence: String
    public let sentenceTranslation: String
    public let whyCorrect: String
    public let teacherTip: String

    public init(
        id: String,
        prompt: String,
        options: [QuestionOption],
        correctOptionId: String,
        phrasalVerb: String,
        level: PhrasalVerbLevel,
        meaningEn: String,
        meaningPt: String,
        fullSentence: String,
        sentenceTranslation: String,
        whyCorrect: String,
        teacherTip: String = ""
    ) {
        self.id = id
        self.prompt = prompt
        self.options = options
        self.correctOptionId = correctOptionId
        self.phrasalVerb = phrasalVerb
        self.level = level
        self.meaningEn = meaningEn
        self.meaningPt = meaningPt
        self.fullSentence = fullSentence
        self.sentenceTranslation = sentenceTranslation
        self.whyCorrect = whyCorrect
        self.teacherTip = teacherTip
    }
}

public enum PhrasalVerbsQuestionsData {
    public static let questions: [PhrasalVerbQuizQuestion] = [
        PhrasalVerbQuizQuestion(
            id: "pv-q1",
            prompt: "He went to the shop and _____ with fresh bread.",
            options: [QuestionOption(id: "opt-1", text: "came back"), QuestionOption(id: "opt-2", text: "got off"), QuestionOption(id: "opt-3", text: "turned down"), QuestionOption(id: "opt-4", text: "woke up")],
            correctOptionId: "opt-1",
            phrasalVerb: "come back",
            level: .a1,
            meaningEn: "Return to the place you were before.",
            meaningPt: "Voltar / retornar ao lugar onde você estava antes.",
            fullSentence: "He went to the shop and came back with fresh bread.",
            sentenceTranslation: "Ele foi até a padaria e voltou com pão fresco.",
            whyCorrect: "",
            teacherTip: "Como a frase está no passado ("
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q2",
            prompt: "The teacher opened the door and said: 'Please, _____!'",
            options: [QuestionOption(id: "opt-1", text: "get out"), QuestionOption(id: "opt-2", text: "come in"), QuestionOption(id: "opt-3", text: "take off"), QuestionOption(id: "opt-4", text: "hang up")],
            correctOptionId: "opt-2",
            phrasalVerb: "come in",
            level: .a1,
            meaningEn: "When you enter a room or building.",
            meaningPt: "Entrar em uma sala ou edifício.",
            fullSentence: "The teacher opened the door and said: 'Please, come in!'",
            sentenceTranslation: "O professor abriu a porta e disse: 'Por favor, entre!'",
            whyCorrect: "",
            teacherTip: "Quem já está dentro da sala diz"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q3",
            prompt: "We were in a rush, so we _____ the taxi as fast as we could.",
            options: [QuestionOption(id: "opt-1", text: "got in"), QuestionOption(id: "opt-2", text: "got on"), QuestionOption(id: "opt-3", text: "put on"), QuestionOption(id: "opt-4", text: "turned off")],
            correctOptionId: "opt-1",
            phrasalVerb: "get in",
            level: .a1,
            meaningEn: "When you enter a car or taxi.",
            meaningPt: "Entrar no carro ou táxi.",
            fullSentence: "We were in a rush, so we got in the taxi as fast as we could.",
            sentenceTranslation: "Estávamos com pressa, então entramos no táxi o mais rápido possível.",
            whyCorrect: "Para carros e táxis (veículos baixos), a preposição correta é",
            teacherTip: "Nunca use"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q4",
            prompt: "Many passengers _____ the bus at the central terminal.",
            options: [QuestionOption(id: "opt-1", text: "got on"), QuestionOption(id: "opt-2", text: "got in"), QuestionOption(id: "opt-3", text: "broke up"), QuestionOption(id: "opt-4", text: "took out")],
            correctOptionId: "opt-1",
            phrasalVerb: "get on",
            level: .a1,
            meaningEn: "When you enter a bus, train or plane.",
            meaningPt: "Embarcar / subir em ônibus, trem ou avião.",
            fullSentence: "Many passengers got on the bus at the central terminal.",
            sentenceTranslation: "Muitos passageiros subiram no ônibus no terminal central.",
            whyCorrect: "Ônibus, trens e aviões são veículos onde se fica de pé, logo usamos",
            teacherTip: "Regra mnemônica: se tem corredor para caminhar de pé, use"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q5",
            prompt: "We arrived at our destination and _____ the bus at the station.",
            options: [QuestionOption(id: "opt-1", text: "got off"), QuestionOption(id: "opt-2", text: "got out"), QuestionOption(id: "opt-3", text: "stood up"), QuestionOption(id: "opt-4", text: "put away")],
            correctOptionId: "opt-1",
            phrasalVerb: "get off",
            level: .a1,
            meaningEn: "Leave a bus, train or plane.",
            meaningPt: "Desembarcar de ônibus, trem ou avião.",
            fullSentence: "We arrived at our destination and got off the bus at the station.",
            sentenceTranslation: "Chegamos ao nosso destino e descemos do ônibus na estação.",
            whyCorrect: "",
            teacherTip: "Para táxi/carro seria"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q6",
            prompt: "I _____ at 6 a.m. when the sun rises, but I only leave the bed later.",
            options: [QuestionOption(id: "opt-1", text: "wake up"), QuestionOption(id: "opt-2", text: "give up"), QuestionOption(id: "opt-3", text: "look after"), QuestionOption(id: "opt-4", text: "come up with")],
            correctOptionId: "opt-1",
            phrasalVerb: "wake up",
            level: .a1,
            meaningEn: "Stop sleeping and regain consciousness.",
            meaningPt: "Acordar, abrir os olhos.",
            fullSentence: "I wake up at 6 a.m. when the sun rises, but I only leave the bed later.",
            sentenceTranslation: "Eu acordo às 6 da manhã quando o sol nasce, mas só saio da cama mais tarde.",
            whyCorrect: "",
            teacherTip: "Wake up = abrir os olhos; Get up = levantar fisicamente da cama."
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q7",
            prompt: "_____ or we will miss the train! There are only 3 minutes left.",
            options: [QuestionOption(id: "opt-1", text: "Hurry up"), QuestionOption(id: "opt-2", text: "Sit down"), QuestionOption(id: "opt-3", text: "Turn off"), QuestionOption(id: "opt-4", text: "Break down")],
            correctOptionId: "opt-1",
            phrasalVerb: "hurry up",
            level: .a1,
            meaningEn: "Go faster because there is not much time.",
            meaningPt: "Apressar-se / andar rápido.",
            fullSentence: "Hurry up or we will miss the train! There are only 3 minutes left.",
            sentenceTranslation: "Apresse-se ou vamos perder o trem! Faltam apenas 3 minutos.",
            whyCorrect: "",
            teacherTip: "Expressão imperativa comum no dia a dia."
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q8",
            prompt: "It's freezing outside, make sure to _____ your warm coat and boots.",
            options: [QuestionOption(id: "opt-1", text: "put on"), QuestionOption(id: "opt-2", text: "take off"), QuestionOption(id: "opt-3", text: "turn on"), QuestionOption(id: "opt-4", text: "give back")],
            correctOptionId: "opt-1",
            phrasalVerb: "put on",
            level: .a2,
            meaningEn: "Put clothes or shoes on your body.",
            meaningPt: "Vestir ou calçar algo.",
            fullSentence: "It's freezing outside, make sure to put on your warm coat and boots.",
            sentenceTranslation: "Está congelando lá fora, certifique-se de vestir seu casaco quente e botas.",
            whyCorrect: "",
            teacherTip: "Oposto:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q9",
            prompt: "The room was warm, so he _____ his heavy leather jacket.",
            options: [QuestionOption(id: "opt-1", text: "took off"), QuestionOption(id: "opt-2", text: "put on"), QuestionOption(id: "opt-3", text: "got along"), QuestionOption(id: "opt-4", text: "handed in")],
            correctOptionId: "opt-1",
            phrasalVerb: "take off",
            level: .a2,
            meaningEn: "Remove clothes or items from your body.",
            meaningPt: "Tirar uma peça de roupa.",
            fullSentence: "The room was warm, so he took off his heavy leather jacket.",
            sentenceTranslation: "A sala estava quente, então ele tirou sua jaqueta de couro pesada.",
            whyCorrect: "",
            teacherTip: ""
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q10",
            prompt: "My car suddenly _____ in the middle of the highway, and I had to call a mechanic.",
            options: [QuestionOption(id: "opt-1", text: "broke down"), QuestionOption(id: "opt-2", text: "broke up"), QuestionOption(id: "opt-3", text: "passed on"), QuestionOption(id: "opt-4", text: "hung up")],
            correctOptionId: "opt-1",
            phrasalVerb: "break down",
            level: .a2,
            meaningEn: "Stop working unexpectedly (car or machine).",
            meaningPt: "Quebrar / enguiçar (veículo ou máquina).",
            fullSentence: "My car suddenly broke down in the middle of the highway, and I had to call a mechanic.",
            sentenceTranslation: "Meu carro enguiçou de repente no meio da rodovia e tive que chamar um mecânico.",
            whyCorrect: "",
            teacherTip: "Não confunda:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q11",
            prompt: "After 5 years of dating, Sally and Tom decided to _____ last week.",
            options: [QuestionOption(id: "opt-1", text: "break up"), QuestionOption(id: "opt-2", text: "break down"), QuestionOption(id: "opt-3", text: "turn up"), QuestionOption(id: "opt-4", text: "carry on")],
            correctOptionId: "opt-1",
            phrasalVerb: "break up",
            level: .a2,
            meaningEn: "End a romantic relationship or marriage.",
            meaningPt: "Terminar um relacionamento amoroso.",
            fullSentence: "After 5 years of dating, Sally and Tom decided to break up last week.",
            sentenceTranslation: "Depois de 5 anos de namoro, Sally e Tom decidiram terminar na semana passada.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q12",
            prompt: "My cousin and I _____ really well; we talk every day and never fight.",
            options: [QuestionOption(id: "opt-1", text: "get along"), QuestionOption(id: "opt-2", text: "give up"), QuestionOption(id: "opt-3", text: "hold up"), QuestionOption(id: "opt-4", text: "put away")],
            correctOptionId: "opt-1",
            phrasalVerb: "get along",
            level: .a2,
            meaningEn: "Have a friendly relationship with someone.",
            meaningPt: "Dar-se bem com alguém.",
            fullSentence: "My cousin and I get along really well; we talk every day and never fight.",
            sentenceTranslation: "Meu primo e eu nos damos muito bem; conversamos todo dia e nunca brigamos.",
            whyCorrect: "",
            teacherTip: "Também pode vir acompanhado de"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q13",
            prompt: "I'm trying to _____ eating sweets because my doctor told me to stay healthy.",
            options: [QuestionOption(id: "opt-1", text: "give up"), QuestionOption(id: "opt-2", text: "give back"), QuestionOption(id: "opt-3", text: "grow up"), QuestionOption(id: "opt-4", text: "look out")],
            correctOptionId: "opt-1",
            phrasalVerb: "give up",
            level: .a2,
            meaningEn: "Stop doing or having something completely.",
            meaningPt: "Abandonar um hábito ou desistir.",
            fullSentence: "I'm trying to give up eating sweets because my doctor told me to stay healthy.",
            sentenceTranslation: "Estou tentando parar de comer doces porque meu médico me recomendou manter a saúde.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q14",
            prompt: "Could you _____ my pet cat while I travel for the business conference?",
            options: [QuestionOption(id: "opt-1", text: "look after"), QuestionOption(id: "opt-2", text: "look for"), QuestionOption(id: "opt-3", text: "look up"), QuestionOption(id: "opt-4", text: "look forward to")],
            correctOptionId: "opt-1",
            phrasalVerb: "look after",
            level: .a2,
            meaningEn: "Take care of someone or something.",
            meaningPt: "Cuidar de alguém ou de um animal.",
            fullSentence: "Could you look after my pet cat while I travel for the business conference?",
            sentenceTranslation: "Você poderia cuidar do meu gato enquanto viajo para a conferência de negócios?",
            whyCorrect: "",
            teacherTip: "Não confunda com"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q15",
            prompt: "We have _____ of milk! Could you go to the corner grocery store to buy some?",
            options: [QuestionOption(id: "opt-1", text: "run out"), QuestionOption(id: "opt-2", text: "picked up"), QuestionOption(id: "opt-3", text: "turned down"), QuestionOption(id: "opt-4", text: "stood for")],
            correctOptionId: "opt-1",
            phrasalVerb: "run out",
            level: .a2,
            meaningEn: "Use up a resource completely so there is none left.",
            meaningPt: "Esgotar / ficar sem suprimento.",
            fullSentence: "We have run out of milk! Could you go to the corner grocery store to buy some?",
            sentenceTranslation: "Ficamos sem leite! Você poderia ir à mercearia da esquina comprar um pouco?",
            whyCorrect: "",
            teacherTip: ""
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q16",
            prompt: "The music stopped, the lights turned on, and the party _____.",
            options: [QuestionOption(id: "opt-1", text: "was over"), QuestionOption(id: "opt-2", text: "broke in"), QuestionOption(id: "opt-3", text: "put on"), QuestionOption(id: "opt-4", text: "called for")],
            correctOptionId: "opt-1",
            phrasalVerb: "be over",
            level: .b1,
            meaningEn: "Be finished or completed.",
            meaningPt: "Estar terminado / ter acabado.",
            fullSentence: "The music stopped, the lights turned on, and the party was over.",
            sentenceTranslation: "A música parou, as luzes acenderam e a festa tinha acabado.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q17",
            prompt: "Masked thieves _____ the store at midnight and stole all the laptops.",
            options: [QuestionOption(id: "opt-1", text: "broke in"), QuestionOption(id: "opt-2", text: "broke down"), QuestionOption(id: "opt-3", text: "carried out"), QuestionOption(id: "opt-4", text: "checked out")],
            correctOptionId: "opt-1",
            phrasalVerb: "break in",
            level: .b1,
            meaningEn: "Enter a building illegally by force to steal.",
            meaningPt: "Arrombar / invadir ilegalmente para roubar.",
            fullSentence: "Masked thieves broke in the store at midnight and stole all the laptops.",
            sentenceTranslation: "Ladrões mascarados arrombaram a loja à meia-noite e roubaram todos os notebooks.",
            whyCorrect: "",
            teacherTip: "Diferencie:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q18",
            prompt: "When her husband passed away, she had to _____ her children alone.",
            options: [QuestionOption(id: "opt-1", text: "bring up"), QuestionOption(id: "opt-2", text: "give in"), QuestionOption(id: "opt-3", text: "hand out"), QuestionOption(id: "opt-4", text: "hold up")],
            correctOptionId: "opt-1",
            phrasalVerb: "bring up",
            level: .b1,
            meaningEn: "Raise and care for a child until adult.",
            meaningPt: "Criar e educar uma criança até a idade adulta.",
            fullSentence: "When her husband passed away, she had to bring up her children alone.",
            sentenceTranslation: "Quando o marido faleceu, ela teve que criar seus filhos sozinha.",
            whyCorrect: "",
            teacherTip: "Outro sentido comum de"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q19",
            prompt: "The police detectives are _____ an intensive investigation to find the suspect.",
            options: [QuestionOption(id: "opt-1", text: "carrying out"), QuestionOption(id: "opt-2", text: "giving way"), QuestionOption(id: "opt-3", text: "getting rid of"), QuestionOption(id: "opt-4", text: "looking up")],
            correctOptionId: "opt-1",
            phrasalVerb: "carry out",
            level: .b1,
            meaningEn: "Execute or conduct a task or plan.",
            meaningPt: "Executar, realizar ou conduzir uma tarefa/investigação.",
            fullSentence: "The police detectives are carrying out an intensive investigation to find the suspect.",
            sentenceTranslation: "Os detetives da polícia estão realizando uma investigação intensiva para encontrar o suspeito.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q20",
            prompt: "Customer service agents have to _____ dozens of frustrated clients every morning.",
            options: [QuestionOption(id: "opt-1", text: "deal with"), QuestionOption(id: "opt-2", text: "cross out"), QuestionOption(id: "opt-3", text: "cut up"), QuestionOption(id: "opt-4", text: "end up")],
            correctOptionId: "opt-1",
            phrasalVerb: "deal with",
            level: .b1,
            meaningEn: "Give attention to solve problems or handle people as part of work.",
            meaningPt: "Lidar com, atender e resolver problemas.",
            fullSentence: "Customer service agents have to deal with dozens of frustrated clients every morning.",
            sentenceTranslation: "Atendentes de suporte precisam lidar com dezenas de clientes frustrados toda manhã.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q21",
            prompt: "Please _____ your contact information in the highlighted blank fields.",
            options: [QuestionOption(id: "opt-1", text: "fill in"), QuestionOption(id: "opt-2", text: "fill up"), QuestionOption(id: "opt-3", text: "give out"), QuestionOption(id: "opt-4", text: "knock down")],
            correctOptionId: "opt-1",
            phrasalVerb: "fill in",
            level: .b1,
            meaningEn: "Add information in the spaces/details of a document.",
            meaningPt: "Preencher lacunas ou campos específicos de um documento.",
            fullSentence: "Please fill in your contact information in the highlighted blank fields.",
            sentenceTranslation: "Por favor, preencha suas informações de contato nos campos em branco destacados.",
            whyCorrect: "",
            teacherTip: "🧠 Dica do Professor:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q22",
            prompt: "Before we hit the highway, let's stop by the gas station and _____ the car.",
            options: [QuestionOption(id: "opt-1", text: "fill up"), QuestionOption(id: "opt-2", text: "fill in"), QuestionOption(id: "opt-3", text: "pass on"), QuestionOption(id: "opt-4", text: "keep in")],
            correctOptionId: "opt-1",
            phrasalVerb: "fill up",
            level: .b1,
            meaningEn: "Make a container or car tank completely full.",
            meaningPt: "Encher até o topo (tanque de combustível).",
            fullSentence: "Before we hit the highway, let's stop by the gas station and fill up the car.",
            sentenceTranslation: "Antes de pegarmos a rodovia, vamos parar no posto de gasolina e abastecer o carro.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q23",
            prompt: "The committee decided to _____ the final vote until next Tuesday.",
            options: [QuestionOption(id: "opt-1", text: "put off"), QuestionOption(id: "opt-2", text: "put down"), QuestionOption(id: "opt-3", text: "put away"), QuestionOption(id: "opt-4", text: "hand in")],
            correctOptionId: "opt-1",
            phrasalVerb: "put off",
            level: .b1,
            meaningEn: "Postpone or arrange for a later time.",
            meaningPt: "Adiar para uma data futura.",
            fullSentence: "The committee decided to put off the final vote until next Tuesday.",
            sentenceTranslation: "O comitê decidiu adiar a votação final para a próxima terça-feira.",
            whyCorrect: "",
            teacherTip: "Sinônimo formal:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q24",
            prompt: "I am really _____ seeing my old high school friends at the reunion this weekend!",
            options: [QuestionOption(id: "opt-1", text: "looking forward to"), QuestionOption(id: "opt-2", text: "looking out for"), QuestionOption(id: "opt-3", text: "giving in to"), QuestionOption(id: "opt-4", text: "hanging up on")],
            correctOptionId: "opt-1",
            phrasalVerb: "look forward to",
            level: .b1,
            meaningEn: "Feel excited and happy about something that is about to happen.",
            meaningPt: "Aguardar ansiosamente por algo bom.",
            fullSentence: "I am really looking forward to seeing my old high school friends at the reunion this weekend!",
            sentenceTranslation: "Estou realmente ansioso para rever meus velhos amigos de escola no reencontro deste fim de semana!",
            whyCorrect: "",
            teacherTip: "Lembre-se que o verbo após"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q25",
            prompt: "Nobody invited him, but he suddenly _____ at the front door with a backpack.",
            options: [QuestionOption(id: "opt-1", text: "turned up"), QuestionOption(id: "opt-2", text: "turned down"), QuestionOption(id: "opt-3", text: "called off"), QuestionOption(id: "opt-4", text: "got over")],
            correctOptionId: "opt-1",
            phrasalVerb: "turn up",
            level: .b2,
            meaningEn: "Arrive or appear unexpectedly.",
            meaningPt: "Aparecer / chegar de surpresa.",
            fullSentence: "Nobody invited him, but he suddenly turned up at the front door with a backpack.",
            sentenceTranslation: "Ninguém o convidou, mas ele apareceu de repente na porta da frente com uma mochila.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q26",
            prompt: "The tech giant made him a job offer, but he _____ because the salary was too low.",
            options: [QuestionOption(id: "opt-1", text: "turned it down"), QuestionOption(id: "opt-2", text: "turned it up"), QuestionOption(id: "opt-3", text: "went through it"), QuestionOption(id: "opt-4", text: "called it up")],
            correctOptionId: "opt-1",
            phrasalVerb: "turn down",
            level: .b2,
            meaningEn: "Refuse, decline or reject an offer.",
            meaningPt: "Recusar / rejeitar uma oferta de emprego ou convite.",
            fullSentence: "The tech giant made him a job offer, but he turned it down because the salary was too low.",
            sentenceTranslation: "A gigante de tecnologia fez uma oferta de trabalho, mas ele recusou porque o salário era muito baixo.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q27",
            prompt: "Due to the severe thunderstorm, the organizers had to _____ the music festival.",
            options: [QuestionOption(id: "opt-1", text: "call off"), QuestionOption(id: "opt-2", text: "put up with"), QuestionOption(id: "opt-3", text: "run into"), QuestionOption(id: "opt-4", text: "come up with")],
            correctOptionId: "opt-1",
            phrasalVerb: "call off",
            level: .b2,
            meaningEn: "Cancel an event or planned arrangement.",
            meaningPt: "Cancelar definitivamente um evento planejado.",
            fullSentence: "Due to the severe thunderstorm, the organizers had to call off the music festival.",
            sentenceTranslation: "Devido à forte tempestade, os organizadores tiveram que cancelar o festival de música.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q28",
            prompt: "Before the big client pitch tomorrow, let's _____ the presentation slides one more time.",
            options: [QuestionOption(id: "opt-1", text: "go over"), QuestionOption(id: "opt-2", text: "get over"), QuestionOption(id: "opt-3", text: "drop by"), QuestionOption(id: "opt-4", text: "set off")],
            correctOptionId: "opt-1",
            phrasalVerb: "go over",
            level: .b2,
            meaningEn: "Review or examine something carefully.",
            meaningPt: "Revisar, repassar detalhadamente.",
            fullSentence: "Before the big client pitch tomorrow, let's go over the presentation slides one more time.",
            sentenceTranslation: "Antes do grande pitch com o cliente amanhã, vamos revisar os slides da apresentação mais uma vez.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q29",
            prompt: "While buying groceries at the supermarket yesterday, I _____ my high school teacher.",
            options: [QuestionOption(id: "opt-1", text: "ran into"), QuestionOption(id: "opt-2", text: "threw away"), QuestionOption(id: "opt-3", text: "looked after"), QuestionOption(id: "opt-4", text: "shut up")],
            correctOptionId: "opt-1",
            phrasalVerb: "run into",
            level: .b2,
            meaningEn: "Meet someone unexpectedly by chance.",
            meaningPt: "Encontrar por acaso, esbarrar com alguém.",
            fullSentence: "While buying groceries at the supermarket yesterday, I ran into my high school teacher.",
            sentenceTranslation: "Enquanto fazia compras no supermercado ontem, esbarrei por acaso com meu professor do ensino médio.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q30",
            prompt: "Our engineering team must _____ an innovative solution for this database bottleneck.",
            options: [QuestionOption(id: "opt-1", text: "come up with"), QuestionOption(id: "opt-2", text: "stand up for"), QuestionOption(id: "opt-3", text: "give away"), QuestionOption(id: "opt-4", text: "hold up")],
            correctOptionId: "opt-1",
            phrasalVerb: "come up with",
            level: .b2,
            meaningEn: "Think of, create or invent an idea or solution.",
            meaningPt: "Bolar, inventar ou propor uma ideia/solução.",
            fullSentence: "Our engineering team must come up with an innovative solution for this database bottleneck.",
            sentenceTranslation: "Nossa equipe de engenharia precisa bolar uma solução inovadora para este gargalo no banco de dados.",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q31",
            prompt: "What does the acronym 'NASA' _____ in the aerospace sector?",
            options: [QuestionOption(id: "opt-1", text: "stand for"), QuestionOption(id: "opt-2", text: "put up with"), QuestionOption(id: "opt-3", text: "call on"), QuestionOption(id: "opt-4", text: "go off")],
            correctOptionId: "opt-1",
            phrasalVerb: "stand for",
            level: .b2,
            meaningEn: "Represent words, letters, ideas or principles.",
            meaningPt: "Significar / representar (siglas ou valores).",
            fullSentence: "What does the acronym 'NASA' stand for in the aerospace sector?",
            sentenceTranslation: "O que a sigla 'NASA' significa no setor aeroespacial?",
            whyCorrect: "",
            teacherTip: "Exemplo dos documentos:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q32",
            prompt: "I can _____ a messy desk, but I cannot stand dishonesty.",
            options: [QuestionOption(id: "opt-1", text: "put up with"), QuestionOption(id: "opt-2", text: "put off"), QuestionOption(id: "opt-3", text: "take out"), QuestionOption(id: "opt-4", text: "bring back")],
            correctOptionId: "opt-1",
            phrasalVerb: "put up with",
            level: .b2,
            meaningEn: "Tolerate or endure something unpleasant without complaining.",
            meaningPt: "Aguentar, tolerar, suportar.",
            fullSentence: "I can put up with a messy desk, but I cannot stand dishonesty.",
            sentenceTranslation: "Eu consigo aguentar uma mesa bagunçada, mas não suporto desonestidade.",
            whyCorrect: "",
            teacherTip: "Destaque do professor na lousa:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q33",
            prompt: "To enroll in the foreign university program, applicants must _____ this 10-page official form.",
            options: [QuestionOption(id: "opt-1", text: "fill out"), QuestionOption(id: "opt-2", text: "fill in"), QuestionOption(id: "opt-3", text: "clean up"), QuestionOption(id: "opt-4", text: "drop by")],
            correctOptionId: "opt-1",
            phrasalVerb: "fill out",
            level: .b2,
            meaningEn: "Complete an entire document or application.",
            meaningPt: "Preencher um formulário por completo.",
            fullSentence: "To enroll in the foreign university program, applicants must fill out this 10-page official form.",
            sentenceTranslation: "Para se matricular no programa universitário exterior, os candidatos devem preencher este formulário oficial de 10 páginas.",
            whyCorrect: "",
            teacherTip: "🧠 Dica do Professor:"
        ),
        PhrasalVerbQuizQuestion(
            id: "pv-q34",
            prompt: "I was _____ to leave my apartment when my phone rang.",
            options: [QuestionOption(id: "opt-1", text: "about"), QuestionOption(id: "opt-2", text: "around"), QuestionOption(id: "opt-3", text: "up"), QuestionOption(id: "opt-4", text: "over")],
            correctOptionId: "opt-1",
            phrasalVerb: "be about to",
            level: .b2,
            meaningEn: "Be on the verge of doing something in a few seconds.",
            meaningPt: "Estar prestes a fazer algo.",
            fullSentence: "I was about to leave my apartment when my phone rang.",
            sentenceTranslation: "Eu estava prestes a sair do meu apartamento quando meu telefone tocou.",
            whyCorrect: "",
            teacherTip: "Destaque da lousa:"
        ),
    ]
}

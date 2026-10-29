import os
import re

base_path = r"C:\Projetos\Games\ConnectorsInEnglish\frontend\src\data"
pv_path = os.path.join(base_path, "phrasalVerbs.ts")
idm_path = os.path.join(base_path, "idiomaticExpressions.ts")

def extract_strings(raw):
    return [m[0] or m[1] for m in re.findall(r'"((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\'', raw)]

# 1. PARSE IDIOMATIC EXPRESSIONS
with open(idm_path, "r", encoding="utf-8") as f:
    idm_text = f.read()

idm_pattern = re.compile(
    r'id:\s*["\'](?P<id>[^"\']+)["\'],\s*'
    r'expression:\s*["\'](?P<expression>[^"\']+)["\'],\s*'
    r'definition:\s*["\'](?P<definition>[\s\S]*?)["\'],\s*'
    r'meaningPt:\s*["\'](?P<meaningPt>[^"\']+)["\'],\s*'
    r'example:\s*["\'](?P<example>[\s\S]*?)["\']'
)

idioms = []
for m in idm_pattern.finditer(idm_text):
    idioms.append({
        "id": m.group("id"),
        "expression": m.group("expression"),
        "definition": m.group("definition").strip().replace("\n", " "),
        "meaningPt": m.group("meaningPt"),
        "example": m.group("example").strip().replace("\n", " ")
    })

print(f"Parsed {len(idioms)} idiomatic expressions")

# 2. PARSE PHRASAL VERBS DATA
with open(pv_path, "r", encoding="utf-8") as f:
    pv_text = f.read()

data_part = pv_text[:pv_text.find("export const PHRASAL_VERBS_QUESTIONS")]
questions_part = pv_text[pv_text.find("export const PHRASAL_VERBS_QUESTIONS"):]

pv_item_pattern = re.compile(
    r'id:\s*["\'](?P<id>[^"\']+)["\'],\s*'
    r'verb:\s*["\'](?P<verb>[^"\']*)["\'],\s*'
    r'particle:\s*["\'](?P<particle>[^"\']*)["\'],\s*'
    r'phrasalVerb:\s*["\'](?P<phrasalVerb>[^"\']+)["\'],\s*'
    r'level:\s*["\'](?P<level>[^"\']+)["\'],\s*'
    r'meaningEn:\s*["\'](?P<meaningEn>[\s\S]*?)["\'],\s*'
    r'meaningPt:\s*["\'](?P<meaningPt>[\s\S]*?)["\'],\s*'
    r'category:\s*["\'](?P<category>[^"\']+)["\'],\s*'
    r'examples:\s*\[(?P<examples>[\s\S]*?)\],?'
)

pv_items = []
for m in pv_item_pattern.finditer(data_part):
    item_id = m.group("id")
    tip_match = re.search(r'id:\s*["\']' + re.escape(item_id) + r'[\s\S]*?teacherTip:\s*["\'](?P<tip>[\s\S]*?)["\']', data_part)
    tip = tip_match.group("tip").strip() if tip_match else ""
    
    raw_examples = m.group("examples")
    examples = extract_strings(raw_examples)
    
    pv_items.append({
        "id": item_id,
        "verb": m.group("verb"),
        "particle": m.group("particle"),
        "phrasalVerb": m.group("phrasalVerb"),
        "level": m.group("level"),
        "meaningEn": m.group("meaningEn").strip().replace("\n", " "),
        "meaningPt": m.group("meaningPt").strip().replace("\n", " "),
        "category": m.group("category"),
        "examples": examples,
        "teacherTip": tip
    })

print(f"Parsed {len(pv_items)} phrasal verbs data items")

# 3. PARSE PHRASAL VERBS QUESTIONS
q_pattern = re.compile(
    r'id:\s*["\'](?P<id>[^"\']+)["\'],\s*'
    r'prompt:\s*["\'](?P<prompt>[\s\S]*?)["\'],\s*'
    r'options:\s*\[(?P<options>[\s\S]*?)\],\s*'
    r'correctOptionId:\s*["\'](?P<correctOptionId>[^"\']+)["\'],\s*'
    r'phrasalVerb:\s*["\'](?P<phrasalVerb>[^"\']+)["\'],\s*'
    r'level:\s*["\'](?P<level>[^"\']+)["\'],\s*'
    r'meaningEn:\s*["\'](?P<meaningEn>[\s\S]*?)["\'],\s*'
    r'meaningPt:\s*["\'](?P<meaningPt>[\s\S]*?)["\'],\s*'
    r'fullSentence:\s*["\'](?P<fullSentence>[\s\S]*?)["\'],\s*'
    r'sentenceTranslation:\s*["\'](?P<sentenceTranslation>[\s\S]*?)["\'],\s*'
    r'whyCorrect:\s*["\'](?P<whyCorrect>[\s\S]*?)["\'],?'
)

pv_questions = []
for m in q_pattern.finditer(questions_part):
    q_id = m.group("id")
    tip_match = re.search(r'id:\s*["\']' + re.escape(q_id) + r'[\s\S]*?teacherTip:\s*["\'](?P<tip>[\s\S]*?)["\']', questions_part)
    tip = tip_match.group("tip").strip() if tip_match else ""
    
    raw_opts = m.group("options")
    opt_matches = re.findall(r'id:\s*["\'](?P<oid>[^"\']+)["\'],\s*text:\s*["\'](?P<otext>[^"\']+)["\']', raw_opts)
    options = [{"id": oid, "text": otext} for oid, otext in opt_matches]
    
    pv_questions.append({
        "id": q_id,
        "prompt": m.group("prompt").strip().replace("\n", " "),
        "options": options,
        "correctOptionId": m.group("correctOptionId"),
        "phrasalVerb": m.group("phrasalVerb"),
        "level": m.group("level"),
        "meaningEn": m.group("meaningEn").strip().replace("\n", " "),
        "meaningPt": m.group("meaningPt").strip().replace("\n", " "),
        "fullSentence": m.group("fullSentence").strip().replace("\n", " "),
        "sentenceTranslation": m.group("sentenceTranslation").strip().replace("\n", " "),
        "whyCorrect": m.group("whyCorrect").strip().replace("\n", " "),
        "teacherTip": tip
    })

print(f"Parsed {len(pv_questions)} phrasal verbs questions")

# 4. GENERATE SWIFT FILES
def escape_swift_str(s):
    if not s:
        return ""
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', ' ')

def level_enum(lvl):
    lvl = lvl.upper()
    if "A1" in lvl: return ".a1"
    if "A2" in lvl: return ".a2"
    if "B1" in lvl: return ".b1"
    if "B2" in lvl: return ".b2"
    if "C1" in lvl: return ".c1"
    return ".a1"

# 4.1 IdiomaticExpressionsData.swift
idm_swift = """//
//  IdiomaticExpressionsData.swift
//  English along with John - Data / IdiomaticExpressions
//

import Foundation

public enum IdiomaticExpressionsData {
    public static let expressions: [IdiomaticExpression] = [
"""
for item in idioms:
    idm_swift += f"""        IdiomaticExpression(
            id: "{item['id']}",
            expression: "{escape_swift_str(item['expression'])}",
            meaningPt: "{escape_swift_str(item['meaningPt'])}",
            literalMeaningPt: nil,
            exampleEn: "{escape_swift_str(item['example'])}",
            examplePt: "{escape_swift_str(item['meaningPt'])}",
            culturalNote: "{escape_swift_str(item['definition'])}"
        ),
"""
idm_swift += """    ]
}
"""

with open(r"Sources\Data\IdiomaticExpressions\IdiomaticExpressionsData.swift", "w", encoding="utf-8") as f:
    f.write(idm_swift)
print("Written Sources/Data/IdiomaticExpressions/IdiomaticExpressionsData.swift")

# 4.2 PhrasalVerbsCatalogData.swift
pv_catalog_swift = """//
//  PhrasalVerbsCatalogData.swift
//  English along with John - Data / PhrasalVerbs
//

import Foundation

public struct PhrasalVerbCatalogItem: Identifiable, Sendable, Equatable {
    public let id: String
    public let verb: String
    public let particle: String
    public let phrasalVerb: String
    public let level: PhrasalVerbLevel
    public let meaningEn: String
    public let meaningPt: String
    public let category: String
    public let examples: [String]
    public let teacherTip: String

    public init(
        id: String,
        verb: String,
        particle: String,
        phrasalVerb: String,
        level: PhrasalVerbLevel,
        meaningEn: String,
        meaningPt: String,
        category: String,
        examples: [String],
        teacherTip: String = ""
    ) {
        self.id = id
        self.verb = verb
        self.particle = particle
        self.phrasalVerb = phrasalVerb
        self.level = level
        self.meaningEn = meaningEn
        self.meaningPt = meaningPt
        self.category = category
        self.examples = examples
        self.teacherTip = teacherTip
    }
}

public enum PhrasalVerbsCatalogData {
    public static let items: [PhrasalVerbCatalogItem] = [
"""
for item in pv_items:
    examples_str = ", ".join([f'"{escape_swift_str(ex)}"' for ex in item['examples']])
    pv_catalog_swift += f"""        PhrasalVerbCatalogItem(
            id: "{item['id']}",
            verb: "{escape_swift_str(item['verb'])}",
            particle: "{escape_swift_str(item['particle'])}",
            phrasalVerb: "{escape_swift_str(item['phrasalVerb'])}",
            level: {level_enum(item['level'])},
            meaningEn: "{escape_swift_str(item['meaningEn'])}",
            meaningPt: "{escape_swift_str(item['meaningPt'])}",
            category: "{escape_swift_str(item['category'])}",
            examples: [{examples_str}],
            teacherTip: "{escape_swift_str(item['teacherTip'])}"
        ),
"""
pv_catalog_swift += """    ]
}
"""

with open(r"Sources\Data\PhrasalVerbs\PhrasalVerbsCatalogData.swift", "w", encoding="utf-8") as f:
    f.write(pv_catalog_swift)
print("Written Sources/Data/PhrasalVerbs/PhrasalVerbsCatalogData.swift")

# 4.3 PhrasalVerbsQuestionsData.swift
pv_q_swift = """//
//  PhrasalVerbsQuestionsData.swift
//  English along with John - Data / PhrasalVerbs
//

import Foundation

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
"""
for q in pv_questions:
    opts_swift = ", ".join([f'QuestionOption(id: "{escape_swift_str(o["id"])}", text: "{escape_swift_str(o["text"])}")' for o in q["options"]])
    pv_q_swift += f"""        PhrasalVerbQuizQuestion(
            id: "{q['id']}",
            prompt: "{escape_swift_str(q['prompt'])}",
            options: [{opts_swift}],
            correctOptionId: "{escape_swift_str(q['correctOptionId'])}",
            phrasalVerb: "{escape_swift_str(q['phrasalVerb'])}",
            level: {level_enum(q['level'])},
            meaningEn: "{escape_swift_str(q['meaningEn'])}",
            meaningPt: "{escape_swift_str(q['meaningPt'])}",
            fullSentence: "{escape_swift_str(q['fullSentence'])}",
            sentenceTranslation: "{escape_swift_str(q['sentenceTranslation'])}",
            whyCorrect: "{escape_swift_str(q['whyCorrect'])}",
            teacherTip: "{escape_swift_str(q['teacherTip'])}"
        ),
"""
pv_q_swift += """    ]
}
"""

with open(r"Sources\Data\PhrasalVerbs\PhrasalVerbsQuestionsData.swift", "w", encoding="utf-8") as f:
    f.write(pv_q_swift)
print("Written Sources/Data/PhrasalVerbs/PhrasalVerbsQuestionsData.swift")

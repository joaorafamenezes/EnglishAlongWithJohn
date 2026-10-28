import json
import re

def escape_swift_str(s: str) -> str:
    if s is None:
        return ""
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n').replace('\r', '')

def load_catalog():
    with open('C:/Projetos/Games/ConnectorsInEnglish/backend/src/data/connectorsCatalog.ts', encoding='utf-8') as f:
        text = f.read()
    prefix = 'export const CONNECTORS_CATALOG: ConnectorItem[] = '
    raw = text[text.find(prefix)+len(prefix):].strip()
    if raw.endswith(';'): raw = raw[:-1].strip()
    return json.loads(raw)

def load_questions():
    with open('C:/Projetos/Games/ConnectorsInEnglish/backend/src/data/questions.ts', encoding='utf-8') as f:
        text = f.read()
    prefix = 'export const QUESTIONS: Question[] = '
    raw = text[text.find(prefix)+len(prefix):].strip()
    if raw.endswith(';'): raw = raw[:-1].strip()
    return json.loads(raw)

def load_ever_questions():
    with open('C:/Projetos/Games/ConnectorsInEnglish/frontend/src/data/everQuestions.ts', encoding='utf-8') as f:
        text = f.read()
    prefix = 'export const EVER_QUESTIONS: EverQuestion[] = '
    raw = text[text.find(prefix)+len(prefix):].strip()
    if raw.endswith(';'): raw = raw[:-1].strip()
    return json.loads(raw)

# 1. Generate ConnectorsCatalogData.swift
catalog = load_catalog()
print(f"Loaded {len(catalog)} catalog items.")

catalog_lines = [
    "//",
    "//  ConnectorsCatalogData.swift",
    "//  English along with John - Data / Connectors",
    "//",
    "",
    "import Foundation",
    "",
    "public enum ConnectorsCatalogData {",
    "    public static let allConnectors: [Connector] = ["
]

for item in catalog:
    num = item.get('number', 0)
    cid = escape_swift_str(item.get('id', ''))
    conn = escape_swift_str(item.get('connector', ''))
    trans = escape_swift_str(item.get('translation', ''))
    fam = item.get('family', 'emphasis')
    rule = escape_swift_str(item.get('grammarRule', ''))
    notes = escape_swift_str(item.get('notes', ''))
    examples = item.get('examples', [])
    ex_strs = ', '.join([f'"{escape_swift_str(ex)}"' for ex in examples])

    catalog_lines.append(f"""        Connector(
            id: "{cid}",
            number: {num},
            connector: "{conn}",
            translation: "{trans}",
            family: .{fam},
            grammarRule: "{rule}",
            notes: "{notes}",
            examples: [{ex_strs}]
        ),""")

catalog_lines.append("    ]")
catalog_lines.append("}")
catalog_lines.append("")

with open('Sources/Data/Connectors/ConnectorsCatalogData.swift', 'w', encoding='utf-8') as f:
    f.write('\n'.join(catalog_lines))

print("Wrote ConnectorsCatalogData.swift successfully.")

# 2. Generate EverQuestionsData.swift
ever_q = load_ever_questions()
print(f"Loaded {len(ever_q)} ever questions.")

ever_lines = [
    "//",
    "//  EverQuestionsData.swift",
    "//  English along with John - Data / Connectors",
    "//",
    "",
    "import Foundation",
    "",
    "public enum EverQuestionsData {",
    "    public static let questions: [ConnectorExercise] = ["
]

for q in ever_q:
    qid = escape_swift_str(q.get('id', ''))
    prompt = escape_swift_str(q.get('prompt', ''))
    opts = q.get('options', [])
    opt_strs = ', '.join([f'ConnectorExerciseOption(id: "{escape_swift_str(o["id"])}", text: "{escape_swift_str(o["text"])}")' for o in opts])
    correct = escape_swift_str(q.get('correctOptionId', ''))
    conn_id = escape_swift_str(q.get('connector', '').lower().replace(' ', '-'))
    conn_term = escape_swift_str(q.get('connector', ''))
    fam = q.get('family', 'emphasis')
    trans = escape_swift_str(q.get('translation', ''))
    expl = escape_swift_str(q.get('explanation', ''))
    full_sent = escape_swift_str(q.get('fullSentence', ''))
    sent_trans = escape_swift_str(q.get('sentenceTranslation', ''))
    why_corr = escape_swift_str(q.get('whyCorrect', ''))
    why_fail = escape_swift_str(q.get('whyOthersFail', ''))
    pro_tip = escape_swift_str(q.get('proTip', ''))

    ever_lines.append(f"""        ConnectorExercise(
            id: "{qid}",
            prompt: "{prompt}",
            options: [{opt_strs}],
            correctOptionId: "{correct}",
            connectorId: "{conn_id}",
            connectorTerm: "{conn_term}",
            family: .{fam},
            translation: "{trans}",
            explanation: "{expl}",
            fullSentence: "{full_sent}",
            sentenceTranslation: "{sent_trans}",
            whyCorrect: "{why_corr}",
            whyOthersFail: "{why_fail}",
            proTip: "{pro_tip}"
        ),""")

ever_lines.append("    ]")
ever_lines.append("}")
ever_lines.append("")

with open('Sources/Data/Connectors/EverQuestionsData.swift', 'w', encoding='utf-8') as f:
    f.write('\n'.join(ever_lines))

print("Wrote EverQuestionsData.swift successfully.")

# 3. Generate ConnectorsQuestionsData.swift
gen_q = load_questions()
print(f"Loaded {len(gen_q)} general questions.")

gen_lines = [
    "//",
    "//  ConnectorsQuestionsData.swift",
    "//  English along with John - Data / Connectors",
    "//",
    "",
    "import Foundation",
    "",
    "public enum ConnectorsQuestionsData {",
    "    public static let questions: [ConnectorExercise] = ["
]

for q in gen_q:
    qid = escape_swift_str(q.get('id', ''))
    prompt = escape_swift_str(q.get('prompt', ''))
    opts = q.get('options', [])
    opt_strs = ', '.join([f'ConnectorExerciseOption(id: "{escape_swift_str(o["id"])}", text: "{escape_swift_str(o["text"])}")' for o in opts])
    correct = escape_swift_str(q.get('correctOptionId', ''))
    conn_id = escape_swift_str(q.get('connector', '').lower().replace(' ', '-'))
    conn_term = escape_swift_str(q.get('connector', ''))
    fam = q.get('family', 'emphasis')
    trans = escape_swift_str(q.get('translation', ''))
    expl = escape_swift_str(q.get('explanation', ''))
    full_sent = escape_swift_str(q.get('fullSentence', ''))
    sent_trans = escape_swift_str(q.get('sentenceTranslation', ''))
    why_corr = escape_swift_str(q.get('whyCorrect', ''))
    why_fail = escape_swift_str(q.get('whyOthersFail', ''))
    pro_tip = escape_swift_str(q.get('proTip', ''))

    gen_lines.append(f"""        ConnectorExercise(
            id: "{qid}",
            prompt: "{prompt}",
            options: [{opt_strs}],
            correctOptionId: "{correct}",
            connectorId: "{conn_id}",
            connectorTerm: "{conn_term}",
            family: .{fam},
            translation: "{trans}",
            explanation: "{expl}",
            fullSentence: "{full_sent}",
            sentenceTranslation: "{sent_trans}",
            whyCorrect: "{why_corr}",
            whyOthersFail: "{why_fail}",
            proTip: "{pro_tip}"
        ),""")

gen_lines.append("    ]")
gen_lines.append("}")
gen_lines.append("")

with open('Sources/Data/Connectors/ConnectorsQuestionsData.swift', 'w', encoding='utf-8') as f:
    f.write('\n'.join(gen_lines))

print("Wrote ConnectorsQuestionsData.swift successfully.")

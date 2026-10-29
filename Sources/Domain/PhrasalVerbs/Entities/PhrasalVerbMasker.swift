//
//  PhrasalVerbMasker.swift
//  English along with John - Domain / PhrasalVerbs
//

import Foundation

/// Utilitário de domínio para mascarar phrasal verbs em sentenças em inglês,
/// substituindo a ocorrência (seja em forma base, flexionada/conjugada ou separada)
/// por uma lacuna visual ("_____") para quizzes e desafios.
public enum PhrasalVerbMasker {

    /// Mascara o phrasal verb na frase fornecida, retornando a sentença com a lacuna "_____".
    /// - Parameters:
    ///   - sentence: A frase original em inglês.
    ///   - phrasalVerb: O phrasal verb canônico (ex: "Figure out", "Give up").
    ///   - verb: O verbo base (ex: "figure", "give").
    ///   - particle: A partícula ou preposição (ex: "out", "up", "forward to").
    /// - Returns: A frase com a lacuna no lugar do phrasal verb.
    public static func mask(
        sentence: String,
        phrasalVerb: String,
        verb: String,
        particle: String
    ) -> String {
        // 1. Tentar substituição direta pelo termo literal completo (ex: "Give up", "Figure out")
        let trimmedFull = phrasalVerb.trimmingCharacters(in: .whitespaces)
        if let range = sentence.range(of: trimmedFull, options: .caseInsensitive) {
            return sentence.replacingCharacters(in: range, with: "_____")
        }

        let cleanVerb = verb.lowercased().trimmingCharacters(in: .whitespaces)
        let cleanParticle = particle.lowercased().trimmingCharacters(in: .whitespaces)

        // 2. Formas flexionadas e irregulares conhecidas
        let inflections = verbInflections(for: cleanVerb)

        // Tentar formas contíguas: "<inflexão> <partícula>" (ex: "figured out", "carried out", "came across")
        for form in inflections {
            let candidate = "\(form) \(cleanParticle)"
            if let range = sentence.range(of: candidate, options: .caseInsensitive) {
                return sentence.replacingCharacters(in: range, with: "_____")
            }
        }

        // 3. Casos separáveis ou com pronome/objeto intermediário (ex: "turned it down", "put my name down")
        if !cleanParticle.isEmpty {
            let formsPattern = (inflections + [cleanVerb])
                .map { NSRegularExpression.escapedPattern(for: $0) }
                .joined(separator: "|")
            let particlePattern = NSRegularExpression.escapedPattern(for: cleanParticle)
            let regexPattern = "\\b(\(formsPattern))\\s+([a-zA-Z0-9_'\\-\\s]{1,30}?)\\s+(\(particlePattern))\\b"

            if let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive),
               let match = regex.firstMatch(in: sentence, range: NSRange(sentence.startIndex..., in: sentence)),
               let matchRange = Range(match.range, in: sentence) {
                return sentence.replacingCharacters(in: matchRange, with: "_____")
            }

            // 4. Fallback: qualquer palavra seguida pela partícula
            let fallbackPattern = "\\b\\w+\\s+\(particlePattern)\\b"
            if let fallbackRegex = try? NSRegularExpression(pattern: fallbackPattern, options: .caseInsensitive),
               let match = fallbackRegex.firstMatch(in: sentence, range: NSRange(sentence.startIndex..., in: sentence)),
               let matchRange = Range(match.range, in: sentence) {
                return sentence.replacingCharacters(in: matchRange, with: "_____")
            }
        } else {
            // Partícula vazia: mascarar apenas o verbo ou suas formas
            for form in inflections {
                let pattern = "\\b\(NSRegularExpression.escapedPattern(for: form))\\b"
                if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
                   let match = regex.firstMatch(in: sentence, range: NSRange(sentence.startIndex..., in: sentence)),
                   let matchRange = Range(match.range, in: sentence) {
                    return sentence.replacingCharacters(in: matchRange, with: "_____")
                }
            }
        }

        return sentence
    }

    /// Retorna as formas flexionadas comuns para o verbo fornecido (passado, particípio, gerúndio e 3ª pessoa).
    public static func verbInflections(for verb: String) -> [String] {
        var results: Set<String> = [verb]

        // Dicionário de verbos irregulares e comuns do catálogo
        let irregulars: [String: [String]] = [
            "be": ["is", "are", "was", "were", "been", "being", "am"],
            "figure": ["figured", "figures", "figuring"],
            "carry": ["carried", "carries", "carrying"],
            "come": ["came", "comes", "coming"],
            "turn": ["turned", "turns", "turning"],
            "give": ["gave", "given", "gives", "giving"],
            "run": ["ran", "runs", "running"],
            "look": ["looked", "looks", "looking"],
            "call": ["called", "calls", "calling"],
            "bring": ["brought", "brings", "bringing"],
            "put": ["put", "puts", "putting"],
            "catch": ["caught", "catches", "catching"],
            "get": ["got", "gotten", "gets", "getting"],
            "find": ["found", "finds", "finding"],
            "take": ["took", "taken", "takes", "taking"],
            "make": ["made", "makes", "making"],
            "go": ["went", "gone", "goes", "going"],
            "hold": ["held", "holds", "holding"],
            "stand": ["stood", "stands", "standing"],
            "break": ["broke", "broken", "breaks", "breaking"],
            "set": ["set", "sets", "setting"],
            "cut": ["cut", "cuts", "cutting"],
            "keep": ["kept", "keeps", "keeping"],
            "fall": ["fell", "fallen", "falls", "falling"],
            "drop": ["dropped", "drops", "dropping"],
            "show": ["showed", "shown", "shows", "showing"],
            "hang": ["hung", "hangs", "hanging"],
            "work": ["worked", "works", "working"],
            "point": ["pointed", "points", "pointing"],
            "clean": ["cleaned", "cleans", "cleaning"]
        ]

        if let list = irregulars[verb] {
            results.formUnion(list)
        }

        // Regras regulares automáticas
        if verb.hasSuffix("e") {
            results.insert(verb + "d")
            results.insert(verb + "s")
            results.insert(String(verb.dropLast()) + "ing")
        } else if verb.hasSuffix("y") {
            let stem = String(verb.dropLast())
            results.insert(stem + "ied")
            results.insert(stem + "ies")
            results.insert(verb + "ing")
        } else {
            results.insert(verb + "ed")
            results.insert(verb + "s")
            results.insert(verb + "ing")
        }

        // Ordenar da maior string para a menor para evitar prefix matches indesejados
        return Array(results).sorted { $0.count > $1.count }
    }
}

import Foundation
import NaturalLanguage

/// A playful English-to-"French English" transformer.
///
/// The goal is a readable comic voice, not a phonetic transcription of a real
/// French accent. Transformations are deliberately selective and deterministic:
/// the same sentence always receives the same flourishes.
struct FunnyFrenchProcessor {
    private let addFlourishes: Bool

    init(addFlourishes: Bool = true) {
        self.addFlourishes = addFlourishes
    }

    func transform(text: String, language: NLLanguage? = .english) -> String {
        guard !text.isEmpty else { return "" }

        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        tokenizer.setLanguage(language ?? .english)

        var output = ""
        var cursor = text.startIndex
        var sentenceNumber = 0

        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            output += text[cursor..<range.lowerBound]
            output += transformSentence(
                String(text[range]),
                number: sentenceNumber,
                language: language
            )
            cursor = range.upperBound
            sentenceNumber += 1
            return true
        }

        output += text[cursor...]
        return output
    }

    private func transformSentence(
        _ sentence: String,
        number: Int,
        language: NLLanguage?
    ) -> String {
        let leading = sentence.prefix { $0.isWhitespace }
        let trailing = sentence.reversed().prefix { $0.isWhitespace }.reversed()
        let bodyStart = sentence.index(sentence.startIndex, offsetBy: leading.count)
        let bodyEnd = sentence.index(sentence.endIndex, offsetBy: -trailing.count)
        guard bodyStart < bodyEnd else { return sentence }

        var body = String(sentence[bodyStart..<bodyEnd])
        body = reshapeEnglish(body, language: language)
        body = sprinkleFrench(into: body)
        body = accentEnglishWords(in: body, language: language)

        if addFlourishes {
            body = addComicFlourish(to: body, sentenceNumber: number)
        }

        return String(leading) + body + String(trailing)
    }

    // MARK: - French-shaped phrasing

    private func reshapeEnglish(_ text: String, language: NLLanguage?) -> String {
        // French object clitics sit before the verb: "je te vois", "je l'aime".
        // Echo that surface order only when NLP identifies a subject pronoun,
        // transitive verb, and object pronoun. Lemmas cover tense and agreement.
        var result = moveObjectClitic(in: text, language: language)

        // A compact approximation of French left dislocation: establish the
        // object as the topic, then comment on it.
        result = replacing(
            pattern: #"^I\s+(love|like|want|need)\s+((?:the|this|that|a|an)\s+[\p{L}'’]+)\b"#,
            in: result,
            template: "$2, I $1",
            options: [.caseInsensitive]
        )

        // French often uses a dislocated subject for emphasis: "Moi, je..."
        result = replacing(
            pattern: #"^I\s+(think|believe|love|like|want|need|know)\b"#,
            in: result,
            template: "Moi, I $1",
            options: [.caseInsensitive]
        )

        // Informal French questions commonly use statement order and intonation.
        result = replacing(
            pattern: #"\bDo\s+you\s+"#,
            in: result,
            template: "You ",
            options: [.caseInsensitive]
        )

        // Many (not all) French adjectives follow the noun. NLP supplies the
        // adjective/noun pairing; the allow-list keeps the result readable.
        result = moveSelectedAdjectives(in: result, language: language)

        result = replacing(
            pattern: #"\ba\s+([aeiou])"#,
            in: result,
            template: "an $1",
            options: [.caseInsensitive]
        )

        if text.first(where: \Character.isLetter)?.isUppercase == true {
            result = uppercaseFirstLetter(in: result)
        }
        return result
    }

    // MARK: - Vocabulary

    private func sprinkleFrench(into text: String) -> String {
        let phrases: [(String, String)] = [
            ("my dear friend", "mon cher ami"),
            ("dear friend", "cher ami"),
            ("my friend", "mon ami"),
            ("of course", "bien sûr"),
            ("thank you", "merci"),
            ("good morning", "bonjour"),
            ("good evening", "bonsoir"),
            ("goodbye", "au revoir"),
            ("please", "s'il vous plaît"),
            ("very", "très"),
            ("really", "vraiment"),
            ("delicious", "délicieux"),
            ("wonderful", "magnifique"),
            ("yes", "oui"),
            ("no", "non"),
            ("but", "mais"),
            ("hello", "allô")
        ]

        return phrases.reduce(text) { partial, pair in
            replacePhrase(pair.0, with: pair.1, in: partial)
        }
    }

    // MARK: - Written accent

    private func accentEnglishWords(in text: String, language: NLLanguage?) -> String {
        var result = text
        let tokens = taggedWords(in: text, language: language)

        for token in tokens.reversed() {
            guard !token.isNamedEntity else { continue }
            let original = String(result[token.range])
            result.replaceSubrange(token.range, with: accentWord(original))
        }
        return result
    }

    // MARK: - Natural Language analysis

    private struct TaggedToken {
        let range: Range<String.Index>
        let lexicalClass: NLTag?
        let lemma: String
        let isNamedEntity: Bool
    }

    private func taggedWords(in text: String, language: NLLanguage?) -> [TaggedToken] {
        guard !text.isEmpty else { return [] }

        let tagger = NLTagger(tagSchemes: [.lexicalClass, .lemma, .nameType])
        tagger.string = text
        tagger.setLanguage(language ?? .english, range: text.startIndex..<text.endIndex)

        var tokens: [TaggedToken] = []
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .lexicalClass,
            options: [.omitWhitespace, .omitPunctuation]
        ) { lexicalClass, range in
            let lemma = tagger.tag(at: range.lowerBound, unit: .word, scheme: .lemma).0?.rawValue
                ?? String(text[range]).lowercased()
            let nameType = tagger.tag(at: range.lowerBound, unit: .word, scheme: .nameType).0
            let isNamedEntity = nameType == .personalName
                || nameType == .placeName
                || nameType == .organizationName

            tokens.append(
                TaggedToken(
                    range: range,
                    lexicalClass: lexicalClass,
                    lemma: lemma.lowercased(),
                    isNamedEntity: isNamedEntity
                )
            )
            return true
        }
        return tokens
    }

    private func moveObjectClitic(in text: String, language: NLLanguage?) -> String {
        let tokens = taggedWords(in: text, language: language)
        guard tokens.count >= 3 else { return text }

        let subject = tokens[0]
        let verb = tokens[1]
        let object = tokens[2]
        let subjectText = String(text[subject.range])
        let verbText = String(text[verb.range])
        let objectText = String(text[object.range])

        guard subject.lexicalClass == .pronoun,
              verb.lexicalClass == .verb,
              object.lexicalClass == .pronoun,
              Self.subjectPronouns.contains(subjectText.lowercased()),
              Self.objectPronouns.contains(objectText.lowercased()),
              Self.cliticVerbLemmas.contains(verb.lemma),
              text[subject.range.upperBound..<verb.range.lowerBound].allSatisfy(\.isWhitespace),
              text[verb.range.upperBound..<object.range.lowerBound].allSatisfy(\.isWhitespace)
        else { return text }

        var result = text
        result.replaceSubrange(
            subject.range.lowerBound..<object.range.upperBound,
            with: "\(subjectText) \(objectText) \(verbText)"
        )
        return result
    }

    private func moveSelectedAdjectives(in text: String, language: NLLanguage?) -> String {
        let tokens = taggedWords(in: text, language: language)
        guard tokens.count >= 2 else { return text }

        var result = text
        var swaps: [(Range<String.Index>, String)] = []
        for index in 0..<(tokens.count - 1) {
            let adjective = tokens[index]
            let noun = tokens[index + 1]
            guard adjective.lexicalClass == .adjective,
                  noun.lexicalClass == .noun,
                  Self.postpositiveAdjectives.contains(adjective.lemma),
                  text[adjective.range.upperBound..<noun.range.lowerBound].allSatisfy(\.isWhitespace)
            else { continue }

            swaps.append(
                (
                    adjective.range.lowerBound..<noun.range.upperBound,
                    "\(text[noun.range]) \(text[adjective.range].lowercased())"
                )
            )
        }

        for swap in swaps.reversed() {
            result.replaceSubrange(swap.0, with: swap.1)
        }
        return result
    }

    private func accentWord(_ original: String) -> String {
        let lower = original.lowercased()
        guard lower.unicodeScalars.allSatisfy(\.isASCII) else { return original }
        guard !Self.frenchWords.contains(lower) else { return original }

        let substitutions: [String: String] = [
            "the": "ze", "this": "zis", "that": "zat",
            "these": "zese", "those": "zose", "they": "zey",
            "them": "zem", "their": "zeir", "there": "zere",
            "then": "zen", "with": "wiz", "without": "wizout",
            "think": "zink", "thing": "zing", "things": "zings",
            "is": "eez", "it": "eet", "little": "leetle",
            "people": "peeple"
        ]

        var changed = substitutions[lower] ?? lower

        if substitutions[lower] == nil {
            if Self.silentHWords.contains(lower), changed.hasPrefix("h") {
                changed.removeFirst()
                changed = "'" + changed
            }
            if changed.hasPrefix("w") {
                changed.replaceSubrange(changed.startIndex...changed.startIndex, with: "v")
            }
            changed = changed.replacingOccurrences(of: "th", with: "z")
            if changed.hasSuffix("ing"), changed.count > 4 {
                changed.replaceSubrange(changed.index(changed.endIndex, offsetBy: -3)..., with: "eeng")
            }
        }

        return matchCase(of: original, in: changed)
    }

    // MARK: - Comic timing

    private func addComicFlourish(to text: String, sentenceNumber: Int) -> String {
        let wordCount = text.split { !$0.isLetter }.count
        guard wordCount >= 5 else { return text }

        var result = text
        let seed = stableHash(text) &+ UInt64(sentenceNumber &* 131)

        if seed % 4 == 0, !Self.frenchOpeners.contains(where: {
            result.lowercased().hasPrefix($0)
        }) {
            let openers = ["Alors", "Bon", "Écoutez", "Mais enfin"]
            result = "\(openers[Int((seed / 4) % UInt64(openers.count))]), \(lowercaseFirst(result))"
        }

        if seed % 5 == 1, !result.contains("?") {
            result = insertingTag(", n'est-ce pas", into: result)
        } else if seed % 7 == 2, !result.contains("?") {
            result = insertingTag(", non", into: result)
        }

        return result
    }

    private func insertingTag(_ tag: String, into text: String) -> String {
        guard let punctuation = text.lastIndex(where: { ".!?".contains($0) }) else {
            return text + tag + "?"
        }
        let before = text[..<punctuation]
        let mark = text[punctuation]
        let after = text[text.index(after: punctuation)...]
        let finalMark = mark == "." ? "?" : String(mark)
        return String(before) + tag + finalMark + String(after)
    }

    // MARK: - Helpers

    private func replacePhrase(_ phrase: String, with replacement: String, in text: String) -> String {
        let escaped = NSRegularExpression.escapedPattern(for: phrase)
            .replacingOccurrences(of: #"\ "#, with: #"\s+"#)
        let regex = try! NSRegularExpression(
            pattern: "\\b\(escaped)\\b",
            options: [.caseInsensitive]
        )
        var result = text
        let matches = regex.matches(in: result, range: NSRange(result.startIndex..., in: result))
        for match in matches.reversed() {
            guard let range = Range(match.range, in: result) else { continue }
            let original = String(result[range])
            result.replaceSubrange(range, with: matchCase(of: original, in: replacement))
        }
        return result
    }

    private func replacing(
        pattern: String,
        in text: String,
        template: String,
        options: NSRegularExpression.Options = []
    ) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(
            in: text,
            range: NSRange(text.startIndex..., in: text),
            withTemplate: template
        )
    }

    private func matchCase(of source: String, in replacement: String) -> String {
        if source == source.uppercased() { return replacement.uppercased() }
        guard source.first?.isUppercase == true, let first = replacement.first else {
            return replacement
        }
        return first.uppercased() + replacement.dropFirst()
    }

    private func lowercaseFirst(_ text: String) -> String {
        guard let first = text.first else { return text }
        return first.lowercased() + text.dropFirst()
    }

    private func uppercaseFirstLetter(in text: String) -> String {
        guard let index = text.firstIndex(where: \Character.isLetter) else { return text }
        var result = text
        result.replaceSubrange(index...index, with: result[index].uppercased())
        return result
    }

    private func stableHash(_ text: String) -> UInt64 {
        text.utf8.reduce(14_695_981_039_346_656_037) { hash, byte in
            (hash ^ UInt64(byte)) &* 1_099_511_628_211
        }
    }

    private static let silentHWords: Set<String> = [
        "he", "hello", "help", "her", "here", "hers", "him", "his",
        "how", "house", "had", "has", "have", "happy", "hard", "hope"
    ]

    private static let frenchWords: Set<String> = [
        "alors", "allô", "ami", "au", "bien", "bon", "bonjour", "bonsoir",
        "cher", "délicieux", "écoutez", "enfin", "magnifique", "mais", "merci",
        "moi", "mon", "non", "oui", "plaît", "revoir", "s'il", "sûr", "très",
        "vous", "vraiment"
    ]

    private static let frenchOpeners = ["alors", "bon,", "écoutez", "mais enfin"]

    private static let subjectPronouns: Set<String> = [
        "i", "you", "we", "they", "he", "she"
    ]

    private static let objectPronouns: Set<String> = [
        "me", "you", "him", "her", "it", "us", "them"
    ]

    private static let cliticVerbLemmas: Set<String> = [
        "love", "like", "see", "know", "understand", "remember", "hear", "help"
    ]

    private static let postpositiveAdjectives: Set<String> = [
        "beautiful", "important", "interesting", "strange", "ridiculous",
        "impossible", "enormous", "excellent"
    ]
}

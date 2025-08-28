//
//  TextGenerator.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

// =========================
// File: TextGenerator.swift (tokenize + pipeline)
// =========================
import Foundation
import NaturalLanguage

protocol TextGenerator {
	var text: String { get set }
	func recognizeLanguage(text: String) -> NLLanguage?
	func processText(lang: NLLanguage?)
}

extension TextGenerator {
	func recognizeLanguage(text: String) -> NLLanguage? {
		let lang = NLLanguageRecognizer.dominantLanguage(for: text)
		if let lang { print("Language:", Locale.current.localizedString(forIdentifier: lang.rawValue) ?? lang.rawValue) }
		return lang
	}
	func processText(lang: NLLanguage?) {}
}

struct TaggedWord { var text: String; var nlTag: NLTag? }

class DefaultTextgenerator: TextGenerator {
	init(text: String) { self.text = text }
	var text: String
	var textTaggedArray = [TaggedWord]()
	var doneTaggedArray = [TaggedWord]()
	
	func tokenize2(text: String, lang: NLLanguage?) -> [TaggedWord]  {
		let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass])
		if let lang { tagger.setLanguage(lang,  range: text.startIndex..<text.endIndex) }
		tagger.string = text
		var tagged: [TaggedWord] = []
		tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameTypeOrLexicalClass, options: [.joinNames]) { tag, r in
			tagged.append(TaggedWord(text: String(text[r]), nlTag: tag))
			return true
		}
		return tagged
	}
	
	func processText(lang: NLLanguage?) { textTaggedArray = tokenize2(text: text, lang: lang) }
	func determineLanguage() -> NLLanguage? { recognizeLanguage(text: text) }
	
	func processWords() -> String {
		var f = FunnyFrenchProcessor()
		doneTaggedArray.removeAll(keepingCapacity: true)
		for w in textTaggedArray {
			var t = w.text
			t = f.makeFunOfWordItself(orig: t)
			t = f.makeFunOfWordItself(orig: t)
			t = f.makeFunOfE(text: t)
			t = f.makeFunOfIntraWord(text: t)
			doneTaggedArray.append(TaggedWord(text: t, nlTag: w.nlTag))
		}
		for i in 0..<doneTaggedArray.count where i+1 < doneTaggedArray.count {
			if doneTaggedArray[i].nlTag == .adjective && doneTaggedArray[i+1].nlTag == .noun {
				doneTaggedArray.swapAt(i, i+1)
			}
		}
		var out = doneTaggedArray.map { $0.text }.joined(separator: " ")
		out = out.replacingOccurrences(of: " , ", with: ", ")
			.replacingOccurrences(of: " . ", with: ". ")
			.replacingOccurrences(of: " ; ", with: "; ")
		return out
	}
}


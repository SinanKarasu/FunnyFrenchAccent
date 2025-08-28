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



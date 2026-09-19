//
//  DefaultTextGenerator.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

import NaturalLanguage

final class DefaultTextGenerator: TextGenerator {
    init(text: String) { self.text = text }

    var text: String
    private let processor = FunnyFrenchProcessor()
    private var detectedLanguage: NLLanguage?

    func determineLanguage() -> NLLanguage? {
        recognizeLanguage(text: text)
    }

    func processText(lang: NLLanguage?) {
        detectedLanguage = lang
    }

    func processWords() -> String {
        processor.transform(text: text, language: detectedLanguage)
    }
}

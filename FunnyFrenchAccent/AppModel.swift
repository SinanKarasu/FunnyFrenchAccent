//
//  AppModel.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

import SwiftUI

@Observable
public final class AppModel {
	var input: String = "Hello my dear friend, this is a funny test."
	var output: String = ""
	
	private let generator = DefaultTextGenerator(text: "")
	
	func transform() {
		let w = generator
		w.text = input
		let lang = w.determineLanguage()
		w.processText(lang: lang)
		output = w.processWords()
	}
	
	func copyOutput() {
		let s = output.isEmpty ? input : output
		crossPlatformCopy(s)
	}
	
	public static func loadOrDefault() -> AppModel {
		return AppModel()
	}
}


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
	
	private let generator = DefaultTextgenerator(text: "")
	
	@ObservationIgnored
	private static let url: URL = {
		let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
		try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
		return dir.appendingPathComponent("SwiftGraphMesh-prefs.json")
	}()
	
	func transform() {
		var w = generator
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



//
//  FunnyFrenchAccentApp.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

import SwiftUI

@main
struct FunnyFrenchAccentApp: App {
	@State private var appModel = AppModel()
	
	var body: some Scene {
		WindowGroup(id: "main") {
			ContentView()
				.environment(appModel)
		}
		// Example of an optional second scene (reader-only window)
		WindowGroup(id: "reader") {
			ReaderView(app: appModel)
				//.environment(appModel)
		}
		.commands {
			AppCommands()
		}
	}
}

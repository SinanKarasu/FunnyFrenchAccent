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
	@Environment(\.openWindow) private var openWindow
	
	var body: some Scene {
		WindowGroup(id: "main") {
			ContentView()
				.environment(appModel)
		}
		WindowGroup(id: "reader") {
			ReaderView()
				.environment(appModel)
		}
		.commands {
			AppCommands(
				transform: { appModel.transform() },
				copy:      { appModel.copyOutput() },
				newReader: { openWindow(id: "reader") }
			)
		}
	}
}

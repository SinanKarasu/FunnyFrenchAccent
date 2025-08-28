//
//  AppCommands.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

// =========================
// File: AppCommands.swift (Keyboard shortcuts / menu)
// =========================

import SwiftUI

struct AppCommands: Commands {
	@Environment(AppModel.self) private var app      // ← your @Observable model
	@Environment(\.openWindow) private var openWindow
	
	var body: some Commands {
		CommandGroup(after: .newItem) {
			Button("Transform") { app.transform() }
				.keyboardShortcut("t", modifiers: [.command])
			
#if os(macOS) || os(iPadOS)
			Button("New Reader Window") { openWindow(id: "reader") }
				.keyboardShortcut("n", modifiers: [.command, .shift])
#endif
		}
		
		CommandGroup(replacing: .pasteboard) {
			Button("Copy Output") { app.copyOutput() }
				.keyboardShortcut("c", modifiers: [.command])
		}
	}
}

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
	let transform: () -> Void
	let copy: () -> Void
	let newReader: () -> Void
	
	var body: some Commands {
		CommandGroup(after: .newItem) {
			Button("Transform", action: transform)
				.keyboardShortcut("t", modifiers: [.command])
			
#if os(macOS) || os(iPadOS)
			Button("New Reader Window", action: newReader)
				.keyboardShortcut("n", modifiers: [.command, .shift])
#endif
		}
		CommandGroup(replacing: .pasteboard) {
			Button("Copy Output", action: copy)
				.keyboardShortcut("c", modifiers: [.command])
		}
	}
}

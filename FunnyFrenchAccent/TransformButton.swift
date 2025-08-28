//
//  TransformButton.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

import SwiftUI

struct TransformButton: View {
	let action: () -> Void
	@State private var hovering = false
	
	var body: some View {
		Button("Transform", action: action)
			.buttonStyle(.borderedProminent)
			.onHover { hovering = $0 }
			.scaleEffect(hovering ? 1.03 : 1.0)
			.animation(.easeInOut(duration: 0.12), value: hovering)
			.hoverEffect(.highlight)
			.keyboardShortcut("t", modifiers: [.command])
			.focusable(true)
	}
}

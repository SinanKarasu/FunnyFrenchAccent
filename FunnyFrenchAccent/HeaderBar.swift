//
//  HeaderBar.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

import SwiftUI

struct HeaderBar: View {
	let onOpen: () -> Void
	let onSave: () -> Void
	let onCopy: () -> Void
	let onShare: () -> Void
	let onAbout: () -> Void            // NEW
	var body: some View {
		HStack {
			Button("Open…", action: onOpen)
			Button("Save Output…", action: onSave)
			Spacer()
			Button("Copy", action: onCopy)
			Button("Share", action: onShare)
			Button("About", action: onAbout) // NEW
		}
	}
}

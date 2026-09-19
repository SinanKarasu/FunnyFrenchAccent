//
//  Clipboard.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

// =========================
// File: Clipboard.swift (cross‑platform clipboard)
// =========================
import SwiftUI
#if os(iOS)
import UIKit
func crossPlatformCopy(_ s: String) { UIPasteboard.general.string = s }
#elseif os(macOS)
import AppKit
func crossPlatformCopy(_ s: String) {
	let pb = NSPasteboard.general
	pb.clearContents(); pb.setString(s, forType: .string)
}
#endif



#if os(iOS)
import UIKit
func copyToPasteboard(_ s: String) { UIPasteboard.general.string = s }
struct ShareSheet: UIViewControllerRepresentable {
	var activityItems: [Any]
	func makeUIViewController(context: Context) -> UIActivityViewController {
		UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
	}
	func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}
#elseif os(macOS)
import AppKit
struct ShareSheet: View {
	var activityItems: [Any]
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack(spacing: 12) {
			Text("Share Output")
				.font(.headline)
			Button("Copy Text") { copyToPasteboard(String(describing: activityItems.first ?? "")) }
			Button("Close") { dismiss() }
		}.padding()
	}
}
func copyToPasteboard(_ s: String) {
	let pb = NSPasteboard.general
	pb.clearContents()
	pb.setString(s, forType: .string)
}
#endif

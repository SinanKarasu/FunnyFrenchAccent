//
//  ContentView.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

// =========================
// File: ContentView.swift (Shared UI)
// =========================
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
	@Environment(AppModel.self) private var app: AppModel
	@State private var importing = false
	@State private var exporting = false
	@State private var exportDoc = FunnyFrenchDocument()
	@Environment(\.horizontalSizeClass) private var hSize
	
	@State private var showShare = false
	@State private var shareText = ""

	
	var body: some View {
		let pad: CGFloat = (hSize == .regular) ? 24 : 12
		@Bindable var app = app

		VStack(alignment: .leading, spacing: 14) {
			HeaderBar(onOpen: { importing = true }, onSave: {
				exportDoc.text = app.output.isEmpty ? app.input : app.output
				exporting = true
			}, onCopy: { app.copyOutput() }, onShare: { presentShare(app.output.isEmpty ? app.input : app.output) })
			
			Text("Input").font(.headline)
			TextEditor(text: $app.input)
				.textEditorStyle(.plain)
				.frame(minHeight: 140)
				.padding(8)
				.overlay(RoundedRectangle(cornerRadius: 10).stroke(.quaternary))
			
			TransformButton { app.transform() }
			
			if !app.output.isEmpty {
				Text("Output").font(.headline)
				ScrollView {
					Text(app.output)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(8)
						.background(.ultraThinMaterial)
						.clipShape(RoundedRectangle(cornerRadius: 10))
				}
				.frame(minHeight: 120)
			}
			Spacer(minLength: 0)
		}
		.padding(pad)
		.fileImporter(isPresented: $importing, allowedContentTypes: [.plainText]) { res in
			if case .success(let url) = res, let s = try? String(contentsOf: url, encoding: .utf8) {
				app.input = s; app.output = ""
			}
		}
		.fileExporter(isPresented: $exporting, document: exportDoc, contentType: .plainText, defaultFilename: "FunnyFrench.txt") { _ in }
		.toolbar { ToolbarItem(placement: .primaryAction) { TransformButton { app.transform() } } }
		.navigationTitle("FunnyFrench")
		.sheet(isPresented: $showShare) {
			ShareSheet(activityItems: [shareText])
		}

	}
	
	func presentShare(_ text: String) {
		shareText = text
		showShare = true
	}
	
}

#Preview {
    ContentView()
}

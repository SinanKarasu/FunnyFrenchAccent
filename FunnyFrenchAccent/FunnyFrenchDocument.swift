//
//  FunnyFrenchDocument.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//
// =========================
// File: FunnyFrenchDocument.swift (fileImporter/exporter)
// =========================
import SwiftUI
import UniformTypeIdentifiers

struct FunnyFrenchDocument: FileDocument {
	static var readableContentTypes: [UTType] = [.plainText]
	static var writableContentTypes: [UTType] = [.plainText]
	var text: String = ""
	init(text: String = "") { self.text = text }
	init(configuration: ReadConfiguration) throws {
		if let data = configuration.file.regularFileContents, let s = String(data: data, encoding: .utf8) {
			text = s
		}
	}
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		FileWrapper(regularFileWithContents: text.data(using: .utf8) ?? Data())
	}
}



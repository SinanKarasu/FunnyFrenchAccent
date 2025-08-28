//
//  AboutView.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/28/25.
//

import SwiftUI

struct AboutView: View {
	private var appName: String {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
		?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
		?? "Funny French Accent"
	}
	private var version: String {
		let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
		let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
		return "Version \(v) (\(b))"
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack(spacing: 12) {
				Image("AppIcon") // optional: if you’ve added an image; else remove
					.resizable()
					.frame(width: 48, height: 48)
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.opacity(0.0) // hide if you didn't add a separate asset
				VStack(alignment: .leading, spacing: 4) {
					Text(appName).font(.title3).bold()
					Text(version).foregroundStyle(.secondary)
				}
			}
			
			Divider()
			
			Text("Credits").font(.headline)
			Text("Certain substitution ideas inspired by Sean Patrick Payne’s 2014 “Fake French Accent Translator”.")
				.fixedSize(horizontal: false, vertical: true)
			
			HStack(spacing: 16) {
				Link("Blog Post", destination: URL(string:
													"https://www.payneful.co.uk/blogsplosion/2014/11/16/so-i-built-a-fake-french-accent-translator/")!)
				Link("GitHub Repo", destination: URL(string:
														"https://github.com/SPPayne/fake_french_accent_translator")!)
			}
			
			Divider()
			
			Text("License").font(.headline)
			Text("This project is dual-licensed under your choice of MIT or The Unlicense. See the repository for details.")
				.fixedSize(horizontal: false, vertical: true)
			
			HStack(spacing: 16) {
				Link("MIT", destination: URL(string: "https://opensource.org/license/mit")!)
				Link("Unlicense", destination: URL(string: "https://unlicense.org")!)
				Link("Repository", destination: URL(string: "https://example.com/your-repo")!) // <-- replace
			}
			
			Divider()
			
			Text("Privacy").font(.headline)
			Text("Data Not Collected. All processing happens on-device.")
				.fixedSize(horizontal: false, vertical: true)
			
			Spacer(minLength: 0)
			
			HStack {
				Spacer()
				Button("Close") { dismiss() }
			}
		}
		.padding(20)
		.frame(minWidth: 380, idealWidth: 420, maxWidth: 560)
	}
	
	@Environment(\.dismiss) private var dismiss
}

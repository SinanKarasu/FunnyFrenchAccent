//
//  ReaderView.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

import SwiftUI

struct ReaderView: View {
	@Bindable var app: AppModel   // instead of @EnvironmentObject
	var body: some View {
		ScrollView {
			Text(app.output.isEmpty ? app.input : app.output)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding()
		}
		.navigationTitle("Reader")
	}
}


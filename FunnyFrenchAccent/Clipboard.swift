//
//  Clipboard.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

// =========================
// File: Clipboard.swift (cross‑platform clipboard)
// =========================
import Foundation
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



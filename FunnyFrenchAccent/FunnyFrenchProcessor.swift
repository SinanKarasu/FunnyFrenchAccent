//
//  FunnyFrenchProcessor.swift
//  FunnyFrenchAccent
//
//  Created by Sinan Karasu on 8/27/25.
//

// =========================
// File: FunnyFrenchProcessor.swift (rules)
// =========================
import Foundation
import NaturalLanguage

struct FunnyFrenchProcessor {
	mutating func makeFunOfIntraWord(text: String) -> String {
		if text.isEmpty { return "" }
		var t = text
		t = t.replacingOccurrences(of: "age", with: "aje", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ale", with: "aile", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ant", with: "ent", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ared", with: "aired", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ay", with: "ai", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "blem", with: "blaim", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ble", with: "buhl", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "bout", with: "but", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ck", with: "k", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "eal", with: "eahl", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ear", with: "air", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ess", with: "ez", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "ew", with: "u", options: .caseInsensitive)
		t = t.replacingOccurrences(of: "gen", with: "jen", options: .caseInsensitive)
		return t
	}
	
	mutating func makeFunOfWordItself(orig: String) -> String {
		var parts = orig.components(separatedBy: " ")
		for (i, token) in parts.enumerated() {
			let w = token
			func repl(_ a:String,_ b:String){ parts[i] = w.replacingOccurrences(of: a, with: b, options: .caseInsensitive) }
			
			if w.lowercased() == "hello" { repl("hello","'allo 'allo"); continue }
			if w.lowercased() == "hi"    { repl("hi","'allo"); continue }
			if w != "the", w.hasPrefix("h") { parts[i] = "'" + w.dropFirst() }
			
			if w.lowercased() == "i"     { parts[i] = "ai" }
			if w.lowercased() == "yes"   { repl("yes","oui") }
			if w.lowercased() == "no"    { repl("no","non") }
			if w.lowercased() == "sir"   { repl("sir","Monsieur") }
			if w.lowercased() == "mister"{ repl("mister","Monsieur") }
			if w.lowercased() == "madam" { repl("madam","Mademoiselle") }
			if w.lowercased() == "missus"{ repl("missus","Madame") }
			
			if w.lowercased() == "it"    { repl("it","eet") }
			if w.lowercased() == "is"    { repl("is","eez") }
			if w.lowercased() == "in"    { repl("in","een") }
			if w.lowercased() == "my"    { repl("my","mon") }
			if w.lowercased() == "one"   { repl("one","un") }
			if w.lowercased() == "two"   { repl("two","deux") }
			
			if w.lowercased() == "the" { parts[i] = ["le","la","oy","ze"].randomElement() ?? "ze" }
			if w.lowercased() == "that"  { repl("that","zat") }
			if w.lowercased() == "they"  { repl("they","zey") }
			if w.lowercased() == "this"  { repl("this","zis") }
			if w.lowercased() == "their" { repl("their","zeir") }
			if w.lowercased() == "there" { repl("there","zere") }
			if w.lowercased() == "then"  { repl("then","zen") }
			if w.lowercased() == "these" { repl("these","zese") }
			if w.lowercased() == "so"    { repl("so","zo") }
			if w.lowercased() == "french"{ repl("french","Francais") }
			if w.lowercased() == "shit"  { repl("shit","merde") }
			if w.lowercased() == "god"   { repl("god","Dieu") }
		}
		return parts.joined(separator: " ")
	}
	
	mutating func makeFunOfE(text: String) -> String {
		let es = ["e","è","é","ê","ë","ě","ẽ","ē","ė","ę"]
		let pick = es[Int.random(in: 0...4)]
		var t = text.replacingOccurrences(of: "e", with: pick, options: .caseInsensitive)
		for e in es {
			t = t.replacingOccurrences(of: "e"+e, with: "ee", options: .caseInsensitive)
			t = t.replacingOccurrences(of: e+"e", with: "ee", options: .caseInsensitive)
		}
		return t
	}
}



//
//  Card.swift
//  Flashzilla
//
//  Created by Jesse Sheehan on 10/19/24.
//

import Foundation

struct Card: Codable, Identifiable, Equatable, Hashable {
    var id = UUID()
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "Who played the 12th Doctor in Doctor Who?", answer: "Matt Smith")
}

//
//  Card.swift
//  MouhdonTest
//
//  Created by shuruq alshammari on 18/06/1446 AH.
//

import SwiftData
import Foundation

@Model
class Card: Identifiable {
    var id: UUID
    var emoji: String
    var cardDescription: String
    var audioFilePath: String? // Path to the audio file
    
    
    init(emoji: String, cardDescription: String, audioFilePath: String? = nil) {
            self.id = UUID() // Generate a unique identifier
            self.emoji = emoji
            self.cardDescription = cardDescription
            self.audioFilePath = audioFilePath
    }
}

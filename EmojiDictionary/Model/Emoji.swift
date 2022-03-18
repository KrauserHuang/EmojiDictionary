//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Tai Chin Huang on 2022/3/10.
//

import Foundation

// 2022/3/17 adopt Codable protocol
struct Emoji: Codable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
}
// extension for local save to file and load from file
extension Emoji {
    // specify the directory you want to save, and file(archiveURL)
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("emojis").appendingPathExtension("plist")
    // to put your data into file in local directory, first to encode than save
    static func saveToFile(emojis: [Emoji]) {
        // below 2 lines encode emojis to data
        let propertyListEncoder = PropertyListEncoder()
        let encodedEmojis = try? propertyListEncoder.encode(emojis)
        // put the encoded data to local directory
        try? encodedEmojis?.write(to: archiveURL, options: .noFileProtection)
    }
    static func loadFromFile() -> [Emoji]? {
        // decode data to your custom type
        let propertyListDecoder = PropertyListDecoder()
        // Initializes a data object with the data from the location specified by a given URL(archiveURL)
        if let retrievedEmojisData = try? Data(contentsOf: archiveURL),
           let decodedEmojis = try? propertyListDecoder.decode([Emoji].self, from: retrievedEmojisData) {
            return decodedEmojis
        }
        return nil
    }
    // empty emojis assign to EmojiTableViewController
    static func sampleEmojis() -> [Emoji] {
        let emojis = [Emoji]()
        return emojis
    }
}

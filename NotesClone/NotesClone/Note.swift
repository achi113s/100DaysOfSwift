//
//  Note.swift
//  NotesClone
//
//  Created by Giorgio Latour on 5/17/23.
//

import Foundation

struct Note: Codable, Identifiable {
    var id = UUID()
    var dateCreated: Date
    var title: String
    var content: String
    
    init(id: UUID = UUID(), dateCreated: Date = Date.now, title: String, content: String) {
        self.id = id
        self.dateCreated = dateCreated
        self.title = title
        self.content = content
    }
}

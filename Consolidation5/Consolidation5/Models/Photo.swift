//
//  Photo.swift
//  Consolidation5
//
//  Created by Giorgio Latour on 4/12/23.
//

import UIKit

class Photo: NSObject, Codable {
    var photo: String
    var caption: String
    
    init(photo: String, caption: String) {
        self.photo = photo
        self.caption = caption
    }
}

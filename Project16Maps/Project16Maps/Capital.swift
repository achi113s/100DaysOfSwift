//
//  Capital.swift
//  Project16Maps
//
//  Created by Giorgio Latour on 4/28/23.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var url: URL
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String, url: URL) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.url = url
    }
}

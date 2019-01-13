//
//  Place.swift
//  MusicbrainzPlaces
//
//  Created by Gediminas Urbonas on 08/12/2018.
//  Copyright © 2018 Gediminas Urbonas. All rights reserved.
//

import Foundation

struct Place: Decodable {
    
    let coordinates: Coordinates?
    let lifeSpan: LifeSpan?
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coordinates"
        case lifeSpan = "life-span"
    }
}

struct PlaceAnnotation {
    
    let place: Place
    let time: Int
}

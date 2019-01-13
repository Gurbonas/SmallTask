//
//  Places.swift
//  MusicbrainzPlaces
//
//  Created by Gediminas Urbonas on 08/12/2018.
//  Copyright © 2018 Gediminas Urbonas. All rights reserved.
//

import Foundation

struct Places: Decodable {
    
    let places: [Place]?
    let count: Int?
    let offset: Int?
}

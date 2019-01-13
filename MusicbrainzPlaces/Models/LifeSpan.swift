//
//  LifeSpan.swift
//  MusicbrainzPlaces
//
//  Created by Gediminas Urbonas on 08/12/2018.
//  Copyright © 2018 Gediminas Urbonas. All rights reserved.
//

import Foundation

struct LifeSpan: Decodable {
    
    let beginDate: String?
    
    public enum CodingKeys: String, CodingKey {
        case beginDate = "begin"
    }
}

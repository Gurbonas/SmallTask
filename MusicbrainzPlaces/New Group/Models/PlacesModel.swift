//
//  PlacesModel.swift
//  MusicbrainzPlaces
//
//  Created by Gediminas Urbonas on 09/12/2018.
//  Copyright © 2018 Gediminas Urbonas. All rights reserved.
//

import Foundation

protocol PlacesModelDelegate: class {
    func didLoadPlacesData(_ data: [PlaceAnnotation]?, totalPlaces: Int)
}

let constant1990 = 1990

class PlacesModel: NSObject {
    
    weak var delegate: PlacesModelDelegate?
    
    var places: [PlaceAnnotation] = []
    
    override init() {
        super.init()
        
    }
    
    
    /// Loading data for map annotations
    func loadPlacesDataWith(_ search: String, limitBy: Int, offsetBy: Int) {
        APIManager.request(findRepositories(matching: search, limitBy: String(limitBy), offsetBy: String(offsetBy))) { [weak self] (result) in
            
            do {
                let places = try result.decoded() as Places
                let filteredPlaces = places.places?.filter {
                    if let beginDate = $0.lifeSpan?.beginDate, let begin = DateUtils.date(from: beginDate), let comparableDate = DateUtils.date(from: "1990") {
                        if begin.compare(comparableDate) == .orderedDescending {
                            var components = Calendar.current.dateComponents([.year], from: begin)
                            if let beginYear = components.year {
                                let time = beginYear - constant1990
                                let newPlace = PlaceAnnotation(place: $0, time: time)
                                self?.places.append(newPlace)
                                return true
                            }
                            return false
                        }
                        return false
                    }
                    return false
                    
                }
                
                self?.delegate?.didLoadPlacesData(self?.places, totalPlaces: places.count ?? 0)
                self?.places.removeAll()
            } catch {
                print(error)
            }
            
        }
        
    }
}

//
//  MainViewController.swift
//  MusicbrainzPlaces
//
//  Created by Gediminas Urbonas on 04/12/2018.
//  Copyright © 2018 Gediminas Urbonas. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
    }
}


class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var placesLimit = 20 {
        didSet {
            
        }
    }
    var totalPlaces = 0
    
    var searchedText: String = ""
    
    var offset = 0
    
    var timer: Timer!
    
    var places: [PlaceAnnotation] = [] {
        didSet {
            let annotations = convertAnnotations(places)
            displayPosList(annotations)
        }
    }
    
    private let dataModel: PlacesModel = {
        return PlacesModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel.delegate = self
    }
    
    func convertAnnotations(_ places: [PlaceAnnotation]) -> [MKAnnotation] {
        var annotations: [MKAnnotation]? = []
        for item in places {
            if let coordinates = item.place.coordinates {
                if let doubleLatitude = Double(coordinates.latitude), let doubleLongitude = Double(coordinates.longitude) {
                    let coordinate = CLLocationCoordinate2D(latitude: doubleLatitude, longitude: doubleLongitude)
                    let annotation = customPin(pinTitle: "", pinSubtitle: "", location: coordinate)
                    annotations?.append(annotation)
                    DispatchQueue.main.async {
                        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(item.time), target: self, selector: #selector(self.removeAnnotation(sender:)), userInfo: ["annotation": annotation], repeats: false)
                    }
                }
            }
        }
        return annotations ?? []
    }
    
    @objc func removeAnnotation(sender: Timer) {
        let userInfo = sender.userInfo as! Dictionary<String, Any>
        let annotation: MKAnnotation = (userInfo["annotation"] as! MKAnnotation)
        DispatchQueue.main.async {
            self.mapView.removeAnnotation(annotation)
        }
    }
    
    func removeAllAnnotations() {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
    }
    
    func displayPosList(_ annotations: [MKAnnotation]) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
                self.mapView.showAnnotations(annotations, animated: true)
            }}
    }
    
}

extension MainViewController: PlacesModelDelegate {
    
    func didLoadPlacesData(_ data: [PlaceAnnotation]?, totalPlaces: Int) {
        if totalPlaces > 0 {
            self.totalPlaces = totalPlaces
        }
        self.places.append(contentsOf: data ?? [])
        offset = offset + placesLimit
        if offset < self.totalPlaces {
            if searchedText != "" {
                self.dataModel.loadPlacesDataWith(searchedText, limitBy: self.placesLimit, offsetBy: self.offset)
            } else {
                self.removeAllAnnotations()
            }
        }
        
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        offset = 0
        self.places.removeAll()
        removeAllAnnotations()
        searchedText = ""
        if let searchedText = searchBar.text {
            self.searchedText = searchedText
            self.dataModel.loadPlacesDataWith(searchedText, limitBy: placesLimit, offsetBy: offset)
        } else {
            removeAllAnnotations()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedText = searchBar.text ?? ""
        searchBar.endEditing(true)
    }
}

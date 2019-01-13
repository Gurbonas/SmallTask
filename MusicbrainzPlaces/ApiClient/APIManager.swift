//
//  APIManager.swift
//  MusicbrainzPlaces
//
//  Created by Gediminas Urbonas on 08/12/2018.
//  Copyright © 2018 Gediminas Urbonas. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

/// Construct url
func findRepositories(matching query: String,
                      limitBy limit: String, offsetBy offset: String) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "musicbrainz.org"
    components.path = "/ws/2/place/"
    components.queryItems = [
        URLQueryItem(name: "query", value: query),
        URLQueryItem(name: "offset", value: offset),
        URLQueryItem(name: "limit", value: limit),
        URLQueryItem(name: "fmt", value: "json")
    ]
    let url = components.url
    return url!
}

class APIManager {
    
    /// method to make api call
    static func request(_ url: URL,
                        then handler: @escaping (Result<Data>) -> Void) {
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url) {
            data, response, error in
            
            let result = data.map(Result.success) ?? .failure("Error" as! Error)
            handler(result)
        }
        
        task.resume()
    }
}

extension Result {
    func resolve() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

extension Result where Value == Data {
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        let data = try resolve()
        return try decoder.decode(T.self, from: data)
    }
}

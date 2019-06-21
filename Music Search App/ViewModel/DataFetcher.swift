//
//  DataFetcher.swift
//  Music Search App
//
//  Created by Allan Pagdanganan on 21/06/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import Foundation

class DataFetcher {
    func fetchItems(matching query: [String: String], completion: @escaping ([Track]?) -> Void) {
        
        let baseURL = URL(string: "https://itunes.apple.com/search?")!
        
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let tracks = try? jsonDecoder.decode(Tracks.self, from: data) {
                completion(tracks.results)
            } else {
                completion(nil)
                print("Either no data was returned, or data was not serialized.")
                return
            }
        }
        task.resume()
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}

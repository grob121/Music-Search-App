//
//  Track.swift
//  Music Search App
//
//  Created by Allan Pagdanganan on 21/06/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import Foundation

struct Track: Codable {
    var trackURL: URL
    var trackImageURL: URL
    var trackName: String
    var artistName: String
    var albumName: String
    
    enum CodingKeys: String, CodingKey {
        case trackURL = "previewUrl"
        case trackImageURL = "artworkUrl60"
        case trackName
        case artistName
        case albumName = "collectionName"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.trackURL = try valueContainer.decode(URL.self, forKey: CodingKeys.trackURL)
        self.trackImageURL = try valueContainer.decode(URL.self, forKey: CodingKeys.trackImageURL)
        self.trackName = (try? valueContainer.decode(String.self, forKey: CodingKeys.trackName)) ?? ""
        self.artistName = try valueContainer.decode(String.self, forKey: CodingKeys.artistName)
        self.albumName = try valueContainer.decode(String.self, forKey: CodingKeys.albumName)
    }
}


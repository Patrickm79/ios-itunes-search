//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Patrick Millet on 12/3/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    var title: String
    var creator: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case creator = "artistName"
    }
}

struct SearchResults: Codable {
    let results: [SearchResult]
}

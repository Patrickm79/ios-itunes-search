//
//  SearchResultController.swift
//  iTunesSearch
//
//  Created by Patrick Millet on 12/3/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import Foundation

class SearchResultController {
    let baseURL = URL(string: "https://itunes.apple.com/search")
    
    var searchResults: [SearchResult] = []
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    func searchResultsWith(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        guard let url = baseURL else { return }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let searchTermQueryItem = URLQueryItem(name: "term", value: searchTerm)
        let resultTypeQueryItem = URLQueryItem(name: "entity", value: resultType.rawValue)
        urlComponents?.queryItems = [resultTypeQueryItem, searchTermQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            print("Request URL is nil")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do{
                let resultsSearch = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = resultsSearch.results
                completion(nil)
            } catch{
                print("Unable to decode data into object of type [SearchResult] \(error)")
                completion(error)
            }
        }.resume()
        
    }
}

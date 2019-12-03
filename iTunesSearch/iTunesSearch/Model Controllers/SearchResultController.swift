//
//  SearchResultController.swift
//  iTunesSearch
//
//  Created by Patrick Millet on 12/3/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import Foundation

class SearchResultController {
    let baseURL = URL(string: "https://itunes.apple.com")!
    
    var searchResults: [SearchResult] = []
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    func searchResultsWith(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchTermQueryItem = URLQueryItem(name: "search", value: searchTerm)
        let resultTypeQuertItem = URLQueryItem(name: "resultType", value: resultType.rawValue)
        urlComponents?.queryItems = [searchTermQueryItem]
        urlComponents?.queryItems = [resultTypeQuertItem]
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
                return
            }
            
            guard let data = data else {
                print("No data returned from data task.")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do{
                let resultsSearch = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults.append(contentsOf: resultsSearch.results)
            } catch{
                print("Unable to decode data into object of type [SearchResult] \(error)")
                completion(error)
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
        
    }
}

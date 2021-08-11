//
//  ApiService.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation

class ApiService {
    private let urlSession = URLSession.shared
    
    func performPostRequest(longURL: String, completion: @escaping (TinyURL) -> Void) {
        let endpoint = URL(string: "http://tiny-url.info/api/v1/random")!
        let data = createParameters(longURL: longURL)
        var endpointRequest = URLRequest(url: endpoint)
        endpointRequest.httpMethod = "POST"
        endpointRequest.httpBody = data
        let task = urlSession.dataTask(with: endpointRequest) { data, _, error in
            if let error = error {
                print("Error with: \(error.localizedDescription)")
                return
            } else {
                guard let tinyData = data else { return }
                let tinyURLArray = ParsingService.parseFromJSON(tinyData: [tinyData])
                guard let tinyURL = tinyURLArray.first else { return }
                completion(tinyURL)
            }
        }
        task.resume()
    }
    
    private func createParameters(longURL urlParameter: String) -> Data {
        let formatParameter = "json"
        let parametersData = "format=\(formatParameter)&url=\(urlParameter)".data(using: .utf8)!
        return parametersData
    }
}

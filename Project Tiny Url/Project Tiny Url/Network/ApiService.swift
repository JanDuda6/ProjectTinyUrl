//
//  ApiService.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation

class ApiService {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let urlSession = URLSession.shared

    func performPostRequest(longURL: String, completion: @escaping (TinyURL) -> Void) {
        let endpoint = URL(string: "http://tiny-url.info/api/v1/random")!
        let data = parseToData(longURL: longURL)
        var endpointRequest = URLRequest(url: endpoint)
        endpointRequest.httpMethod = "POST"
        endpointRequest.httpBody = data
        let task = urlSession.dataTask(with: endpointRequest) { [self] data, urlResponse, error in
            if let error = error {
                print("Error with: \(error.localizedDescription)")
                return
            } else {
                guard let data = data else { return }
                let tinyURL = parseFromJSON(data: data)
                completion(tinyURL)
            }
        }
        task.resume()
    }

    private func parseToData(longURL: String) -> Data {
        let longURL = LongURLToSend(url: longURL)
        let data: Data = "format=\(longURL.format)&url=\(longURL.url)".data(using: .utf8)!
        return data
    }

    private func parseFromJSON(data: Data) -> TinyURL {
        return try! decoder.decode(TinyURL.self, from: data)
    }
}

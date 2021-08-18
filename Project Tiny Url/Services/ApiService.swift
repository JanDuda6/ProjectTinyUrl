//
//  ApiService.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation
import Alamofire

class ApiService {
    func requestShortUrl(longURL: String, completion: @escaping (TinyURL) -> Void) {
        let params = ["format": "json", "url": longURL]
        AF.request("http://tiny-url.info/api/v1/random", parameters: params).responseDecodable(of: TinyURL.self) { response in
            guard let tinyURL = response.value else { return }
            completion(tinyURL)
        }
    }
}

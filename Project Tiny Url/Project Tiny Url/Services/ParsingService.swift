//
//  ParsingService.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation

struct ParsingService {
    static func parseFromJSON(data: [Data]) -> [TinyURL] {
        var tinyURLArray = [TinyURL]()
        for data in data {
           let tinyURL = try! JSONDecoder().decode(TinyURL.self, from: data)
            tinyURLArray.append(tinyURL)
        }
        return tinyURLArray
    }

   static func parseToJSON(tinyURL: TinyURL) -> Data {
        return try! JSONEncoder().encode(tinyURL)
    }
}

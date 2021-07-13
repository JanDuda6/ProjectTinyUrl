//
//  TinyURL.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation

struct TinyURL: Codable {
    var state: String
    var shortURL: String
    var longURL: String

    enum CodingKeys: String, CodingKey {
        case shortURL = "shorturl"
        case longURL = "longurl"
        case state
    }
}

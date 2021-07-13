//
//  LongURLToSend.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation

struct LongURLToSend {
    var format: String
    var url: String

    init(url: String) {
        self.url = url
        self.format = "json"
    }
}

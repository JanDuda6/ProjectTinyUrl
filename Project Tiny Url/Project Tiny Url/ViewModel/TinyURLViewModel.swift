//
//  TinyURLViewModel.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation

class TinyURLViewModel {
    private let apiService = ApiService()
    private var longURL = ""
    private var tinyURL: TinyURL?

    func setLongURL(longURL: String) {
        self.longURL = longURL
    }

    func fetchDataFromApi() {}
}

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
    private var tinyURLArray = [TinyURL]()

    func setLongURL(longURL: String) {
        self.longURL = longURL
    }

    // fetching data from api, saving response and loading old responses
    func fetchDataFromApi(completion: @escaping () -> Void) {
        apiService.performPostRequest(longURL: longURL) { [self] tinyURL in
            if tinyURL.shortURL != "" {
                saveTinyURL(tinyURL: tinyURL)
                loadTinyURL {
                    completion()
                }
            }
        }
    }

    // saving response in User Defaults
    func saveTinyURL(tinyURL: TinyURL) {
        var tinyURLDataArray = [Data]()
        tinyURLArray.append(tinyURL)
        for tinyURL in tinyURLArray {
            let tinyURLData = ParsingService.parseToJSON(tinyURL: tinyURL)
            tinyURLDataArray.append(tinyURLData)
        }
        UserDefaults.standard.setValue(tinyURLDataArray, forKey: "tinyData")
    }

    // loading response from User Defaults
    func loadTinyURL(completion: @escaping () -> Void) {
        if let tinyData = UserDefaults.standard.array(forKey: "tinyData") as? Array<Data> {
            self.tinyURLArray = ParsingService.parseFromJSON(data: tinyData)
        }
        completion()
    }

    func getTinyURLArray() -> [TinyURL] {
        return tinyURLArray
    }
}

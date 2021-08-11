//
//  TinyURLViewModel.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation

class TinyURLViewModel {
    private let apiService = ApiService()
    private(set) var tinyURLArray = [TinyURL]()

    // fetching data from api, saving response and loading old responses
    func getShortUrl(with longURL: String, completion: @escaping () -> Void) {
        apiService.requestShortUrl(longURL: longURL) { [weak self] tinyURL in
            // doesn't save result with no shortURL variable
            if tinyURL.shortURL != "" {
                self?.saveTinyURL(tinyURL: tinyURL)
                completion()
            }
        }
    }

    // saving response in User Defaults
    private func saveTinyURL(tinyURL: TinyURL) {
        var tinyURLDataArray = [Data]()
        self.tinyURLArray.append(tinyURL)
        for tinyURL in self.tinyURLArray {
            let tinyURLData = ParsingService.parseToJSON(tinyURL: tinyURL)
            tinyURLDataArray.append(tinyURLData)
        }
        UserDefaults.standard.setValue(tinyURLDataArray, forKey: "tinyData")
    }

    // loading response from User Defaults
    func loadTinyURL(completion: @escaping () -> Void) {
        if let tinyData = UserDefaults.standard.array(forKey: "tinyData") as? Array<Data> {
            self.tinyURLArray = ParsingService.parseFromJSON(tinyData: tinyData)
        }
        completion()
    }
}

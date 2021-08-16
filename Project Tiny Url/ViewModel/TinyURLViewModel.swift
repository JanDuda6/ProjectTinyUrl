//
//  TinyURLViewModel.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation
import RxSwift

class TinyURLViewModel {
    private let apiService = ApiService()
    private(set) var urls = BehaviorSubject<[TinyURL]>(value: [])
    
    // fetching data from api, saving response
    func getShortUrl(with longURL: String) {
        apiService.requestShortUrl(longURL: longURL) { [weak self] tinyURL in
            // doesn't save result with no shortURL variable
            if tinyURL.shortURL != "" {
                self?.saveTinyURL(tinyURL: tinyURL)
            }
        }
    }
    
    // saving response in User Defaults
    func saveTinyURL(tinyURL: TinyURL) {
        var tinyURLArray = try! urls.value()
        tinyURLArray.append(tinyURL)
        var tinyURLDataArray = [Data]()
        tinyURLArray.reverse()
        tinyURLArray.forEach({ tinyURL in
            let tinyURLData = ParsingService.parseToJSON(tinyURL: tinyURL)
            tinyURLDataArray.append(tinyURLData)
        })
        urls.onNext(tinyURLArray)
        UserDefaults.standard.setValue(tinyURLDataArray, forKey: "tinyData")
    }
    
    // loading response from User Defaults
    func loadTinyURL() {
        if let tinyData = UserDefaults.standard.array(forKey: "tinyData") as? Array<Data> {
            urls.onNext(ParsingService.parseFromJSON(tinyData: tinyData))
        }
    }
}

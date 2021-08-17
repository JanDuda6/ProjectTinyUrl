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
    private(set) var urlIsInArray = PublishSubject<Bool>()

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
   private func saveTinyURL(tinyURL: TinyURL) {
        var tinyURLArray = try! urls.value()
        if tinyURLArray.contains(where: { $0.shortURL.lowercased() == tinyURL.shortURL.lowercased() }) {
            urlIsInArray.onNext(true)
            return
        }
        tinyURLArray.append(tinyURL)
        tinyURLArray.reverse()
        let tinyURLDataArray = tinyURLArray.map(ParsingService.parseToJSON(tinyURL:))
        urls.onNext(tinyURLArray)
        UserDefaults.standard.setValue(tinyURLDataArray, forKey: EnumUserDefaults.tinyData.rawValue)
    }
    
    // loading response from User Defaults
    func loadTinyURL() {
        if let tinyData = UserDefaults.standard.array(forKey: EnumUserDefaults.tinyData.rawValue) as? Array<Data> {
            urls.onNext(ParsingService.parseFromJSON(tinyData: tinyData))
        }
    }
}

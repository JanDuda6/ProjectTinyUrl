//
//  TinyURLViewModel.swift
//  Project Tiny Url
//
//  Created by Kurs on 13/07/2021.
//

import Foundation
import RxSwift

class TinyURLViewModel {
    private let apiService: ApiService
    private(set) var urls: BehaviorSubject<[TinyURL]>

    init(apiService: ApiService = ApiService(), urls: BehaviorSubject<[TinyURL]> = BehaviorSubject<[TinyURL]>(value: []) ) {
        self.apiService = apiService
        self.urls = urls
    }

    // fetching data from api, saving response
    func getShortUrl(with longURL: String, completion: @escaping (EnumValidation) -> Void) {
        if validation(longURL: longURL) == true {
            apiService.requestShortUrl(longURL: longURL) { [weak self] tinyURL in
                completion((self?.saveTinyURL(tinyURL: tinyURL))!)
            }
        } else {
            completion(.validationFailed)
        }
    }

   private func validation(longURL: String) -> Bool {
        let regex = "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
        let longURLPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return longURLPredicate.evaluate(with: longURL)
    }
    
    // saving response in User Defaults
    private func saveTinyURL(tinyURL: TinyURL) -> EnumValidation {
        var tinyURLArray = try! urls.value()
        if tinyURLArray.contains(where: { $0.longURL.lowercased() == tinyURL.longURL.lowercased() }) {
            return .alreadyDefined
        }
        tinyURLArray.insert(tinyURL, at: 0)
        let tinyURLDataArray = tinyURLArray.map(ParsingService.parseToJSON(tinyURL:))
        urls.onNext(tinyURLArray)
        UserDefaults.standard.setValue(tinyURLDataArray, forKey: EnumUserDefaults.tinyData.rawValue)
        return .isValid
    }
    
    // loading response from User Defaults
    func loadTinyURL() {
        if let tinyData = UserDefaults.standard.array(forKey: EnumUserDefaults.tinyData.rawValue) as? Array<Data> {
            urls.onNext(ParsingService.parseFromJSON(tinyData: tinyData))
        }
    }

    func sortingAlgorithm<T: Comparable>(randomNumbers: [T]) -> [T] {
        var randomNumbers = randomNumbers
        var counter = 0
        for i in randomNumbers {
            counter = randomNumbers.firstIndex(of: i)!
            while counter < randomNumbers.count - 1 {
                if i > randomNumbers[counter + 1] {
                    randomNumbers[randomNumbers.firstIndex(of: i)!] = randomNumbers[counter + 1]
                    randomNumbers[counter + 1] = i
                }
                counter += 1
            }
        }
        return randomNumbers
    }
}

//
//  MockApiService.swift
//  Project Tiny UrlTests
//
//  Created by Kurs on 02/09/2021.
//

import XCTest
@testable import Project_Tiny_Url

class MockApiService: ApiService {
    let mockTinyUrl = TinyURL(shortURL: "http://tw.gs/Y2r8awk", longURL: "https://foo.pl")

    override func requestShortUrl(longURL: String, completion: @escaping (TinyURL) -> Void) {
        completion(mockTinyUrl)
    }
}

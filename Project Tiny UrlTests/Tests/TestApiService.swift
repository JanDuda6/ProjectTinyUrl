//
//  TestApiService.swift
//  Project Tiny UrlTests
//
//  Created by Kurs on 03/09/2021.
//
import XCTest
@testable import Project_Tiny_Url

class TestApiService: XCTestCase {
    var sut: ApiService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ApiService()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testRequestShortUrl() {
        let tinyUrl = TinyURL(shortURL: "http://tw.gs/Y2r8awk", longURL: "https://foo.pl")
        let correctUrl = "https://foo.pl"
        var savedTinyUrl: TinyURL!
        let expectation = expectation(description: "callback")

        sut.requestShortUrl(longURL: correctUrl) { tinyUrl in
            savedTinyUrl = tinyUrl
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(tinyUrl.longURL, savedTinyUrl.longURL)
        XCTAssertEqual(tinyUrl.shortURL, savedTinyUrl.shortURL)
    }
}

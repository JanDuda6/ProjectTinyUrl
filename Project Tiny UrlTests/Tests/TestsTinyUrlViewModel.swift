//
//  TestsTinyUrlViewModel.swift
//  Project Tiny UrlTests
//
//  Created by Kurs on 02/09/2021.
//
import RxSwift
import XCTest
@testable import Project_Tiny_Url

class TestsTinyURLViewModel: XCTestCase {
    var sut: TinyURLViewModel!
    var mockApiService: MockApiService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApiService = MockApiService()
        sut = TinyURLViewModel(apiService: mockApiService)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockApiService = nil
        try super.tearDownWithError()
    }

    func testSortingAlgorithm() {
        let repeatingNumbers = [3, 5, 6, 6, 1, 3]
        let oneNumber = [1]
        let withNegativeNumbers = [-3, 5, -1, 4]
        let emptyArray = [Int]()
        let randomNumbers = [-1, 3, 0.9, 0.2, -0.1]

        let repeatingNumbersTest = sut.sortingAlgorithm(randomNumbers: repeatingNumbers)
        let oneNumberTest = sut.sortingAlgorithm(randomNumbers: oneNumber)
        let withNegativeNumbersTest = sut.sortingAlgorithm(randomNumbers: withNegativeNumbers)
        let emptyArrayTest = sut.sortingAlgorithm(randomNumbers: emptyArray)
        let randomNumbersTest = sut.sortingAlgorithm(randomNumbers: randomNumbers)

        XCTAssertEqual(repeatingNumbersTest, [1, 3, 3, 5, 6, 6])
        XCTAssertEqual(oneNumberTest, [1])
        XCTAssertEqual(withNegativeNumbersTest, [-3, -1, 4, 5])
        XCTAssertEqual(emptyArrayTest, [])
        XCTAssertEqual(randomNumbersTest, [-1, -0.1, 0.2, 0.9, 3])
    }

    func testGetShortUrlValidation() {
        let correctUrl = "https://foo.pl"
        let wwwUrl = "www.foo.pl"
        let urlWithoutSuffix = "https://foo."
        let onlyHostUrl = "foo.pl"
        let expectation = XCTestExpectation(description: "callback")
        var callbackResult: EnumValidation!

        sut.getShortUrl(with: wwwUrl) { result in
            callbackResult = result
            expectation.fulfill()
        }

        XCTAssertEqual(callbackResult, .validationFailed)

        sut.getShortUrl(with: correctUrl) { result in
            callbackResult = result
            expectation.fulfill()
        }

        XCTAssertEqual(callbackResult, .isValid)

        sut.getShortUrl(with: urlWithoutSuffix) { result in
            callbackResult = result
            expectation.fulfill()
        }

        XCTAssertEqual(callbackResult, .validationFailed)

        sut.getShortUrl(with: onlyHostUrl) { result in
            callbackResult = result
            expectation.fulfill()
        }

        XCTAssertEqual(callbackResult, .validationFailed)
    }

    func testGetShortUrlSaveTinyURL() {
        // check if the same tinyUrl objects can be saved
        let tinyUrl = TinyURL(shortURL: "http://tw.gs/Y2r8awk", longURL: "https://foo.pl")
        let urlsArray = BehaviorSubject<[TinyURL]>(value: [tinyUrl])
        let correctUrl = "https://foo.pl"
        let expectation = XCTestExpectation(description: "callback")
        var callbackResult: EnumValidation!
        sut = TinyURLViewModel(apiService: mockApiService, urls: urlsArray)

        sut.getShortUrl(with: correctUrl) { result in
            callbackResult = result
            expectation.fulfill()
        }

        XCTAssertEqual(callbackResult, .alreadyDefined)

        //check if mockTinyUrl will be saved in empty array
        var savedTinyUrl: TinyURL!
        sut = TinyURLViewModel(apiService: mockApiService)

        sut.getShortUrl(with: correctUrl) { result in
            callbackResult = result
            expectation.fulfill()
        }

        sut.urls.bind { tinyUrls in
            savedTinyUrl = tinyUrls.first
        }.dispose()

        XCTAssertEqual(callbackResult, .isValid)
        XCTAssertEqual(savedTinyUrl?.shortURL, tinyUrl.shortURL)
        XCTAssertEqual(savedTinyUrl?.longURL, tinyUrl.longURL)
    }

    func testLoadTinyUrl() {
        let tinyUrl = TinyURL(shortURL: "http://tw.gs/Y2r8awk", longURL: "https://foo.pl")
        var loadFromUserDefaults: TinyURL!
        let correctUrl = "https://foo.pl"

        // save tinyUrl in UserDefaults
        sut.getShortUrl(with: correctUrl) { _ in }

        // load from UserDefaults
        sut.loadTinyURL()

        sut.urls.bind { tinyUrls in
            loadFromUserDefaults = tinyUrls.first
        }.dispose()

        XCTAssertEqual(loadFromUserDefaults?.shortURL, tinyUrl.shortURL)
        XCTAssertEqual(loadFromUserDefaults?.longURL, tinyUrl.longURL)
    }
}

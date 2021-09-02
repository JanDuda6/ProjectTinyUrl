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
        let wwwUrl = "www.foo.pl"
        let urlWithoutSuffix = "https://foo."
        let onlyHostUrl = "foo.pl"
        let incorrectUrl = "httsp//:ww.foo.pl"

        sut.getShortUrl(with: wwwUrl, completion: { XCTAssertEqual($0, .validationFailed)})
        sut.getShortUrl(with: urlWithoutSuffix, completion: { XCTAssertEqual($0, .validationFailed)})
        sut.getShortUrl(with: onlyHostUrl, completion: { XCTAssertEqual($0, .validationFailed)})
        sut.getShortUrl(with: incorrectUrl, completion: { XCTAssertEqual($0, .validationFailed)})
    }

    func testGetShortUrlSaveTinyURL() {
        // check if the same tinyUrl objects can be saved
        let tinyUrl = TinyURL(shortURL: "http://tw.gs/Y2r8awk", longURL: "https://foo.pl")
        let urlsArray = BehaviorSubject<[TinyURL]>(value: [tinyUrl])
        let emptyUrl = "https://foo.pl"
        sut = TinyURLViewModel(apiService: mockApiService, urls: urlsArray)
        sut.getShortUrl(with: emptyUrl, completion: { XCTAssertEqual($0, .alreadyDefined) })

        //check if mockTinyUrl will be saved in empty array
        let emptyArray = BehaviorSubject<[TinyURL]>(value: [])
        sut = TinyURLViewModel(apiService: mockApiService, urls: emptyArray)
        sut.getShortUrl(with: emptyUrl, completion: { XCTAssertEqual($0, .isValid) })
    }
}

//
//  Project_Tiny_UrlUITests.swift
//  Project Tiny UrlUITests
//
//  Created by Kurs on 03/09/2021.
//

import XCTest

class ProjectTinyUrlUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
      try super.setUpWithError()
      app = XCUIApplication()
      app.launch()
    }

    func testNewCellInTableViewAdded() {
        let url = "https://foo.pl"
        let urlTextField = app.textFields["URL"]
        urlTextField.tap()
        urlTextField.typeText(url)
        app.buttons["Make it Tiny!"].tap()
        let newCell = app.tables.staticTexts[url]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: newCell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(newCell.exists)
    }

    func testWrongSyntaxError() {
        let inValidUrl = ""
        let urlTextField = app.textFields["URL"]
        let errorLabel = app.staticTexts["URL syntax invalid"]
        urlTextField.tap()
        urlTextField.typeText(inValidUrl)
        app.buttons["Make it Tiny!"].tap()
        XCTAssertTrue(errorLabel.exists)
    }

    func testSameUrlEnteredError() {
        let sameUrl = "https://foo.pl"
        let urlTextField = app.textFields["URL"]
        let errorLabel = app.staticTexts["You shorted this URL  before"]
        urlTextField.tap()
        urlTextField.typeText(sameUrl)
        app.buttons["Make it Tiny!"].tap()
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: errorLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(errorLabel.exists)
    }

    func testAlertShown() {
        let url = "https://foo.pl"
        let urlTextField = app.textFields["URL"]
        urlTextField.tap()
        urlTextField.typeText(url)
        app.buttons["Make it Tiny!"].tap()

        let cell = app.tables.staticTexts["https://foo.pl"]
        cell.tap()
        let alertText = app.staticTexts["Tiny URL copied to clipboard!"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: alertText, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(alertText.exists)
    }
}

//
//  Project_Tiny_UrlUITests.swift
//  Project Tiny UrlUITests
//
//  Created by Kurs on 03/09/2021.
//

import XCTest

class Project_Tiny_UrlUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
      try super.setUpWithError()
      continueAfterFailure = false

      app = XCUIApplication()
      app.launch()
    }
}

//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Joanna Lingenfelter on 3/7/22.
//

import XCTest

class UltimatePortfolioUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppHas4Tabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
    }

    func testOpenTabAddsProjects() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1...5 {
            app.buttons["Add Project"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) list row(s).")
        }
    }

    func testAddItemsInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding an item.")
    }

    func testEditingProjectUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")
        XCTAssertTrue(app.tables.otherElements
                        .children(matching: .other)
                        .children(matching: .other)
                        .children(matching: .staticText)["New Project"].exists,
                      "There should be a project called New Project")

        app.buttons["Compose"].tap()
        app.textFields["Project name"].tap()

        app.keyboards.keys["space"].tap()
        app.keyboards.keys["more"].tap()
        app.keyboards.keys["2"].tap()
        app.keyboards.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.tables.otherElements
                        .children(matching: .other)
                        .children(matching: .other)
                        .children(matching: .staticText)["New Project 2"].exists,
                      "There should be a project called New Project 2")
    }

    func testEditingItemUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding an item.")

        app.buttons["New Item"].tap()
        app.textFields["Item name"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.buttons["New Item 2"].exists, "New Item 2 should be visible in the list.")
    }

    func testTappingAllAlertsShowsLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()

            XCTAssertTrue(app.alerts["Locked"].exists,
                          "There should be a locked alert showing for all awards.")
            app.buttons["OK"].tap()
        }
    }
}

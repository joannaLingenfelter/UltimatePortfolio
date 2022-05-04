//
//  AssetTests.swift
//  UltimatePortfolioTests
//
//  Created by Joanna Lingenfelter on 3/1/22.
//

import XCTest
@testable import UltimatePortfolio

class AssetTests: XCTestCase {
    func test_project_contains_all_colors_specified_in_the_projects_extension() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color: \(color) from asset catalog.")
        }
    }

    func test_loading_awards_json_correctly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from json.")
    }
}

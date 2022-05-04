//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by Joanna Lingenfelter on 3/2/22.
//

import XCTest
import SwiftUI
@testable import UltimatePortfolio

class ExtensionTests: XCTestCase {
    func test_sequence_key_path_sorting_default_functionality() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self)

        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5],
                       "The sorted numbers must be ascending.")
    }

    func test_sequence_key_path_sorting_with_custom_comparator() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self, using: >)

        XCTAssertEqual(sortedItems, [5, 4, 3, 2, 1],
                       "The sorted numbers should be descending.")
    }

    func test_decoding_awards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty,
                       "Awards.json should decode to a non-empty array.")
    }

    func test_decoding_string() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data,
                       "The rain in Spain falls mainly on Spaniards.",
                       "The string must match the contents of DecodableString.json")
    }

    func test_decoding_dictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        let dictionary = [
            "One": 1,
            "Two": 2,
            "Three": 3
        ]

        XCTAssertEqual(data, dictionary,
                       "The dictionary must match the contents of DecodableDictionary.json")
    }

    func test_binding_calls_function_on_change() {
        // Given an example binding
        var onChangeFunctionRun = false

        func exampleFunction() {
            onChangeFunctionRun = true
        }

        var storedValue = ""
        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )

        let changedBinding = binding.onChange(exampleFunction)

        // When the value inside of the binding is changed
        changedBinding.wrappedValue = "Test"

        // The example function is called
        XCTAssertTrue(onChangeFunctionRun,
                      "The onChange() function must be run when the binding is changed.")
    }
}

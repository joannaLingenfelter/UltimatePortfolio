//
//  AwardsTests.swift
//  UltimatePortfolioTests
//
//  Created by Joanna Lingenfelter on 3/1/22.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

class AwardsTests: BaseTestCase {
    let awards = Award.allAwards

    func test_award_name_and_id_are_equal() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award id should always be equal to its name.")
        }
    }

    func test_new_users_have_not_earned_any_awards() {
        for award in awards {
            let hasEarned = dataController.hasEarned(award: award)
            XCTAssertFalse(hasEarned, "New users have not earned any awards yet.")
        }
    }

    func test_awards_for_adding_items_are_earned_at_correct_intervals() {
        let awardsEarnedForAddingItems = awards.filter { $0.criterion == "items" }
        let values = awardsEarnedForAddingItems.map { $0.value }.sorted { $0 < $1 }

        for (index, value) in values.enumerated() {
            for _ in 0..<value {
                _ = Item(context: managedObjectContext)
            }

            // The correct number of items has been inserted to make the award earned.
            // The number of awards that should have been earned is equal to the
            // index of the current place of the values enumeration  + 1.
            // To determine whether or not the user has earned the correct number of awards
            // this index + 1 value should be compared to the number of awards that the dataController
            // understands the user to have unlocked.
            let awardsThatShouldBeEarned = index + 1
            let awardsEarned = awards.filter { dataController.hasEarned(award: $0) }.count
            XCTAssertTrue(awardsThatShouldBeEarned == awardsEarned,
                          "Adding \(value) items should unlock \(awardsThatShouldBeEarned) awards.")

            dataController.deleteAll()
        }
    }

    func test_awards_for_completing_items_are_earned_at_correct_intervals() {
        let awardsEarnedForItemCompletion = awards.filter { $0.criterion == "complete" }
        let values = awardsEarnedForItemCompletion.map { $0.value }.sorted { $0 < $1 }

        for (index, value) in values.enumerated() {
            for _ in 0..<value {
                let item = Item(context: managedObjectContext)
                item.completed = true
            }

            // The correct number of items has been inserted to make the award earned.
            // The number of awards that should have been earned is equal to the
            // index of the current place of the values enumeration  + 1.
            // To determine whether or not the user has earned the correct number of awards
            // this index + 1 value should be compared to the number of awards that the dataController
            // understands the user to have completed.
            let awardsThatShouldBeEarned = index + 1
            let awardsEarned = awardsEarnedForItemCompletion.filter { dataController.hasEarned(award: $0) }.count
            XCTAssertTrue(awardsThatShouldBeEarned == awardsEarned,
                          "Adding \(value) items should unlock \(awardsThatShouldBeEarned) awards.")

            dataController.deleteAll()
        }
    }
}

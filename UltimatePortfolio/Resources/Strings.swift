//
//  Strings.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/25/22.
//

import SwiftUI

enum Strings: String {
    /* GENERAL */
    case delete
    case ok

//////////////////////////////

    /* TAB BAR */
    case home
    case `open`
    case closed
    case awards

//////////////////////////////

    /* HOME SCREEN */
    case upNext
    case moreToExplore
    case summaryStatus

//////////////////////////////

    /* PROJECTS SCREEN */
    case openProjects
    case closedProjects
    case addProject
    case addNewItem
    case completionPercentage
    case highPriority

    // DEFAULT ITEM NAMES
    case newItem
    case newProject

    // SORT BUTTON
    case sort
    case sortItems
    case optimized
    case title
    case creationDate

//////////////////////////////

    /* AWARDS SCREEN */
    case locked
    case unlocked

//////////////////////////////

    /* EDIT ITEM SCREEN */
    case markCompleted
    case editItem
    case description
    case itemName
    case priority
    case low
    case medium
    case high

//////////////////////////////

    /*  EDIT PROJECT SCREEN */
    case editProject
    case projectName
    case projectDescriptionPlaceHolder
    case customProjectColor
    case closeProjectButtonTitle
    case reopenProject
    case deleteProjectButtonTitle
    case deleteProjectAlertTitle
    case deleteProjectAlertMessage
    case closeOrDeleteActionDescription

    // COLORS
    case selectAColor
    case pink
    case purple
    case red
    case orange
    case gold
    case green
    case teal
    case lightBlue
    case darkBlue
    case midnight
    case darkGray
    case gray

//////////////////////////////

    /* REMINDERS */
    case projectReminders
    case showReminders
    case oops
    case checkAppSettingsErrorMessage
    case checkSettingsErrorTitle
    case reminderTime

//////////////////////////////

    /* MISCELANEOUS */
    case basicSettings
    case selectSomethingToBegin
    case nothingHereRightNow

//////////////////////////////

    var key: LocalizedStringKey {
        return LocalizedStringKey(stringLiteral: self.rawValue)
    }

    var keyStringValue: String {
        return self.rawValue
    }

    var value: String {
        return self.rawValue.localized()
    }
}

//
//  String-Localized.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/28/22.
//

import Foundation
import SwiftUI

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

//
//  ItemRowViewModel.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 3/9/22.
//

import Foundation

extension ItemRowView {
    class ViewModel: ObservableObject {
        let project: Project
        let item: Item

        var title: String {
            item.itemTitle
        }

        init(project: Project, item: Item) {
            self.project = project
            self.item = item
        }

        var icon: String {
            if item.completed {
                return "checkmark.circle"
            } else if item.priority == 3 {
                return "exclamationmark.triangle"
            } else {
                return "checkmark.circle"
            }
        }

        var iconColor: String? {
            if item.completed {
                return project.projectColor
            } else if item.priority == 3 {
                return project.projectColor
            } else {
                return nil
            }
        }

        var label: String {
            if item.completed {
                return String(format: Strings.highPriority.keyStringValue, item.itemTitle).localized()
            } else if item.priority == 3 {
                return String(format: Strings.highPriority.keyStringValue, item.itemTitle).localized()
            } else {
                return item.itemTitle
            }
        }
    }
}

//
//  Item-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/8/22.
//

import Foundation

extension Item {
    enum SortOrder {
        case optimized
        case title
        case creationDate
    }

    var itemTitle: String {
        title ?? Strings.newItem.keyStringValue.localized()
    }

    var itemDetail: String {
        detail ?? ""
    }

    var itemCreationDate: Date {
        createdDate ?? Date()
    }

    static var example: Item {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let item = Item(context: viewContext)
        item.title = "Example"
        item.detail = "This is an example item"
        item.priority = 3
        item.createdDate = Date()
        return item
    }
}

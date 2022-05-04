//
//  ItemRowView.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/9/22.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var item: Item
    @StateObject var viewModel: ViewModel

    init(project: Project, item: Item) {
        let viewModel = ViewModel(project: project, item: item)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.item = item
    }

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.iconColor.map { Color($0) } ?? .clear)
            }
        }
        .accessibilityLabel(viewModel.label)
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}

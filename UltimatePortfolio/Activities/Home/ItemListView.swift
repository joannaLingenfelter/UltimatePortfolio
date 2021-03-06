//
//  ItemListView.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/24/22.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    let items: ArraySlice<Item>

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)

                        detailView(for: item)
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                }
            }
        }
    }

    func detailView(for item: Item) -> some View {
        VStack(alignment: .leading) {
            Text(item.itemTitle)
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if item.itemDetail.isEmpty == false {
                Text(item.itemDetail)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(title: "Test Title",
                     items: HomeView.ViewModel.previewHomeItems)
    }
}

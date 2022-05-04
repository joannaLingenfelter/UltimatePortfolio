//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/8/22.
//

import SwiftUI
import CoreData
import CoreSpotlight

struct HomeView: View {
    static var tag: String? = "Home"

    @StateObject var viewModel: ViewModel

    var projectRows: [GridItem] {
        return [GridItem(.fixed(100))]
    }

    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: ViewModel(dataController: dataController))

    }

    var body: some View {
        NavigationView {
            ScrollView {
                if let item = viewModel.selectedItem {
                    NavigationLink(
                        destination: EditItemView(item: item),
                        tag: item,
                        selection: $viewModel.selectedItem,
                        label: EmptyView.init
                    )
                    .id(item)
                }

                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects, content: ProjectSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        ItemListView(title: Strings.upNext.key,
                                     items: viewModel.upNext)
                        ItemListView(title: Strings.moreToExplore.key,
                                     items: viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle(Strings.home.key)
            .toolbar {
                Button("Add Data") {
                    viewModel.addSampleData()
                }
            }
            .onContinueUserActivity(CSSearchableItemActionType,
                                    perform: loadSpotlightItem)
        }
    }

    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            viewModel.selectItem(with: identifier)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}

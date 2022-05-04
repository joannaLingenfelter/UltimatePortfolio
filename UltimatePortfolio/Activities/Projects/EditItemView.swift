//
//  EditItemView.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/9/22.
//

import SwiftUI

struct EditItemView: View {
    let item: Item

    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var isCompleted: Bool

    init(item: Item) {
        self.item = item

        // @State (or any project wrapper) is just a simple struct!
        // Putting a string into a property wrapper before the property
        // wrapper has been created!
        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _isCompleted = State(wrappedValue: item.completed)
    }

    var body: some View {
        Form {
            Section(header: Text(Strings.basicSettings.key)) {
                TextField(Strings.itemName.key, text: $title.onChange(update))
                TextField(Strings.description.key, text: $detail.onChange(update))
            }

            Section(header: Text(Strings.priority.key)) {
                Picker(Strings.priority.key, selection: $priority.onChange(update)) {
                    Text(Strings.low.key).tag(1)
                    Text(Strings.medium.key).tag(2)
                    Text(Strings.high.key).tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle(Strings.markCompleted.key, isOn: $isCompleted.onChange(update))
            }
        }
        .navigationTitle(Strings.editItem.key)
        .onDisappear {
            dataController.update(item: item)
        }
    }

    func update() {
        item.project?.objectWillChange.send()

        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = isCompleted
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}

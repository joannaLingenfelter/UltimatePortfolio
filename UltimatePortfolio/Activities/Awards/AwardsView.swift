//
//  AwardsView.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/21/22.
//

import SwiftUI

struct AwardsView: View {
    static let tag: String? = "Awards"

    @EnvironmentObject var dataController: DataController
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(color(for: award))
                        }
                        .accessibilityLabel(label(for: award))
                        .accessibilityHint(Text(award.description))
                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(isPresented: $showingAwardDetails) {
            alert(for: selectedAward)
        }
    }

    func alert(for award: Award) -> Alert {
        if dataController.hasEarned(award: award) {
            return Alert(title: Text("Unlocked: \(selectedAward.name)"),
                         message: Text(selectedAward.description),
                         dismissButton: .default(Text(Strings.ok.key)))
        } else {
            return Alert(title: Text("Locked"),
                         message: Text(selectedAward.description),
                         dismissButton: .default(Text(Strings.ok.key)))
        }
    }

    func color(for award: Award) -> Color {
        let awardColor = Color(award.color)
        let lockedColor = Color.secondary.opacity(0.5)

        return dataController.hasEarned(award: award) ? awardColor : lockedColor
    }

    func label(for award: Award) -> Text {
        let unlocked = Strings.unlocked.key
        let locked = Strings.locked.key

        return Text(dataController.hasEarned(award: award) ? unlocked : locked)
    }
}

struct AwardsView_Previews: PreviewProvider {
    static let dataController: DataController = DataController.preview

    static var previews: some View {
        AwardsView()
            .environmentObject(dataController)
    }
}

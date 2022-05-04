//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/10/22.
//

import SwiftUI
import CoreHaptics

struct EditProjectView: View {
    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    @State private var engine = try? CHHapticEngine()
    @State private var remindMe: Bool
    @State private var reminderTime: Date
    @State private var showingNotificationsError = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _remindMe = State(wrappedValue: true)
            _reminderTime = State(wrappedValue: projectReminderTime)
        } else {
            _remindMe = State(wrappedValue: false)
            _reminderTime = State(wrappedValue: Date())
        }
    }

    var body: some View {
        Form {
            Section(header: Text(Strings.basicSettings.key)) {
                TextField(Strings.projectName.key, text: $title.onChange(update))
                TextField(Strings.description.key, text: $detail.onChange(update))
            }

            Section(header: Text(Strings.customProjectColor.key)) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }

            Section(header: Text(Strings.projectReminders.key)) {
                Toggle(Strings.showReminders.key,
                       isOn: $remindMe.animation().onChange {
                    update()
                })
                    .alert(isPresented: $showingNotificationsError) {
                        Alert(title: Text(Strings.oops.key),
                              message: Text(Strings.checkAppSettingsErrorMessage.key),
                              primaryButton: .default(Text(Strings.checkSettingsErrorTitle.key),
                                                      action: showAppSettings),
                              secondaryButton: .cancel())
                    }

                if remindMe {
                    DatePicker(Strings.reminderTime.key,
                               selection: $reminderTime.onChange {
                        update()
                    },
                               displayedComponents: .hourAndMinute)
                }
            }

            Section(footer: Text(Strings.closeOrDeleteActionDescription.key)) {
                Button(
                    project.closed ? Strings.reopenProject.key : Strings.closeProjectButtonTitle.key,
                    action: toggleClosed
                )

                Button(Strings.deleteProjectButtonTitle.key) {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle(Strings.editProject.key)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text(Strings.deleteProjectAlertTitle.key),
                  message: Text(Strings.deleteProjectAlertMessage.key),
                  primaryButton: .default(Text(Strings.delete.key), action: delete),
                  secondaryButton: .cancel())
        }
        .onDisappear {
            dataController.save()
        }
    }

    private func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color ?
            [.isButton, .isSelected] : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func toggleClosed() {
        project.closed.toggle()

        if project.closed {
            // UINotificationFeedbackGenerator().notificationOccurred(.success)

            guard let engine = engine else {
                return
            }

            do {
                try engine.start()

                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                       value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                       value: 1)

                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0,
                                                                value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1,
                                                              value: 0)

                let curve = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )

                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )

                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [intensity, sharpness],
                    relativeTime: 0.125,
                    duration: 1
                )

                let pattern = try CHHapticPattern(
                    events: [event1, event2],
                    parameterCurves: [curve]
                )

                let player = try engine.makePlayer(with: pattern)
                try player.start(atTime: 0)
            } catch {
                print("Playing haptics didn't work!")
            }
        }

        update()
    }

    func update() {
        project.objectWillChange.send()

        project.title = title
        project.detail = detail
        project.color = color

        if remindMe {
            project.reminderTime = reminderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false
                    showingNotificationsError = true
                }
            }
        } else {
            project.reminderTime = nil
            dataController.removeReminders(for: project)
        }
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}

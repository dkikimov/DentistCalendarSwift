//
//  EventCalendarChooserView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 28.11.2020.
//

import SwiftUI
import EventKitUI

struct EventCalendarChooserView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var calendars: Set<EKCalendar>?

    let eventStore: EKEventStore
    var fetchEvents: () -> Void
    func makeUIViewController(context: UIViewControllerRepresentableContext<EventCalendarChooserView>) -> UINavigationController {
        let chooser = EKCalendarChooser(selectionStyle: .multiple, displayStyle: .allCalendars, entityType: .event, eventStore: eventStore)
        chooser.selectedCalendars = calendars ?? []
        chooser.delegate = context.coordinator
        chooser.showsDoneButton = true
        chooser.showsCancelButton = true
        return UINavigationController(rootViewController: chooser)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<EventCalendarChooserView>) {

    }

    class Coordinator: NSObject, UINavigationControllerDelegate, EKCalendarChooserDelegate {
        let parent: EventCalendarChooserView

        init(_ parent: EventCalendarChooserView) {
            self.parent = parent
        } 

        func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
            parent.calendars = calendarChooser.selectedCalendars
            parent.fetchEvents()
            parent.presentationMode.wrappedValue.dismiss()
        }

        func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct EventCalendarChooserView: View{
//    @Environment(\.presentationMode) var presentationMode
//    @Binding var calendars: Set<EKCalendar>?
//
//    let eventStore: EKEventStore
//    var fetchEvents: () -> Void
//    var body: some View {
//        Text("Hi")
//    }
//}

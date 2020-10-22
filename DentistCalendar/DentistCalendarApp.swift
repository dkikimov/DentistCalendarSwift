//
//  DentistCalendarApp.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/21/20.
//

import SwiftUI

@main
struct DentistCalendarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isLogged") var status = Api().checkAndUpdateUser()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

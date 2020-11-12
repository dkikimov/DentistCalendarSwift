//
//  DentistCalendarApp.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/21/20.
//

import SwiftUI
import Amplify
import AmplifyPlugins
@main
struct DentistCalendarApp: App {
    @ObservedObject var sessionManager = SessionManager()
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
        }
    }
    
    private func configureAmplify() {
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()
            print("Initialized Amplify");
        } catch {
            // simplified error handling for the tutorial
            print("Could not initialize Amplify: \(error)")
        }
    }
}

//
//  DentistCalendarApp.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/21/20.
//

import SwiftUI
import Amplify
import AmplifyPlugins
import PhoneNumberKit
import GoogleMobileAds
public var phoneNumberKit = PhoneNumberKit()

@main
struct DentistCalendarApp: App {
    @ObservedObject var sessionManager = SessionManager()
//    @StateObject private var store = Store()
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
        ProductsStore.shared.initializeProducts()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
//                .environmentObject(store)
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
    
    private func configureGoogleAds() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}

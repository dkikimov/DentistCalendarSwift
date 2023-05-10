//
//  DentistCalendarApp.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/21/20.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import PhoneNumberKit
import Appodeal
import Firebase
import ApphudSDK
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif

import AdSupport

func configureApphud() {
    Apphud.start(apiKey: "app_NLE7uVfdajb1hbJHYguEuoBf5zgy65")
}

public var phoneNumberKit = PhoneNumberKit()
public var partialFormatter = PartialFormatter()
class ModalManager: ObservableObject {
    @Published var isDatePickerPresented = false
    @Published var selectedDate = Date()
}

func formatPhone(_ phoneNumber: String) -> String? {
    var phoneFormattedNumber: String
    do {
        phoneFormattedNumber = phoneNumberKit.format(try phoneNumberKit.parse(phoneNumber, ignoreType: true), toType: .international)
    } catch {
        return nil
    }
    return phoneFormattedNumber
}

@main
struct DentistCalendarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject var sessionManager = SessionManager()
    @State var isSubscriptionViewPresented = false
    @State var areViewsPresented = false
    init() {
        configureApphud()
        configureAmplify()
        sessionManager.getCurrentAuthUser()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
                .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
                .onAppear {
                    requestIDFA()
                }
        }
    }
    
}

private func configureAmplify() {
    let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
    do {
        try Amplify.add(plugin: dataStorePlugin)
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        if Apphud.hasActiveSubscription() {
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
        }
        try Amplify.configure()
        print("Initialized Amplify");
    } catch {
        print("Could not initialize Amplify: \(error)")
    }
}

private func requestIDFA() {
    if #available(iOS 14.5, *) {
        ATTrackingManager.requestTrackingAuthorization { status in
            guard status == .authorized else {return}
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            Apphud.setAdvertisingIdentifier(idfa)
        }
    }
}

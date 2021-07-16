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
import Appodeal
import Firebase
import Network
import AppTrackingTransparency
public var phoneNumberKit = PhoneNumberKit()
public var partialFormatter = PartialFormatter()
class ModalManager: ObservableObject {
    @Published var isDatePickerPresented = false
    @Published var selectedDate = Date()
}

func formatPhone(_ phoneNumber: String) -> String? {
    var phoneFormattedNumber: String
    do {
        phoneFormattedNumber = phoneNumberKit.format(try phoneNumberKit.parse(phoneNumber), toType: .international)
    } catch {
//                    print("NUMBER", phoneNumber, phoneFormattedNumber)
        return nil
    }
    return phoneFormattedNumber
}

@main
struct DentistCalendarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @ObservedObject var sessionManager = SessionManager()
//    @StateObject var internetConnectionManager = InternetConnectionManager()
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isSubscriptionViewPresented = false
    @State var areViewsPresented = false
    //    @StateObject private var store = Store()
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
//                .environmentObject(internetConnectionManager)
                .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
//                .onChange(of: internetConnectionManager.isNotInternetConnected, perform: { (newValue) in
//                    handleInternetConnection(newValue)
//                })
//                .fullScreenCover(isPresented: $isSubscriptionViewPresented) {
//                    BuySubscriptionView()
//                }
//                .onChange(of: isSubscriptionViewPresented, perform: { newValue in
//                    print("SUBSCRIPTION VIEW PRESENTED", newValue)
//                    if isSubscriptionViewPresented == false {
//                        handleInternetConnection(internetConnectionManager.isNotInternetConnected)
//                    }
//
//                })
//                .onAppear {
//                    if alertController.actions.count == 0 {
//                        alertController.addAction(UIAlertAction(title: "Перейти к покупке", style: .default, handler: { action in
//
//                            var window: UIWindow? {
//                                guard let scene = UIApplication.shared.connectedScenes.first,
//                                      let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
//                                      let window = windowSceneDelegate.window else {
//                                    return nil
//                                }
//                                return window
//                            }
//                            window?.rootViewController?.dismiss(animated: true, completion: {
//
//                            isSubscriptionViewPresented.toggle()
//                            }
//                            )}))
//                    }
//                }
            //                            .environment(\.internetAvailability, $isInternetConnected)
        }
        
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


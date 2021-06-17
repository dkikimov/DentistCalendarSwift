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
import Firebase
import Network
public var phoneNumberKit = PhoneNumberKit()
public var partialFormatter = PartialFormatter()
class ModalManager: ObservableObject {
    @Published var isDatePickerPresented = false
    @Published var selectedDate = Date()
}


@main
struct DentistCalendarApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    @StateObject var internetConnectionManager = InternetConnectionManager()
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var alertController = UIAlertController(title: "Нет доступа к интернету", message: "Оффлайн работа приложения доступна только для пользователей Dentor Premium", preferredStyle: .alert)
    @State var isSubscriptionViewPresented = false
    @State var areViewsPresented = false
    //    @StateObject private var store = Store()
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
        
        //        ProductsStore.shared.initializeProducts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
                .environmentObject(internetConnectionManager)
                .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
                .onChange(of: internetConnectionManager.isNotInternetConnected, perform: { (newValue) in
                    handleInternetConnection(newValue)
                })
                .fullScreenCover(isPresented: $isSubscriptionViewPresented) {
                    BuySubscriptionView()
                }
                .onChange(of: isSubscriptionViewPresented, perform: { newValue in
                    if isSubscriptionViewPresented == false {
                        handleInternetConnection(internetConnectionManager.isNotInternetConnected)
                    }
                         
                })
                .onAppear {
                    alertController.addAction(UIAlertAction(title: "Перейти к покупке", style: .default, handler: { action in
                        isSubscriptionViewPresented = true
                    }))
                    
                }
            //                            .environment(\.internetAvailability, $isInternetConnected)
        }
        
    }
    func presentAlert() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController  {
                   while let presentedViewController = topController.presentedViewController {
                         topController = presentedViewController
                        }
//        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//
//        if var topController = keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
            topController.present(topController, animated: true, completion: nil)
        }
        
    }
    
    func handleInternetConnection(_ isNotInternetConnected: Bool) {
        if isNotInternetConnected == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                presentAlert()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    if !alertController.isPresenting {
                        alertController.dismiss()
                        presentAlert()
                    }
                }
                print("PRESENT ALERT")
            }
        } else {
            alertController.dismiss(animated: true)
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

private func configureGoogleAds() {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
}



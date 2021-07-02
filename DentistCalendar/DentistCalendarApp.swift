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


@main
struct DentistCalendarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @ObservedObject var sessionManager = SessionManager()
//    @StateObject var internetConnectionManager = InternetConnectionManager()
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var alertController = UIAlertController(title: "Нет доступа к интернету", message: "Оффлайн работа приложения доступна только для пользователей Dentor Premium", preferredStyle: .alert)
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
    func presentAlert() {
        //: Working method
//        window?.rootViewController?.dismiss(animated: true, completion: {
//            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
////            print("WINDOWS COUNT", UIApplication.shared.windows.filter {$0.isKeyWindow}.count)
//            if var topController = keyWindow?.rootViewController {
//                while let presentedViewController = topController.presentedViewController {
//                    topController = presentedViewController
//                }
//                topController.present(alertController, animated: true, completion: nil)
//
//            }
//
//
//        })
        
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alertController, animated: true)
        // topController should now be your topmost view controller
        }
    }
    
    func handleInternetConnection(_ isNotInternetConnected: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            if isNotInternetConnected == true {
                presentAlert()
                print("PRESENT ALERT")
            } else {
                alertController.dismiss(animated: true)
            }
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


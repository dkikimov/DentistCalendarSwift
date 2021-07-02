//
//  AppDelegate.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 20.06.2021.
//

import Foundation
import SwiftUI
import UIKit
import StackConsentManager
import Appodeal
class AppDelegate: NSObject, UIApplicationDelegate {
    
    private struct AppodealConstants {
        static let key: String = "842515d12246dcac9355142f0807929ee11333e90b142f91"
        static let adTypes: AppodealAdType = [.interstitial, .rewardedVideo]
        static let logLevel: APDLogLevel = .debug
        static let testMode: Bool = false
    }
    
    var window: UIWindow?
    
    // MARK: Controller Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        synchroniseConsent()
        return true
    }
    
    
    // MARK: Appodeal Initialization
    private func initializeAppodealSDK() {
        /// Custom settings
        // Appodeal.setFramework(.native, version: "1.0.0")
        // Appodeal.setTriggerPrecacheCallbacks(true)
        // Appodeal.setLocationTracking(true)
        
        /// Test Mode
        Appodeal.setTestingEnabled(AppodealConstants.testMode)
        
        /// User Data
        // Appodeal.setUserId("userID")
        // Appodeal.setUserAge(25)
        // Appodeal.setUserGender(.male)
        //            Appodeal.setLogLevel(AppodealConstants.logLevel)
        Appodeal.setAutocache(true, types: AppodealConstants.adTypes)
        // Initialise Appodeal SDK with consent report
        if STKConsentManager.shared().consent != nil {
            Appodeal.initialize(
                withApiKey: AppodealConstants.key,
                types: AppodealConstants.adTypes,
                hasConsent: true
            )
        } else {
            Appodeal.initialize(
                withApiKey: AppodealConstants.key,
                types: AppodealConstants.adTypes,
                hasConsent: false
            )
        }
    }
    
    // MARK: Consent manager
    private func synchroniseConsent() {
        STKConsentManager.shared().synchronize(withAppKey: AppodealConstants.key) { error in
            error.map { print("Error while synchronising consent manager: \($0)") }
            guard STKConsentManager.shared().shouldShowConsentDialog == .true else {
                self.initializeAppodealSDK()
                return
            }
            
            STKConsentManager.shared().loadConsentDialog { [unowned self] error in
                error.map { print("Error while loading consent dialog: \($0)") }
                guard let controller = self.window?.rootViewController, STKConsentManager.shared().isConsentDialogReady else {
                    self.initializeAppodealSDK()
                    return
                }
                
                STKConsentManager.shared().showConsentDialog(fromRootViewController: controller,
                                                             delegate: self)
            }
        }
    }
}


extension AppDelegate: STKConsentManagerDisplayDelegate {
    func consentManagerWillShowDialog(_ consentManager: STKConsentManager) {}
    
    func consentManager(_ consentManager: STKConsentManager, didFailToPresent error: Error) {
        initializeAppodealSDK()
    }
    
    func consentManagerDidDismissDialog(_ consentManager: STKConsentManager) {
        initializeAppodealSDK()
    }
}


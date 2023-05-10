//
//  SessionManager.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/4/20.
//

import Amplify
import SwiftUI
import AWSDataStorePlugin
import ApphudSDK
import FirebaseAnalytics
enum AuthProvider: String {
    case signInWithApple
}
enum AuthState {
    case login
    case confirmCode(username: String, password: String)
    case session
    case forgotCode(username: String, newPassword: String)
    case confirmSignUp(username: String, password: String)
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    @AppStorage("loggedWithSocialProvider") var isProviderSocial = false

    private var window: UIWindow {
        guard
            let scene = UIApplication.shared.connectedScenes.first,
            let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
            let window = windowSceneDelegate.window as? UIWindow
        
        else {
            return UIWindow()
        }
        return window
    }
    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            withAnimation {
                    self.authState = .session
                }
            print("ID ", user.userId)
            print("set session")
        } else {
                        withAnimation {
                            self.authState = .login
                        }
                    
                    _ = Amplify.Auth.signOut()
                    print("redirect to login view")
        }
    }
    
    func showLogin() {
        withAnimation {
            authState = .login
        }
    }
    
    func signUp(email: String, password: String, firstName: String, secondName: String, compelition: @escaping( String?) -> ()) {
        let attributes = [AuthUserAttribute(.email, value: email), AuthUserAttribute(.familyName, value: secondName),AuthUserAttribute(.name, value: firstName)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        _ = Amplify.Auth.signUp(username: email, password: password, options: options) { [weak self] result in
            switch result {
            case .success(let signUpResult):
                switch signUpResult.nextStep {
                case .done:
                    Analytics.logEvent(AnalyticsEventSignUp, parameters: nil)
                    self?.login(email: email, password: password, compelition: { (err) in
                        configureApphud()
                        DispatchQueue.main.async {
                            compelition(err)
                        }
                    })
                    
                case .confirmUser(let details, _):
                    DispatchQueue.main.async {
                        withAnimation {
                            self?.authState = .confirmCode(username: email, password: password)
                        }
                        compelition(nil)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    compelition(error.errorDescription)
                }
            }
        }
        
    }
    
    func resetPassword(email: String, newPassword: String, compelition: @escaping( String?) -> ()) {
        Amplify.Auth.resetPassword(for: email, options: .none) { [weak self] (result) in
            switch result {
            case .success(let res):
                switch res.nextStep {
                case .confirmResetPasswordWithCode(let details, _):
                    DispatchQueue.main.async {
                        withAnimation {
                            self?.authState = .forgotCode(username: email, newPassword: newPassword)
                        }
                        compelition(nil)
                    }
                case .done:
                    DispatchQueue.main.async {
                        self?.showLogin()
                        compelition(nil)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    compelition(error.localizedDescription)
                }
            }
        }
    }
    
    func updatePassword(oldPassword: String, newPassword: String,compelition: @escaping( String?) -> ()) {
        _ = Amplify.Auth.update(oldPassword: oldPassword, to: newPassword) { result in
            switch result {
            case .success(let confirmResult):
                DispatchQueue.main.async {
                    compelition(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    compelition(error.errorDescription)
                }
            }
        }
        
    }
    func confirm(username: String, password: String, code: String,compelition: @escaping( String?) -> ()) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code, listener: { [weak self] (result) in
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                
                if confirmResult.isSignupComplete {
                    DispatchQueue.main.async {
                        self?.login(email: username, password: password) { (err) in
                            if let err = err {
                                DispatchQueue.main.async {
                                    self?.showLogin()
                                    compelition(err)
                                }
                                
                            }
                        }
                    }
                    
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    compelition(error.localizedDescription)
                }
            }
        })
    }
    func confirmSignUp(for username: String, with code: String, password: String, completion: @escaping (String?)->()) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code, listener: { (result) in
            switch result {
            case .success:
                self.login(email: username, password: password) { (err) in
                    if let err = err {
                        DispatchQueue.main.async {
                            self.showLogin()
                            completion(err)
                        }
                    }
                    self.getCurrentAuthUser()
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    completion(err.errorDescription)
                }
            }
        })
    }
    func confirmResetPassword(username: String, newPassword: String, code: String, compelition: @escaping( String?) -> ()) {
        _ = Amplify.Auth.confirmResetPassword(for: username, with: newPassword, confirmationCode: code, listener: { [weak self] (result) in
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                DispatchQueue.main.async {
                    self?.login(email: username, password: newPassword) { err in
                        if let err = err {
                            DispatchQueue.main.async {
                                compelition(err)
                            }
                            self?.showLogin()
                        }
                    }
                    compelition(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    compelition(error.localizedDescription)
                }
                
            }
        })
    }
    func login(email: String, password: String, compelition: @escaping( String?) -> ()) {
        _ = Amplify.Auth.signIn(
            username: email,
            password: password
        ) { [weak self] result in
            switch result {
            case .success(let signInResult):
                if signInResult.isSignedIn {
                    self?.fetchAttributes(completion: { (err) in
                        if err != nil {
                            DispatchQueue.main.async {
                                compelition(err)
                            }
                        }
                    })
                    DispatchQueue.main.async {
                        self?.getCurrentAuthUser()
                        Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                        compelition(nil)
                    }
                } else {
                    switch signInResult.nextStep {
                    case .confirmSignUp:
                        DispatchQueue.main.async {
                            withAnimation {
                                self?.authState = .confirmSignUp(username: email, password: password)
                            }
                            compelition(nil)
                        }
                    default:
                        break
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    compelition(error.errorDescription)
                }
                
            }
        }
    }
    
    func resendSignUpCode(email: String,compelition: @escaping( String?) -> ()) {
        Amplify.Auth.resendSignUpCode(for: email) { result in
            switch result {
            case .failure(let err):
                DispatchQueue.main.async {
                    compelition(err.localizedDescription)
                }
            default:
                break
            }
        }
    }
    func loginWithGoogle(compelition: @escaping( String?) -> ()) {
        Amplify.Auth.signInWithWebUI(for: .google, presentationAnchor: window) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
                self.fetchAttributes { err in
                    if err != nil {
                        DispatchQueue.main.async {
                            compelition(err)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.isProviderSocial = true
                    self.getCurrentAuthUser()
                    compelition(nil)
                }
            case .failure(let error):
                print("Sign in failed \(error)")
                DispatchQueue.main.async {
                    compelition(error.localizedDescription)
                }
            }
        }
    }
    func loginWithApple() {
        Amplify.Auth.signInWithWebUI(for: .apple, presentationAnchor: window) { result in
            switch result {
            case .success(let res):
                print("Sign in succeeded")
                self.fetchAttributes { err in }
                DispatchQueue.main.async {
                    self.isProviderSocial = true
                    self.getCurrentAuthUser()
                }
                
            case .failure(let err):
                break
            }
        }
    }
    func signOut(compelition: @escaping( String?) -> ()) {
        Amplify.Auth.signOut { [weak self] result in
            switch result {
            case .success:
                UserDefaults.standard.removeObject(forKey: "firstname")
                UserDefaults.standard.removeObject(forKey: "surname")
                _ = Amplify.DataStore.clear()
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                    compelition(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    compelition(error.localizedDescription)
                }
            }
        }
        
    }
    func fetchAttributes(completion: @escaping(String?) -> ()) {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                var familyName = ""
                var name = ""
                for item in attributes {
                    if item.key.rawValue == "family_name" {
                        familyName = item.value
                    }
                    else if item.key.rawValue == "name" {
                        name = item.value
                    }
                }
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue(familyName, forKey: "surname")
                    UserDefaults.standard.setValue(name, forKey: "firstname")
                }
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error.localizedDescription)
                }
            }
        }
        
    }
    
}


//
//  SessionManager.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/4/20.
//

import Amplify
import SwiftUI
import AmplifyPlugins
import AWSMobileClient
enum AuthState {
    case login
    case confirmCode(username: String, password: String)
    case session(user: AuthUser)
    case forgotCode(username: String, newPassword: String)
    case confirmSignUp(username: String, password: String)
//    case unauthenticated
}


final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    
    //    func getCurrentAuthUser() {
    ////        Amplify.Auth.signOut()
    //        _ = Amplify.Auth.fetchAuthSession { result in
    //            switch result {
    //            case .success(let session):
    //                print("Is user signed in - \(session.isSignedIn)")
    //                if session.isSignedIn  {
    //                    self.authState = .session(user: )
    //
    //                } else {
    //                    self.authState = .login
    //                }
    //            case .failure(let error):
    //                print("Fetch session failed with error \(error)")
    //                self.authState = .login
    //            }
    //        }
    //    }
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
                authState = .session(user: user)
            }
            print("ID ", user.userId)
            print("set session")
        } else {
            withAnimation {
                authState = .login
            }
            _ = Amplify.Auth.signOut()
            print("redirect to login view")
//            withAnimation {
//                authState = .unauthenticated
//            }
        }
    }
    func showLogin() {
        withAnimation {
            authState = .login
        }
    }
    func loginWithAppleNative(navController: UINavigationController) {
        do {
            let plugin = try Amplify.Auth.getPlugin(for: "awsCognitoAuthPlugin") as! AWSCognitoAuthPlugin
            guard case let .awsMobileClient(awsmobileclient) = plugin.getEscapeHatch() else {
                print("Failed to fetch escape hatch")
                return
            }
            print("Fetched escape hatch - \(awsmobileclient)")
            awsmobileclient.federatedSignIn(providerName: "SignInWithApple", token: "asd") { state, err in
                print("state")
            }
        } catch {
            print("Error occurred while fetching the escape hatch \(error)")
        }
    }
    func loginWithGoogleNative(navController: UINavigationController) {
        do {
            let plugin = try Amplify.Auth.getPlugin(for: "awsCognitoAuthPlugin") as! AWSCognitoAuthPlugin
            guard case let .awsMobileClient(awsmobileclient) = plugin.getEscapeHatch() else {
                print("Failed to fetch escape hatch")
                return
            }
            print("Fetched escape hatch - \(awsmobileclient)")
            let hostedUIOptions = HostedUIOptions(scopes: ["openid", "email", "profile"], identityProvider: "Google")
            
            awsmobileclient.showSignIn(navigationController: navController, hostedUIOptions: hostedUIOptions) { (userState, error) in
                if let error = error as? AWSMobileClientError {
                    print(error)
                    print(error.localizedDescription)
                }
                if let userState = userState {
                    print("Status: \(userState.rawValue)")

                    AWSMobileClient.default().getTokens { (tokens, error) in
                        if let error = error {
                            print("error \(error)")
                        } else if let tokens = tokens {
                            let claims = tokens.idToken?.claims
                            print("username? \(claims?["username"] as? String ?? "No username")")
                            print("cognito:username? \(claims?["cognito:username"] as? String ?? "No cognito:username")")
                            print("email? \(claims?["email"] as? String ?? "No email")")
                            print("name? \(claims?["name"] as? String ?? "No name")")
                            print("picture? \(claims?["picture"] as? String ?? "No picture")")
//
//                            if let username = claims?["email"] as? String {
//                                DispatchQueue.main.async {
//                                    self.settings.username = username
//                                }
//                            }
//
//                            if provider == "Facebook", let picture = claims?["picture"], let pictureJsonStr = picture as? String, let fbPictureURL = self.parseFBImage(from: pictureJsonStr) {
//                                print("Do something with fbPictureURL: ", fbPictureURL)
//                            } else if provider == "SignInWithApple" {
//                                print("Ignore Apple's Picture")
//                            }
                        }
                    }
                }
            }
        } catch {
            print("Error occurred while fetching the escape hatch \(error)")
        }
    }
    func signUp(email: String, password: String, firstName: String, secondName: String, compelition: @escaping( String?) -> ()) {
        let attributes = [AuthUserAttribute(.email, value: email), AuthUserAttribute(.familyName, value: secondName),AuthUserAttribute(.name, value: firstName)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        _ = Amplify.Auth.signUp(username: email, password: password, options: options) { [weak self] result in
            switch result {
            case .success(let signUpResult):
                print("Sign up", signUpResult)
                
                switch signUpResult.nextStep {
                case .done:
                    print("finished sign up")
                    self?.login(email: email, password: password, compelition: { (err) in
                        DispatchQueue.main.async {
                            compelition(err)
                        }
                    })
                    
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        withAnimation {
                            self?.authState = .confirmCode(username: email, password: password)
                        }
                        compelition(nil)
                    }
                }
                
            case .failure(let error):
                print("Sign up error", error)
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
                    print("DETAILS", details)
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
                print("ERROR")
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
                print(confirmResult)
                DispatchQueue.main.async {
                    compelition(nil)
                }
            case .failure(let error):
                print("ERROR UPDATE PASSWORD", error)
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
//                        self?.showLogin()
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
                print("FAILED TO CONFIRM CODE ", error)
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
//                    self?.showLogin()
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
                print("FAILED TO CONFIRM CODE ", error)
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
                print("Login error: ", error)
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
//        Amplify.Auth.signInWithWebUI(for: .google, presentationAnchor: window)
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
                print(res)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    func signOut(compelition: @escaping( String?) -> ()) {
        Amplify.Auth.signOut { [weak self] result in
            switch result {
            case .success:
                UserDefaults.standard.removeObject(forKey: "fullname")
                _ = Amplify.DataStore.clear()
                print("signed out successfully")
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                    compelition(nil)
                }
            case .failure(let error):
                print("Sign out failed with error \(error)")
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
                print("User attributes - \(attributes)")
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
                    UserDefaults.standard.setValue(familyName + " " + name , forKey: "fullname")
                }
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
                DispatchQueue.main.async {
                    completion(error.localizedDescription)
                }
            }
        }
        
    }
    
}


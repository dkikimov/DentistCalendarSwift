//
//  SessionManager.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/4/20.
//

import Amplify
enum AuthState {
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
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
    
    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            authState = .session(user: user)
            print("ID ", user.userId)
            print("set session")
        } else {
            authState = .login
            Amplify.Auth.signOut()
            print("redirect to login view")
        }
    }
    func showLogin() {
        authState = .login
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
                    DispatchQueue.main.async {
                        compelition(nil)
                    }
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(username: email)
                        compelition(nil)
                    }
                }
                
            case .failure(let error):
                print("Sign up error", error)
                DispatchQueue.main.async {
                    compelition(error.localizedDescription)
                }
            }
        }
    }
    
    func confirm(username: String, code: String,compelition: @escaping( String?) -> ()) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code, listener: { [weak self] (result) in
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                
                if confirmResult.isSignupComplete {
                    DispatchQueue.main.async {
                        self?.showLogin()
                        compelition(nil)
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
    
    func login(email: String, password: String, compelition: @escaping( String?) -> ()) {
        _ = Amplify.Auth.signIn(
            username: email,
            password: password
        ) { [weak self] result in
            switch result {
            case .success(let signInResult):
                if signInResult.isSignedIn {
                    self?.fetchAttributes { (attributes, err) in
                        if err != nil {
                            DispatchQueue.main.async {
                                compelition(err)
                            }
                            return
                        } else {
                            var familyName = ""
                            var name = ""
                            for item in attributes! {
                                if item.key.rawValue == "family_name" {
                                    familyName = item.value
                                }
                                else if item.key.rawValue == "name" {
                                    name = item.value
                                }
                            }
                            UserDefaults.standard.setValue(familyName + " " + name , forKey: "fullname")
                        }
                    }
                    UserDefaults.standard.setValue("123 123" , forKey: "fullname")

                    DispatchQueue.main.async {
                        self?.getCurrentAuthUser()
                        compelition(nil)
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
    func signOut(compelition: @escaping( String?) -> ()) {
        Amplify.Auth.signOut { [weak self] result in
            switch result {
            case .success:
                UserDefaults.standard.removeObject(forKey: "fullname")
                Amplify.DataStore.clear()
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
    func fetchAttributes(completion: @escaping([AuthUserAttribute]?, String?) -> ()) {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                print("User attributes - \(attributes)")
                DispatchQueue.main.async {
                    completion(attributes, nil)
                }
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
                DispatchQueue.main.async {
                    completion(nil, error.errorDescription)
                }
            }
        }
    }
}


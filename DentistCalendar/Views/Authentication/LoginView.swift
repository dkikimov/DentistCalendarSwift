//
//  LoginView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/26/20.
//

import SwiftUI
struct LoginView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @ObservedObject var loginData = LoginViewModel()
    @State var navigationController: UINavigationController?
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    CustomTextField(label: "Email", title: "example@gmail.com", text: $loginData.emailAddress, isSecure: false, keyboardType: .default).autocapitalization(.none).padding(.horizontal, 20).padding(.top, 20)
                    CustomTextField(label: "Пароль", title: "example123", text: $loginData.password, isSecure: true, keyboardType: .default).padding(.horizontal, 20)
                    HStack() {
                        NavigationLink(
                            destination: RegisterView(),
                            label: {
                                Text("Нет аккаунта? Зарегистрируйтесь")
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }).padding(.horizontal, 20)
                        Spacer()
                        NavigationLink(
                            destination: ForgotPasswordView(),
                            label: {
                                Text("Забыли пароль?")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }).padding(.horizontal, 20)
                    }
                    ActionButton(buttonLabel: "Войти", color: Color("StaticBlue"), isLoading: $loginData.isLoading) {
                        withAnimation {
                            loginData.login(sessionManager: self.sessionManager)
                        }
                    }
                    //                CustomButton(action: {
                    //                    loginData.login(sessionManager: self.sessionManager)
                    //                }, imageName: "arrowshape.zigzag.forward", label: "Войти", isLoading: $loginData.isLoading)
                    
                    Text("ИЛИ")
                        .font(.footnote)
                        .bold()
                    
                    GoogleSignInButton()
                        .introspectNavigationController { navigationController in
                            self.navigationController = navigationController
                        }
                    
                    EmptyView()
                    
                    ContinueWithAppleButton()
                        .environmentObject(sessionManager)
                    Spacer(minLength: 0)
                        
                        .alert(isPresented: $loginData.isAlertPresented, content: {
                            Alert(title: Text("Ошибка"), message: Text(loginData.error) , dismissButton: .cancel())
                        })
                    
                    
                    
                }.navigationBarTitle(Text("Вход"))
                //            .transition(.move(edge: .bottom))
                
                
                //            .navigationBarColor( backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
                
                
            }
            .padding(.top, 1)
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        //        .transition(.move(edge: .bottom))
    }
    
//    private func configureAppleButton(_ request: ASAuthorizationAppleIDRequest) {
//        request.requestedScopes = [.email, .fullName]
//
//    }
//
//    private func handleAppleButton(_ authResult: Result<ASAuthorization, Error>) {
//        switch authResult {
//        case .success(let auth):
//            switch auth.credential {
//            case let appleIDCredentials as ASAuthorizationAppleIDCredential:
//                if let appleUser = AppleUser(credentials: appleIDCredentials),
//                   let appleUserData = try? JSONEncoder().encode(appleUser) {
//                    UserDefaults.standard.setValue(appleUserData, forKey: appleUser.userId)
//
//                    print("saved apple user", appleUser)
//                } else {
//                    print("missing some fields", appleIDCredentials.email ?? "missing", appleIDCredentials.fullName ?? "missing", appleIDCredentials.user )
//
//                    guard
//                        let appleUserData = UserDefaults.standard.data(forKey: appleIDCredentials.user),
//                        let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
//                    else { return }
//
//                    print(appleUser)
//                }
//
//                if let identityTokenData = appleIDCredentials.identityToken {
//                    guard let identityToken = String(data: identityTokenData, encoding: .utf8) else {
//                        print("Can't convert identity token data to string")
//                        return
//                    }
//                    sessionManager.loginWithAppleNative(token: identityToken)
//                }
//            //                sessionManager.loginWithAppleNative(token: appleIDCredentials.user)
//
//
//            default:
//                print(auth.credential)
//            }
//            break
//        case .failure(let err):
//            print("ERROR", err.localizedDescription)
//        }
//    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        
        
    }
}

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
            }
            .padding(.top, 1)
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        
        
    }
}

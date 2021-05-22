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
                    
                    Spacer(minLength: 0)
                        
                        .alert(isPresented: $loginData.isAlertPresented, content: {
                        Alert(title: Text("Ошибка"), message: Text(loginData.error) , dismissButton: .cancel())
                        })
                    
                    
                    
                }.navigationBarTitle(Text("Вход"))
    //            .transition(.move(edge: .bottom))
                
                
    //            .navigationBarColor( backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
                
                
            }
            
        }
//        .transition(.move(edge: .bottom))
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            
            
    }
}

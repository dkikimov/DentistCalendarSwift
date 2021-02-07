//
//  ForgotPasswordView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 21.01.2021.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var email = ""
    @State var firstPassword = ""
    @State var secondPassword = ""
    @State var isLoading: Bool = false
    
    
    @State var isAlertPresented = false
    @State var error = ""
    var body: some View {
        VStack {
            CustomTextField(label: "Email", title: "example@gmail.com", text: $email, isSecure: false, keyboardType: .default).autocapitalization(.none).padding(.horizontal, 20).padding(.top, 20)
            CustomTextField(label: "Новый пароль", title: "example123", text: $firstPassword, isSecure: true, keyboardType: .default).padding(.horizontal, 20)
            CustomTextField(label: "Повторите пароль", title: "example123", text: $secondPassword, isSecure: true, keyboardType: .default).padding(.horizontal, 20)
            
            CustomButton(action: {
                guard !email.isEmpty && !firstPassword.isEmpty && !secondPassword.isEmpty else {
                    self.error = "Заполните форму".localized
                    self.isAlertPresented = true
                    return
                }
                let (isValid, err) = checkEmail(email)
                guard isValid else {
                    self.error = err!
                    self.isAlertPresented = true
                    return
                }
                let (status, error) = checkPassword(a: firstPassword, b: secondPassword)
                
                if status {
                    sessionManager.resetPassword(email: email, newPassword: firstPassword) { (err) in
                        if let error = err {
                            self.error = error
                            self.isAlertPresented = true
                        }
                    }
                } else if !status {
                    self.error = error!
                    self.isAlertPresented = true
                }
                
            }, imageName: nil, label: "Восстановить", isLoading: $isLoading)
            
            Spacer(minLength: 0)
                .navigationBarTitle(Text("Восстановление"))
                .alert(isPresented: $isAlertPresented, content: {
                    Alert(title: Text("Ошибка"), message: Text(error) , dismissButton: .cancel())
                })
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

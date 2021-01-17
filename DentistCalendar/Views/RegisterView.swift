//
//  RegisterView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/26/20.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var registerData = RegisterViewModel()
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                    CustomTextField(label: "Имя", title: "Вася", text: $registerData.name, isSecure: false, keyboardType: .default).disableAutocorrection(true).padding(.horizontal, 20).padding(.top, 20)
                    CustomTextField(label: "Фамилия", title: "Пупкин", text: $registerData.secondName, isSecure: false, keyboardType: .default).disableAutocorrection(true).padding(.horizontal, 20)
                    CustomTextField(label: "Email", title: "example@gmail.com", text: $registerData.emailAddress, isSecure: false, keyboardType: .emailAddress).autocapitalization(.none).padding(.horizontal, 20)
                    CustomTextField(label: "Пароль", title: "example123", text: $registerData.password, isSecure: true, keyboardType: .default).padding(.horizontal, 20)
                    CustomTextField(label: "Повторите пароль", title: "example123", text: $registerData.repeatPassword, isSecure: true, keyboardType: .default).padding(.horizontal, 20)
                    CustomButton(action: {
                        registerData.register(sessionManager: self.sessionManager)
                    }, imageName: "arrowshape.zigzag.forward", label: "Зарегистрироваться", isLoading: $registerData.isLoading)
                    Spacer(minLength: 0)
            }
            .navigationBarTitle(Text("Регистрация"))
            .alert(isPresented: $registerData.isAlertPresented, content: {
                Alert(title: Text("Ошибка"), message: Text(registerData.error), dismissButton: .cancel())
            })
        }
            
                
        
    }
    
}

//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}

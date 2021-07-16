//
//  LoginViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/1/20.
//

import SwiftUI

class LoginViewModel : ObservableObject {
    @Published var emailAddress:String = "katsushooter@gmail.com"
    @Published var password:String = "kiasoul551"
    @Published var isAlertPresented: Bool = false
    @Published var isLoading = false
    @Published var error = ""
    func login(sessionManager: SessionManager) {
        self.isLoading = true
        if emailAddress.isEmpty || password.isEmpty {
            error = "Заполните форму"
            isAlertPresented = true
            isLoading = false
            return
        }
        sessionManager.login(email: emailAddress, password: password) { err in
            if let err = err {
                self.error = err
                self.isAlertPresented = true
            }
            self.isLoading = false
        }

//        Api().login(email: emailAddress, password: password) { data, err in
//
//            if err != nil {
//                self.error = err!
//                self.isAlertPresented.toggle()
//            }
//
//            if data != nil{
//                UserDefaults.standard.set(data!.email, forKey: "email")
//                UserDefaults.standard.set(data!.fullname, forKey: "fullname")
//                UserDefaults.standard.set(data!.refreshToken, forKey: "refreshToken")
//                UserDefaults.standard.set(data!.accessToken, forKey: "accessToken")
//                UserDefaults.standard.set(data!.id, forKey: "id")
//                self.status = true
//            }
//            self.isLoading = false
//
//
//        }
    }
    
}
    

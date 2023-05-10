//
//  LoginViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/1/20.
//

import SwiftUI

class LoginViewModel : ObservableObject {
    @Published var emailAddress:String = ""
    @Published var password:String = ""
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
    }
    
}
    

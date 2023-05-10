//
//  RegisterViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/2/20.
//

import SwiftUI

class RegisterViewModel : ObservableObject {
    @Published var name: String = ""
    @Published var secondName: String = ""
    @Published var emailAddress:String = ""
    @Published var password:String = ""
    @Published var repeatPassword: String = ""
    @Published var isAlertPresented: Bool = false
    @Published var isLoading = false
    @Published var error = ""
    @AppStorage("isLogged") var status = false
    
    func register(sessionManager: SessionManager) {
        self.isLoading = true
        
        if emailAddress.trimmingCharacters(in: .whitespaces) == "" || password.trimmingCharacters(in: .whitespaces) == ""  || name.trimmingCharacters(in: .whitespaces) == "" || secondName.trimmingCharacters(in: .whitespaces) == "" {
            error = "Заполните форму"
            isAlertPresented = true
            self.isLoading = false
            return
        }
        let (isValid, err) = checkEmail(emailAddress)
        guard isValid else {
            self.error = err!
            self.isAlertPresented = true
            self.isLoading = false
            return
        }
        let (status, error) = checkPassword(a: password, b: repeatPassword)
        
        guard status else {
            self.error = error!
            self.isAlertPresented = true
            self.isLoading = false
            return
        }
        
        sessionManager.signUp(email: emailAddress, password: password, firstName: name.trimmingCharacters(in: .whitespaces), secondName: secondName.trimmingCharacters(in: .whitespaces)){ err in
            if let err = err {
                self.error = err
                self.isAlertPresented = true
                
            }
            self.isLoading = false
        }
    }
    
}


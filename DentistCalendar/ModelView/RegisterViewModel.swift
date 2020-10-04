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
    func register() {
        self.isLoading = true
        if emailAddress.trimmingCharacters(in: .whitespaces) == "" || password.trimmingCharacters(in: .whitespaces) == ""  || name.trimmingCharacters(in: .whitespaces) == "" || secondName.trimmingCharacters(in: .whitespaces) == "" {
            error = "Заполните форму!"
            isAlertPresented = true
            self.isLoading = false
            return
        }
        if password.trimmingCharacters(in: .whitespaces) != repeatPassword.trimmingCharacters(in: .whitespaces) {
            error = "Пароли не совпадают"
            isAlertPresented = true
            self.isLoading = false
            return
        }
        let finalName = secondName.trimmingCharacters(in: .whitespaces) + " " + name.trimmingCharacters(in: .whitespaces)
        Api().register(fullname: finalName, email: emailAddress, password: password) { data, err in

            if err != nil {
                self.error = err!
                self.isAlertPresented.toggle()
            }
            if data != nil{
                print(data!)

                UserDefaults.standard.set(data!.email, forKey: "email")
                UserDefaults.standard.set(data!.fullname, forKey: "fullname")
                UserDefaults.standard.set(data!.refreshToken, forKey: "refreshToken")
                UserDefaults.standard.set(data!.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(data!.id, forKey: "id")
                self.status = true
            }
            self.isLoading = false
            

        }
    }
    
}
    

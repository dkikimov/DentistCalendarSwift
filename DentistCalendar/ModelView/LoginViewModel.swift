//
//  LoginViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/1/20.
//

import SwiftUI

class LoginViewModel : ObservableObject {
    @Published var emailAddress:String = "daniil.kikimov123@mail.ru"
    @Published var password:String = "kiasoul551"
    @Published var isAlertPresented: Bool = false
    @Published var isLoading = false
    @Published var error = ""
    @AppStorage("isLogged") var status = false
    func login() {
        self.isLoading = true
        if emailAddress.trimmingCharacters(in: .whitespaces) == "" || password.trimmingCharacters(in: .whitespaces) == "" {
            error = "Заполните форму!"
            isAlertPresented = true
            self.isLoading = false
            return
        }
        Api().login(email: emailAddress, password: password) { data, err in

            if err != nil {
                self.error = err!
                self.isAlertPresented.toggle()
            }
            
            if data != nil{
                UserDefaults.standard.set(data!.email, forKey: "email")
                UserDefaults.standard.set(data!.fullname, forKey: "fullname")
                UserDefaults.standard.set(data!.refreshToken, forKey: "refreshToken")
                UserDefaults.standard.set(data!.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(data!.id, forKey: "id")
                self.status = true
            }
            self.isLoading = false
            

        }
    }}
    

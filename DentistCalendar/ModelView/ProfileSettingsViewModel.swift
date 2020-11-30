//
//  ProfileSettingsViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/7/20.
//

import SwiftUI
import SPAlert

class ProfileSettingsViewModel: ObservableObject {
    let fullname = UserDefaults.standard.string(forKey: "fullname")!.split(separator: " ")
//    let fullname = "123 asdas".split(separator: " ")
    let realFirstName: String
    let realSecondName: String
    
    
    @Published var error: String = ""
    @Published var isAlertPresented: Bool = false
    @Published var firstName: String = ""
    @Published var secondName: String = ""
    @Published var isLoading:Bool = false
    @Published var isDisabled:Bool = true
    @AppStorage("isLogged") var status = false
    
    @Published var currentPassword: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    
    init() {
        firstName = String(fullname[1])
        secondName = String(fullname[0])
        realFirstName = String(fullname[1])
        realSecondName = String(fullname[0])
        
    }
    func updateFullname() {
        self.isLoading = true
        let finalName = secondName.trimmingCharacters(in: .whitespaces) + " " + firstName.trimmingCharacters(in: .whitespaces)
        var alertView: SPAlertView = SPAlertView(title: "Успех", message: "Имя успешно изменено!", preset: .done)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    func updatePassword(mode: Binding<PresentationMode>) {
        self.isLoading = true
        var alertView: SPAlertView = SPAlertView(title: "Успех", message: "Пароль успешно изменен!", preset: .done)
        alertView.haptic = .success
        
//        Api().updatePassword(currentPassword: currentPassword.trimmingCharacters(in: .whitespaces), newPassword: password.trimmingCharacters(in: .whitespaces)) { (success, error) in
//            if error != nil {
//                if error == "empty" {
//                    self.status = false
//                } else {
//                    alertView = SPAlertView(title: "Ошибка", message: error!, preset: .error)
//                    alertView.haptic = .error
//                }
//            }
//            
//            alertView.duration = 2
//            alertView.present()
//            if success {
//                mode.wrappedValue.dismiss()
//            }
//        }
        self.isLoading = false
    }
    
    
}

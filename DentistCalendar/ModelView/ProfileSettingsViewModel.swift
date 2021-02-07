//
//  ProfileSettingsViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/7/20.
//

import SwiftUI
import SPAlert
import Amplify

class ProfileSettingsViewModel: ObservableObject {
    let fullname = UserDefaults.standard.string(forKey: "fullname")?.split(separator: " ") ?? ["",""]
//    let fullname = "123 asdas".split(separator: " ")
    let realFirstName: String
    let realSecondName: String
    
    @Published var error: String = ""
    @Published var isAlertPresented: Bool = false
    @Published var isSheetPresented: Bool = false
    @Published var firstName: String = ""
    @Published var secondName: String = ""
    @Published var isLoading:Bool = false
    @Published var isDisabled:Bool = true
    
    @Published var currentPassword: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    
    @Published var isPasswordPresented = false
    init() {
        print("FULLNAME", fullname)
        firstName = String(fullname[1])
        secondName = String(fullname[0])
        realFirstName = String(fullname[1])
        realSecondName = String(fullname[0])
        
    }
    func updateFullname() {
        self.isLoading = true
//        let finalName = secondName.trimmingCharacters(in: .whitespaces) + " " + firstName.trimmingCharacters(in: .whitespaces)
        let s = secondName.trimmingCharacters(in: .whitespaces)
        let f = firstName.trimmingCharacters(in: .whitespaces)
        updateAttribute(secondName: s, firstName: f) { (success, error) in
            if let error = error {
                presentErrorAlert(message: error)
            } else if success {
                presentSuccessAlert(message: "Имя успешно изменено!")
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue(s + " " + f , forKey: "fullname")
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    func updatePassword(mode: Binding<PresentationMode>, sessionManager: SessionManager) {
        self.isLoading = true
        let (status, e) = checkPassword(a: password, b: repeatPassword)
        guard status else {
            let a = SPAlertView(title: "Ошибка", message: e, preset: .error)
            a.present(duration: 2)
            return
        }
        sessionManager.updatePassword(oldPassword: currentPassword, newPassword: password) { (err) in
            if let error = err {
                presentErrorAlert(message: error)
            } else {
                presentSuccessAlert(message: "Пароль успешно изменен!")
                mode.wrappedValue.dismiss()
            }
        }
        self.isLoading = false
    }
    func updateAttribute(secondName: String, firstName: String, completion: @escaping (Bool, String? ) -> ()) {
        let attributes = [AuthUserAttribute(.familyName, value: secondName), AuthUserAttribute(.name, value: firstName)]
        var res: Bool = true
        for attribute in attributes {
            Amplify.Auth.update(userAttribute: attribute) { result in
                do {
                    let updateResult = try result.get()
                    switch updateResult.nextStep {
                    case .confirmAttributeWithCode(let deliveryDetails, let info):
                        print("Confirm the attribute with details send to - \(deliveryDetails) \(info)")
                    case .done:
                        print("Update completed")
                    }
                } catch {
                    print("Update attribute failed with error \(error)")
                    res = false
                    DispatchQueue.main.async {
                        completion(res, error.localizedDescription)
                    }
                    return
                }
            }
        }
        DispatchQueue.main.async {
            completion(res, nil)
        }
    }
    
}

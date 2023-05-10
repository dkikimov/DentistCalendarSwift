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
    let firstNameData = UserDefaults.standard.string(forKey: "firstname") ?? ""
    let surnameData = UserDefaults.standard.string(forKey: "surname") ?? ""
    var realFirstName: String
    var realSecondName: String
    
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
        firstName = firstNameData
        secondName = surnameData
        realFirstName = firstNameData
        realSecondName = surnameData
        
    }
    func updateFullname() {
        self.isLoading = true
        let f = firstName.trimmingCharacters(in: .whitespaces)
        let s = secondName.trimmingCharacters(in: .whitespaces)
        guard f.count <= userNameMaxLength else {
            presentErrorAlert(message: "Имя слишком длинное")
            isLoading = false
            return
        }
        guard s.count <= userNameMaxLength else {
            presentErrorAlert(message: "Фамилия слишком длинная")
            isLoading = false
            return
        }
        updateAttribute(secondName: s.capitalized, firstName: f.capitalized) { (success, error) in
            if let error = error {
                presentErrorAlert(message: error)
            } else if success {
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue(s, forKey: "surname")
                    UserDefaults.standard.setValue(f, forKey: "firstname")
                }
            }
        }
        self.realFirstName = f
        self.realSecondName = s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
        }
    }
    func updatePassword(mode: Binding<PresentationMode>, sessionManager: SessionManager) {
        self.isLoading = true
        let (status, e) = checkPassword(a: password, b: repeatPassword)
        guard status else {
            presentErrorAlert(message: e!)
            self.isLoading = false
            return
        }
        sessionManager.updatePassword(oldPassword: currentPassword, newPassword: password) { (err) in
            if let error = err {
                DispatchQueue.main.async {
                    presentErrorAlert(message: error)
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    mode.wrappedValue.dismiss()
                }
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
                    default: break
                    }
                } catch {
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

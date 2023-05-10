//
//  PatientCreateViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//


import SwiftUI
import Amplify
import PhoneNumberKit
import SPAlert
class PatientCreateViewModel : ObservableObject {
    
    var patientName = ""
    var patientNumber = ""
    @Published var isAlertPresented: Bool = false
    
    @Published var isLoading = false
    var error = ""
    
    func createPatient(patientData: PatientsListViewModel,completion: @escaping(Bool) -> ()){
        self.isLoading = true
        guard !patientName.isEmpty else {
            error = "Заполните форму".localized
            isAlertPresented = true
            isLoading = false
            return
        }
        guard patientName.count <= patientNameMaxLength else {
            error = "Имя пациента слишком длинное".localized
            isAlertPresented = true
            isLoading = false
            return
        }
        var finalPhone: String = ""
        if !patientNumber.isEmpty {
            do {
                finalPhone = phoneNumberKit.format(try phoneNumberKit.parse(patientNumber, ignoreType: true), toType: .e164)
            } catch {
                self.error = "Введите корректный номер".localized
                self.isAlertPresented = true
                DispatchQueue.main.async {
                    completion(false)
                }
                self.isLoading = false
                return
            }
        }
        let newPatient = Patient(fullname: patientName.capitalized, phone: finalPhone.isEmpty ? nil : finalPhone)
        Amplify.DataStore.save(newPatient) { result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    completion(true)
                }
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        
        
        self.isLoading = false
    }
    
    
}

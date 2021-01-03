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
    
    @Published var patientName = ""
    @Published var patientNumber = ""
    @Published var isAlertPresented: Bool = false
    
    @Published var isLoading = false
    @Published var error = ""
    //    @Published var patient = PatientData(id: "1", fullname: "123", phone: "123", user: "123")
    
    func createPatient(patientData: PatientsListViewModel,completion: @escaping(Bool) -> ()){
        self.isLoading = true
        if phoneNumberKit.isValidPhoneNumber(patientNumber) {
            let newPatient = Patient(fullname: patientName, phone: patientNumber.replacingOccurrences(of: " ", with: ""), owner: Amplify.Auth.getCurrentUser()!.userId)
            Amplify.DataStore.save(newPatient) { result in
                switch result{
                case .success(let patient):
//                    patientData.patientsList.append(patient)
                    let alertView: SPAlertView = SPAlertView(title: "Успех", message: "Пациент успешно добавлена!", preset: .done)
                    alertView.duration = 3
                    alertView.present()
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
        } else {
            self.error = "Введите корректный номер"
            self.isAlertPresented = true
            DispatchQueue.main.async {
                completion(false)
            }
        }
        
        
        self.isLoading = false
    }
    
    
}

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
    //    @Published var patient = PatientData(id: "1", fullname: "123", phone: "123", user: "123")
    
    func createPatient(patientData: PatientsListViewModel,completion: @escaping(Bool) -> ()){
        self.isLoading = true
        guard !patientName.isEmpty else {
            error = "Заполните форму".localized
            isAlertPresented = true
            isLoading = false
            return
        }
        //        print("CURRENT NUMBER", patientNumber)
        //        print(patientNumber.replacingOccurrences(of: " ", with: "").isValidPhoneNumber())
        var finalPhone: String = ""
        if !patientNumber.isEmpty {
            do {
                finalPhone = phoneNumberKit.format(try phoneNumberKit.parse(patientNumber), toType: .e164)
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
        let newPatient = Patient(fullname: patientName, phone: finalPhone.isEmpty ? nil : finalPhone)
        Amplify.DataStore.save(newPatient) { result in
            switch result{
            case .success(_):
                //                    patientData.patientsList.append(patient)
                //                    presentSuccessAlert(message: "Пациент успешно добавлен!")
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

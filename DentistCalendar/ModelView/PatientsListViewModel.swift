//
//  PatientsListViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/10/20.
//

import SwiftUI
import SPAlert

class PatientsListViewModel: ObservableObject {
    @Published var patientsList: Array<PatientData>? = nil
    @Published var isLoading = false
    func fetchPatients(){
        self.isLoading = true
        Api().fetchPatients { (data, err) in
            if err != nil {
                print("error")
            } else {
                self.patientsList = data!
            }
            
        }
        self.isLoading = false
    }
    func deletePatient(id: String) {
        var alertView: SPAlertView = SPAlertView(title: "Успех", message: "Пациент успешно удален!", preset: .done)
        Api().deletePatient(id: id) { (success, err) in
            if err != nil {
                alertView = SPAlertView(title: "Ошибка", message: "При удалении произошла ошибка!", preset: .error)
                print(err!)
            }
            alertView.duration = 1.5
            alertView.present()
        }
        
    }
    
}

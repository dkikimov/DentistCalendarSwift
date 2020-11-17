//
//  PatientsListViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/10/20.
//

import SwiftUI
import SPAlert
import Amplify
class PatientsListViewModel: ObservableObject {
    @Published var patientsList = [Patient]()
    @Published var isLoading = false
    init() {
        fetchPatients()
    }
    func fetchPatients(){
        self.isLoading = true
        
        Amplify.DataStore.query(Patient.self, sort: .ascending(Patient.keys.fullname)) { result in
            switch result {
            case .success(let patients):
                
                print("PATIENT lIST", patients)
                patientsList = patients
            case .failure(let error):
                print("ERROR LIST", error.errorDescription)
                
            }
            //        Api().fetchPatients { (data, err) in
            //            if err != nil {
            //                print("error")
            //            } else {
            //                self.patientsList = data!
            //            }
            //
            //        }
            self.isLoading = false
        }
    }
    func deletePatient(id: String) {
        var alertView: SPAlertView = SPAlertView(title: "Успех", message: "Пациент успешно удален!", preset: .done)
        Amplify.DataStore.delete(Patient.self, withId: id) { res in
            switch res {
            case .success:
                alertView.duration = 2
                alertView.present()
            case .failure(let error):
                alertView = SPAlertView(title: "Ошибка", message: error.errorDescription, preset: .error)
                alertView.duration = 3.5
                alertView.present()
            }
        }
//        Api().deletePatient(id: id) { (success, err) in
//            if err != nil {
//                alertView = SPAlertView(title: "Ошибка", message: "При удалении произошла ошибка!", preset: .error)
//                print(err!)
//            }
//            alertView.duration = 1.5
//            alertView.present()
//        }
        
    }
    
}

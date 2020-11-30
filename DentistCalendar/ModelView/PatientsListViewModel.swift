//
//  PatientsListViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/10/20.
//

import SwiftUI
import SPAlert
import Amplify
import Combine

class PatientsListViewModel: ObservableObject {
    @Published var patientsList = [Patient]()
    @Published var isLoading = false
    var observationToken: AnyCancellable?
    
    deinit {
        observationToken?.cancel()
    }
    init() {
        fetchPatients()
    }
    func fetchPatients(){
        isLoading = true
        Amplify.DataStore.query(Patient.self, sort: .ascending(Patient.keys.fullname)) { result in
            switch result {
            case .success(let patients):
//                print("PATIENT lIST", patients)
                patientsList = patients
                isLoading = false
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
    func observePatients() {
        observationToken = Amplify.DataStore.publisher(for: Patient.self)
         .sink { (completion) in
             if case .failure(let error) = completion {
                 print("ERROR IN OBSERVE PATIENTS", error.errorDescription)
             }
         } receiveValue: { (changes) in
             print("CHANGES ", changes)
             guard let pat = try? changes.decodeModel(as: Patient.self) else {return}
             
             switch changes.mutationType {
             case "create":
                print("NEW PATIENT", pat)
                if !self.patientsList.contains(where: { (patient) -> Bool in
                    patient.id == pat.id
                }) {
                    DispatchQueue.main.async {
                        self.patientsList.append(pat)
                    }
                }
                 break
             case "delete":
                DispatchQueue.main.async {
                    if let index = self.patientsList.firstIndex(where: {$0.id == pat.id}) {
                       self.patientsList.remove(at: index)
                    }
                }
                 break
              default:
                 break
             }
         }
    }
}

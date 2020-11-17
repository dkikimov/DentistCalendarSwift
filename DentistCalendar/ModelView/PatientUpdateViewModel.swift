//
//  PatientUpdateViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/25/20.
//




import SwiftUI
import SPAlert
import Amplify
class PatientUpdateViewModel : ObservableObject {

    @Published var isAlertPresented: Bool = false
    @Published var isLoading = false
    @Published var error = ""
    
    @Published var patient: Patient
    var index: Int
    @Published  var fullname: String = ""
    @Published  var phone: String = ""
    
    @AppStorage("isLogged") var status = false
//    init (patient: PatientData) {
//        self.patient = patient
//    }
    init(patient: Patient, index: Int) {
        self.patient = patient
        self.fullname = patient.fullname
        self.phone = patient.phone
        self.index = index
    }
    func updatePatient(listData: PatientsListViewModel, compelition: @escaping(Bool) -> () ){
        self.isLoading = true
        var newPatient = patient
        newPatient.fullname = fullname.trimmingCharacters(in: .whitespaces)
        newPatient.phone = phone.replacingOccurrences(of: " ", with: "")
        var alertView: SPAlertView = SPAlertView(title: "Успех", message: "Данные успешно изменены!", preset: .done)
        Amplify.DataStore.save(newPatient) { res in
            switch res {
            case .success(let patient):
                print("INDEX", self.index)
                listData.patientsList[self.index].fullname = patient.fullname
                listData.patientsList[self.index].phone = patient.phone
                alertView.duration = 3
                alertView.present()
                DispatchQueue.main.async {
                    compelition(true)
                }
                print("UPDATED PATIENT", patient)
            case .failure(let error):
                alertView = SPAlertView(title: "Ошибка", message: error.errorDescription, preset: .error)
                alertView.duration = 4
                alertView.present()
                DispatchQueue.main.async {
                    compelition(false)
                }
            }
        }
//        Amplify.DataStore.save(<#T##model: Model##Model#>)
        self.isLoading = false
    }
    func deletePatient(listData: PatientsListViewModel) {
        var alertView: SPAlertView = SPAlertView(title: "Успех", message: "Пациент успешно удален!", preset: .done)
        Amplify.DataStore.delete(Patient.self, withId: patient.id) { res in
            switch res {
            case .success:
                alertView.duration = 2
                alertView.present()
                listData.patientsList.remove(at: self.index)
            case .failure(let error):
                alertView = SPAlertView(title: "Ошибка", message: error.errorDescription, preset: .error)
                alertView.duration = 3.5
                alertView.present()
            }
        }
    }
////        Api().deletePatient(id: self.listData.patientsList![self.index].id) { (success, err) in
////            if err != nil {
//                alertView = SPAlertView(title: "Ошибка", message: "При удалении произошла ошибка!", preset: .error)
//                print(err!)
//            } else {
//                self.listData.patientsList!.remove(at: self.index)
//            }
//            alertView.duration = 1.5
//            alertView.present()
//        }

        
    }
    


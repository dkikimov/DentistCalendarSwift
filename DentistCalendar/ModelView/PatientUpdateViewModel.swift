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
    var error = ""
    
    var patient: Patient
    var index: Int
    var fullname: String = ""
    var phone: String = ""
    
//    init (patient: PatientData) {
//        self.patient = patient
//    }
    init(patient: Patient, index: Int) {
        self.patient = patient
        self.fullname = patient.fullname
        self.phone = patient.phone ?? ""
        self.index = index
    }
    func updatePatient(listData: PatientsListViewModel, compelition: @escaping(Bool) -> () ){
        self.isLoading = true
        let finalFullname = fullname.trimmingCharacters(in: .whitespaces)
        let finalPhone = phone.replacingOccurrences(of: " ", with: "")
        guard (finalFullname != patient.fullname || finalPhone != patient.phone)  else {
            error = "Имя и фамилия не были изменены".localized
            isAlertPresented = true
            isLoading = false
            return
        }
        guard !finalFullname.isEmpty && !finalPhone.isEmpty else {
            error = "Заполните форму".localized
            isAlertPresented = true
            isLoading = false
            return
        }
        var newPatient = patient
        newPatient.fullname = finalFullname
        newPatient.phone = finalPhone
        Amplify.DataStore.save(newPatient) { res in
            switch res {
            case .success(let patient):
                print("INDEX", self.index)
                listData.patientsList[self.index].fullname = patient.fullname
                listData.patientsList[self.index].phone = patient.phone
                presentSuccessAlert(message: "Данные успешно изменены!")
                DispatchQueue.main.async {
                    compelition(true)
                }
                print("UPDATED PATIENT", patient)
            case .failure(let error):
                presentErrorAlert(message: error.errorDescription)
                DispatchQueue.main.async {
                    compelition(false)
                }
            }
        }
//        Amplify.DataStore.save(<#T##model: Model##Model#>)
        self.isLoading = false
    }
    func deletePatient(listData: PatientsListViewModel) {
        Amplify.DataStore.delete(Patient.self, withId: patient.id) { res in
            switch res {
            case .success:
                presentSuccessAlert(message: "Пациент успешно удален!")
                listData.patientsList.remove(at: self.index)
            case .failure(let error):
                presentSuccessAlert(message: error.errorDescription)
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
    


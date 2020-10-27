//
//  PatientUpdateViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/25/20.
//




import SwiftUI
import SPAlert
class PatientUpdateViewModel : ObservableObject {

    @Published var isAlertPresented: Bool = false
    @Published var isLoading = false
    @Published var error = ""
    
    @Published var listData: PatientsListViewModel
    
    @Published  var fullname: String = ""
    @Published  var phone: String = ""
    @Published var index: Int
    @AppStorage("isLogged") var status = false
//    init (patient: PatientData) {
//        self.patient = patient
//    }
    init(patient: PatientsListViewModel, index: Int) {
        self.listData = patient
        self.index = index
        self.fullname = patient.patientsList![index].fullname
        self.phone = patient.patientsList![index].phone
    }
    func updatePatient(compelition: @escaping(Bool) -> () ){
        let alertView: SPAlertView = SPAlertView(title: "Успех", message: "Данные успешно изменены!", preset: .done)
        self.isLoading = true
        Api().updatePatient(fullname: self.fullname, phone: self.phone.replacingOccurrences(of: " ", with: ""), patient: self.listData.patientsList![index].id) { (success, errMessage) in
            print(success)
            if !success {
                if errMessage != "empty" {
                    self.error = errMessage!
                    self.isAlertPresented = true
                }
            }
            if success {
                self.listData.patientsList![self.index].fullname = self.fullname
                self.listData.patientsList![self.index].phone = self.phone.replacingOccurrences(of: " ", with: "")
                alertView.duration = 1.5
                alertView.present()
            }
            DispatchQueue.main.async {
                compelition(success)
            }
        }
        self.isLoading = false
    }
    func deletePatient() {
        var alertView: SPAlertView = SPAlertView(title: "Успех", message: "Пациент успешно удален!", preset: .done)
//        Api().deletePatient(id: self.listData.patientsList![self.index].id) { (success, err) in
//            if err != nil {
//                alertView = SPAlertView(title: "Ошибка", message: "При удалении произошла ошибка!", preset: .error)
//                print(err!)
//            } else {
//                self.listData.patientsList!.remove(at: self.index)
//            }
//            alertView.duration = 1.5
//            alertView.present()
//        }

        
    }
    
}

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
    var fullname: String = ""
    var phone: String = ""
    
    //    init (patient: PatientData) {
    //        self.patient = patient
    //    }
    init(patient: Patient) {
        self.patient = patient
        self.fullname = patient.fullname
        self.phone = patient.phone ?? ""
    }
    func updatePatient(listData: PatientsListViewModel, compelition: @escaping(Bool) -> () ){
        self.isLoading = true
        let finalFullname = fullname.trimmingCharacters(in: .whitespaces)
        var finalPhone: String = ""
        guard finalFullname.count <= patientNameMaxLength else {
            error = "Полное имя пациента слишком длинное";
            isAlertPresented = true
            return
        }
        if !phone.isEmpty {
            do {
                finalPhone = phoneNumberKit.format(try phoneNumberKit.parse(phone, ignoreType: true), toType: .e164)
            } catch {
                self.error = "Введите корректный номер".localized
                self.isAlertPresented = true
                self.isLoading = false
                return
            }
        }
        guard (finalFullname != patient.fullname || finalPhone != patient.phone)  else {
            DispatchQueue.main.async {
                compelition(true)
            }
            isLoading = false
            return
        }
        guard !finalFullname.isEmpty else {
            error = "Заполните форму".localized
            isAlertPresented = true
            isLoading = false
            return
        }
        var newPatient = patient
        newPatient.fullname = finalFullname
        newPatient.phone = finalPhone.isEmpty ? nil : finalPhone
        Amplify.DataStore.save(newPatient) { res in
            switch res {
            case .success:
                //                listData.patientsList[self.index].fullname = patient.fullname
                //                listData.patientsList[self.index].phone = patient.phone
                //                presentSuccessAlert(message: "Данные успешно изменены!")
                DispatchQueue.main.async {
                    compelition(true)
                }
            //                print("UPDATED PATIENT", patient)
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
                break
            //                presentSuccessAlert(message: "Пациент успешно удален!")
            //                listData.patientsList.remove(at: self.index)
            case .failure(let error):
                presentErrorAlert(message: error.errorDescription)
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



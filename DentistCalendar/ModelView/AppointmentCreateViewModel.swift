//
//  AppointmentCreateViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI
import Amplify
import SPAlert
import Combine


public func strFromDate(date: Date) -> String{
    return String(date.timeIntervalSince1970)
}
private func dateFromStr(date: String) -> Date {
    return Date(timeIntervalSince1970: Double(date)!)
}
class AppointmentCreateViewModel : ObservableObject {
    private var cancellable: AnyCancellable? = nil
    
    
    
    @Published var foundedPatientsList = [Patient]()
    @Published var patientName = ""
    @Published var patientPhone = ""
    @Published var price = ""
    @Published var toothNumber = ""
    @Published var dateStart = Date()
    @Published var dateEnd = Date().addingTimeInterval(3600)
    @Published var isFirstDatePresented = false
    @Published var isSecondDatePresented = false
    @Published var selectedDiagnosisList = [String]()
    @Published var isDiagnosisCreatePresented = false
    @Published var isAlertPresented: Bool = false
    @Published var error = ""
    
    var selectedPatient: Patient?
    
//    @Published var patient = PatientData(id: "1", fullname: "123", phone: "123", user: "123")
    var patient: Patient?
    var appointment: Appointment?
    var viewType: AppointmentType
    var group: DispatchGroup?
    
    init(patient: Patient?, viewType: AppointmentType, appointment: Appointment?, dateStart: Date?, dateEnd: Date?, group: DispatchGroup?) {
        self.viewType = viewType
        self.appointment = appointment
        if viewType != .createWithPatient {
            self.patient = patient!
        }
        if viewType == .edit {
            self.price = String(appointment!.price)
            self.toothNumber = String(appointment!.toothNumber)
            self.dateStart = dateFromStr(date: appointment!.dateStart)
            self.dateEnd = dateFromStr(date: appointment!.dateEnd)
            self.selectedDiagnosisList = appointment!.diagnosis.components(separatedBy: ", ")
        }
        if viewType == .createWithPatient {
            self.group = group
            cancellable = AnyCancellable(
                  $patientName.removeDuplicates()
                    .debounce(for: 0.5, scheduler: DispatchQueue.main)
                    .sink { searchText in
                        self.findPatientsByName(name: searchText)
                  })
            self.dateStart = dateStart ?? Date()
            self.dateEnd = dateEnd ?? Date().addingTimeInterval(3600)
        }
       
    }
    
    func createAppointment(isModalPresented: Binding<Bool>, patientDetailData: PatientDetailViewModel) {
        let newAppointment = Appointment(patientID: patient!.id, patient: patient!, toothNumber: Int(toothNumber)!, diagnosis: selectedDiagnosisList.joined(separator: ", "), price: Int(price)!, dateStart: strFromDate(date: dateStart), dateEnd: strFromDate(date: dateEnd))
        Amplify.DataStore.save(newAppointment){ res in
            switch res{
            case .success(let appointment):
                patientDetailData.appointments.append(appointment)
                let alertView: SPAlertView = SPAlertView(title: "Успех", message: "Запись успешно добавлена!", preset: .done)
                alertView.duration = 2
                alertView.present()
                isModalPresented.wrappedValue = false
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
    
    func updateAppointment(isModalPresented: Binding<Bool>, patientDetailData: PatientDetailViewModel) {
        var newAppointment = appointment!
        newAppointment.price = Int(price)!
        newAppointment.toothNumber = Int(toothNumber)!
        newAppointment.dateStart = strFromDate(date: dateStart)
        newAppointment.dateEnd = strFromDate(date: dateEnd)
        newAppointment.diagnosis = selectedDiagnosisList.joined(separator: ", ")
        Amplify.DataStore.save(newAppointment){ res in
            switch res{
            case .success(let app):
                patientDetailData.appointments[patientDetailData.appointments.firstIndex(of: self.appointment!)!] = app
                let alertView: SPAlertView = SPAlertView(title: "Успех", message: "Запись успешно обновлена!", preset: .done)
                alertView.duration = 2
                alertView.present()
                isModalPresented.wrappedValue = false
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
    func createAppointmentAndPatient() {
        print(group!)
        print("HEY I CRAETEded IT")
        if phoneNumberKit.isValidPhoneNumber(patientPhone) {
            if self.selectedPatient == nil {
                let newPatient = Patient(fullname: self.patientName, phone: self.patientPhone.replacingOccurrences(of: " ", with: ""))
                Amplify.DataStore.save(newPatient) { res in
                    switch res {
                    case .success(let patient):
                        let newAppointment = Appointment(patientID: patient.id, patient: patient, toothNumber: Int(self.toothNumber)!, diagnosis: self.selectedDiagnosisList.joined(separator: ", "), price: Int(self.price)!, dateStart: strFromDate(date: self.dateStart), dateEnd: strFromDate(date: self.dateEnd))
                        Amplify.DataStore.save(newAppointment) { result in
                            switch result {
                            case .success(let newApp):
                                newModel.appointment = newApp
    //                            newAppointmentModel.set(app: newApp, pat: newPatient)
                                print("SUCCESSFUL CREATION OF PATIENT AND APPOINTMENT!!!!!")
                                self.group!.leave()
                            case .failure(let error):
                                self.error = error.errorDescription
                                self.isAlertPresented = true
                                self.group!.leave()
                            }
                        }
                    case .failure(let error):
                        self.error = error.errorDescription
                        self.isAlertPresented = true
                        self.group!.leave()
                    }
                }
            } else if self.selectedPatient != nil {
                let newAppointment = Appointment(patientID: selectedPatient!.id, patient: selectedPatient!, toothNumber: Int(self.toothNumber)!, diagnosis: self.selectedDiagnosisList.joined(separator: ", "), price: Int(self.price)!, dateStart: strFromDate(date: self.dateStart), dateEnd: strFromDate(date: self.dateEnd))
                Amplify.DataStore.save(newAppointment) { result in
                    switch result {
                    case .success(let newApp):
                        newModel.appointment = newApp
                        print("SUCCESSFUL CREATION OF PATIENT AND APPOINTMENT!!!!!")
                        self.group!.leave()
                    case .failure(let error):
                        self.error = error.errorDescription
                        self.isAlertPresented = true
                        self.group!.leave()
                    }
                }
            }
        } else {
            error = "Введите корректный номер"
            isAlertPresented = true
        }
        print("I LEFT!!!")

        
    }
    func findPatientsByName(name: String) {
        if !name.isEmpty {
            Amplify.DataStore.query(Patient.self, where: Patient.keys.fullname.contains(name)) { res in
                switch res {
                case .success(let patientsList):
                    self.foundedPatientsList = patientsList
                case .failure(let error):
                    self.error = error.errorDescription
                    self.isAlertPresented = true
            }}
        } else {
            self.foundedPatientsList.removeAll()
        }
    }
}

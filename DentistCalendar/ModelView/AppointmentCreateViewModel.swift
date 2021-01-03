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
    var cancellable: AnyCancellable? = nil
    
    @Published var segmentedMode: CurrentSegmentedState = .withPatient
    
    @Published var foundedPatientsList = [Patient]()
    @Published var title = ""
    @Published var patientPhone = ""
    @Published var price = "0"
    @Published var toothNumber = ""
    @Published var dateStart = Date()
    @Published var dateEnd = Date().addingTimeInterval(3600)
    @Published var isFirstDatePresented = false
    @Published var isSecondDatePresented = false
    @Published var selectedDiagnosisList = [String: Favor]()
    @Published var isDiagnosisCreatePresented = false
    @Published var isAlertPresented: Bool = false
    @Published var error = ""
    
    var selectedPatient: Patient?
    @Published var sumPrices = 0
    @Published var sumPayments = 0
    //    @Published var patient = PatientData(id: "1", fullname: "123", phone: "123", user: "123")
    var patient: Patient?
    var appointment: Appointment?
    var viewType: AppointmentType
    var group: DispatchGroup?
//    var debouncedFunction = Debouncer(delay: 0.5)
    init(patient: Patient?, viewType: AppointmentType, appointment: Appointment?, dateStart: Date?, dateEnd: Date?, group: DispatchGroup?) {
        self.viewType = viewType
        self.appointment = appointment
        if viewType == .create {
            self.patient = patient!
        }
        if viewType == .edit || viewType == .editCalendar{
            if appointment!.patientID == nil {
                if appointment!.patientID == nil {
                    self.segmentedMode = .nonPatient
                }
                self.dateStart = dateFromStr(date: appointment!.dateStart)
                self.dateEnd = dateFromStr(date: appointment!.dateEnd)
                self.title = appointment!.title
            } else {
                self.title = patient?.fullname ?? " "
                self.price = String(appointment!.price!)
                self.toothNumber = String(appointment!.toothNumber!)
                self.dateStart = dateFromStr(date: appointment!.dateStart)
                self.dateEnd = dateFromStr(date: appointment!.dateEnd)
                //                self.selectedDiagnosisList = appointment!.diagnosis!.components(separatedBy: ", ")
                for diagnosis in appointment!.diagnosis!.components(separatedBy: ";") {
                    let diagData = diagnosis.split(separator: ":")
                    if diagData.count == 3 {
                        selectedDiagnosisList[String(diagData[0])] = Favor(price: Int32(diagData[1])!, prePayment: String(diagData[2]))
                    }
                    else if diagData.count == 2 {
                        selectedDiagnosisList[String(diagData[0])] = Favor(price: Int32(diagData[1])!, prePayment: "0")
                    }
                     else if diagData.count == 1{
                            selectedDiagnosisList[String(diagData[0])] = Favor(price: 0, prePayment: "0")
                    }
                }
                generateMoneyData()
            }
            
            
        }
        if viewType == .createWithPatient {
            self.group = group
            cancellable = AnyCancellable(
                $title.removeDuplicates()
                    .debounce(for: 0.5, scheduler: DispatchQueue.main)
                    .sink { searchText in
                        self.findPatientsByName(name: searchText)
                    })
            self.dateStart = dateStart ?? Date()
            self.dateEnd = dateEnd ?? Date().addingTimeInterval(3600)
//            self.debouncedFunction = Debouncer(delay: 0.50) {
//                self.findPatientsByName()
//            }
//            self.debouncedFunction.callback = {
//                self.findPatientsByName()
//            }
        }
    }
    
    func createAppointment(isModalPresented: Binding<Bool>, patientDetailData: PatientDetailViewModel) {
        let newAppointment = Appointment(title: patient!.fullname, patientID: patient!.id, toothNumber: toothNumber.trimmingCharacters(in: .whitespaces),
                                         diagnosis: generateDiagnosisString(),
                                         price: Int(price)!, dateStart: strFromDate(date: dateStart), dateEnd: strFromDate(date: dateEnd))
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
    
    func updateAppointment(isModalPresented: Binding<Bool>, patientDetailData: PatientDetailViewModel?) {
        var newAppointment = appointment!
        newAppointment.price = Int(price)!
        newAppointment.toothNumber = toothNumber.trimmingCharacters(in: .whitespaces)
        newAppointment.dateStart = strFromDate(date: dateStart)
        newAppointment.dateEnd = strFromDate(date: dateEnd)
        newAppointment.diagnosis = generateDiagnosisString()
        Amplify.DataStore.save(newAppointment){ res in
            switch res{
            case .success(let app):
                if patientDetailData != nil {
                    patientDetailData!.appointments[patientDetailData!.appointments.firstIndex(of: self.appointment!)!] = app
                }
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
    func updateAppointmentCalendar(isModalPresented: Binding<Bool>, appointment: Binding<Appointment>) {
        var newAppointment = self.appointment!
        if newAppointment.patientID != nil {
            newAppointment.price = Int(price)!
            newAppointment.toothNumber = toothNumber.trimmingCharacters(in: .whitespaces)
            newAppointment.diagnosis = generateDiagnosisString()
        } else {
            newAppointment.title = title
        }
        newAppointment.dateStart = strFromDate(date: dateStart)
        newAppointment.dateEnd = strFromDate(date: dateEnd)
        Amplify.DataStore.save(newAppointment){ res in
            switch res{
            case .success(let app):
                DispatchQueue.main.async {
                    appointment.wrappedValue = app
                }
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
        print("PHONE", patientPhone)
        print(phoneNumberKit.isValidPhoneNumber(patientPhone))
        if phoneNumberKit.isValidPhoneNumber(patientPhone) {
            if self.selectedPatient == nil {
                let newPatient = Patient(fullname: self.title, phone: self.patientPhone.replacingOccurrences(of: " ", with: ""))
                Amplify.DataStore.save(newPatient) { [self] res in
                    switch res {
                    case .success(let patient):
                        let newAppointment = Appointment(title: patient.fullname, patientID: patient.id, toothNumber: self.toothNumber.trimmingCharacters(in: .whitespaces), diagnosis: generateDiagnosisString(), price: Int(self.price)!, dateStart: strFromDate(date: self.dateStart), dateEnd: strFromDate(date: self.dateEnd))
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
                let newAppointment = Appointment(title: selectedPatient!.fullname, patientID: selectedPatient!.id, toothNumber: self.toothNumber.trimmingCharacters(in: .whitespaces), diagnosis: generateDiagnosisString(), price: Int(self.price)!, dateStart: strFromDate(date: self.dateStart), dateEnd: strFromDate(date: self.dateEnd))
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
            print("NUMBER", patientPhone)
            error = "Введите корректный номер"
            isAlertPresented = true
        }
        print("I LEFT!!!")
        
        
    }
    
    func createNonPatientAppointment(isModalPresented: Binding<Bool>) {
        let newAppointment = Appointment(title: title, dateStart: strFromDate(date: dateStart), dateEnd: strFromDate(date: dateEnd))
        Amplify.DataStore.save(newAppointment) { res in
            switch res {
            case .success:
                print("Successful creation")
                isModalPresented.wrappedValue = false
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
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
    func generateDiagnosisString(_ onlyTitle: Bool = false) -> String {
        var res: String = ""
        return selectedDiagnosisList.map {$0.key.trimmingCharacters(in: .whitespaces) + ":" + String($0.value.price).trimmingCharacters(in: .whitespaces)  + ($0.value.prePayment.isEmpty ? "" : ":" + $0.value.prePayment.trimmingCharacters(in: .whitespaces) )}
            .joined(separator: ";")
        
    }
    
    func generateMoneyData(){
        var sumPayments = 0
        var sumPrices = 0
        selectedDiagnosisList.map {
            sumPayments +=  Int($1.prePayment) ?? 0
            sumPrices += Int($1.price)
        }
        self.sumPrices = sumPrices
        self.sumPayments = sumPayments
    }
}

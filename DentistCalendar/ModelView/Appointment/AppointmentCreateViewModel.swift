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

class DiagnosisItem: ObservableObject, Identifiable {
    var id = UUID()
    var key: String
    @Published var amount: Int
    @Published var price: String
    
    init(key: String, amount: Int, price: String) {
        self.key = key
        self.amount = amount
        self.price = price
    }
}

class AppointmentCreateViewModel : ObservableObject {
    var cancellable: AnyCancellable? = nil
    
    @Published var segmentedMode: CurrentSegmentedState = .withPatient
    
    @Published var foundedPatientsList = [Patient]()
    var title = ""
    var toothNumber = ""
    @Published var dateStart = Date()
    @Published var dateEnd = Date().addingTimeInterval(3600)
    @Published var isFirstDatePresented = false
    @Published var isSecondDatePresented = false
    @Published var selectedDiagnosisList = [DiagnosisItem]()
    @Published var isDiagnosisCreatePresented = false
    @Published var error = ""
    @Published var isAlertPresented = false
    @Published var phoneNumber = ""
    var id = UUID().uuidString
    var startPaymentsArray = [PaymentModel]()
    @Published var paymentsArray = [PaymentModel]()
    @Published var selectedPatient: Patient?
    @Published var sumPrices: Decimal = 0
    @Published var sumPayment: Decimal = 0
    var didSave: Bool = false
    var patient: Patient?
    var appointment: Appointment?
    var viewType: AppointmentType
    var group: DispatchGroup?
    var debouncedFunction: Debouncer?
    
    
    var generateMoneyData = Debouncer(delay: 0.5)
    init(patient: Patient?, viewType: AppointmentType, appointment: Appointment?, dateStart: Date?, dateEnd: Date?, group: DispatchGroup?) {
        self.viewType = viewType
        self.appointment = appointment
        self.generateMoneyData = Debouncer(delay: 0.50) {
            self.generateMoneyDataFunc()
        }
        if viewType == .create {
            self.patient = patient!
        }
        if viewType == .edit || viewType == .editCalendar{
            self.id = appointment!.id
            if appointment!.patientID == nil {
                if appointment!.patientID == nil {
                    self.segmentedMode = .nonPatient
                }
                self.dateStart = dateFromStr(date: appointment!.dateStart)
                self.dateEnd = dateFromStr(date: appointment!.dateEnd)
                self.title = appointment!.title ?? ""
            } else {
                self.title = patient?.fullname ?? " "
                self.toothNumber = String(appointment!.toothNumber!)
                self.dateStart = dateFromStr(date: appointment!.dateStart)
                self.dateEnd = dateFromStr(date: appointment!.dateEnd)
                if appointment?.payments != nil {
                    if let payments = appointment!.payments {
                        for payment in payments {
                            self.paymentsArray.insert(PaymentModel(id: payment.id, cost: payment.cost, date: payment.date), at: 0)
                        }
                    }
                    self.startPaymentsArray = self.paymentsArray
                }
                for diagnosis in appointment!.diagnosis!.components(separatedBy: ";") {
                    var amount = "1"
                    var dataString = diagnosis
                    if let index = diagnosis.firstIndex(of: "*") {
                        let leftIndex = diagnosis.index(after: index)
                        amount = String(diagnosis[leftIndex...])
                        dataString = String(diagnosis[..<index])
                    }
                    
                    let diagData = dataString.split(separator: ":")
                    
                    if diagData.count >= 2 {
                        selectedDiagnosisList.append(DiagnosisItem(key: String(diagData[0]), amount: Int(amount) ?? 0, price: String(diagData[1])))
                    }
                    else if diagData.count == 1 {
                        selectedDiagnosisList.append(DiagnosisItem(key: String(diagData[0]), amount: Int(amount) ?? 0, price: "0"))
                    }
                }
                generateMoneyData.call()
            }
        }
        if viewType == .createWithPatient {
            self.group = group
            self.debouncedFunction = Debouncer(delay: 0.5) {
                self.findPatientsByName(name: self.title)
                if self.selectedPatient?.fullname != self.title{
                    self.selectedPatient = nil
                }
            }
            self.dateStart = dateStart ?? Date()
            self.dateEnd = dateEnd ?? Date().addingTimeInterval(3600)
        }
    }
    
    func createAppointment(isModalPresented: Binding<Bool>, patientDetailData: PatientDetailViewModel) {
        let newAppointment = Appointment(
            id: id, patientID: patient!.id, toothNumber: toothNumber.trimmingCharacters(in: .whitespaces),
            diagnosis: generateDiagnosisString(), dateStart: strFromDate(date: dateStart), dateEnd: strFromDate(date: dateEnd))
        Amplify.DataStore.save(newAppointment){ res in
            switch res{
            case .success(let appointment):
                self.savePayments(appointment: appointment)
                patientDetailData.appointments.append(self.getAppointmentWithPayments(id: appointment.id) ?? appointment)
                self.didSave = true
                
                isModalPresented.wrappedValue = false
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
    
    func updateAppointment(isModalPresented: Binding<Bool>, patientDetailData: PatientDetailViewModel?) {
        var newAppointment = appointment!
        newAppointment.toothNumber = toothNumber.trimmingCharacters(in: .whitespaces)
        newAppointment.dateStart = strFromDate(date: dateStart)
        newAppointment.dateEnd = strFromDate(date: dateEnd)
        newAppointment.diagnosis = generateDiagnosisString()
        
        Amplify.DataStore.save(newAppointment){ res in
            switch res{
            case .success(let app):
                self.savePayments(appointment: app)
                if patientDetailData != nil {
                    patientDetailData!.appointments[patientDetailData!.appointments.firstIndex(of: self.appointment!)!] = self.getAppointmentWithPayments(id: app.id) ?? app
                }
                self.didSave = true
                
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
            newAppointment.toothNumber = toothNumber.trimmingCharacters(in: .whitespaces)
            newAppointment.diagnosis = generateDiagnosisString()
        } else {
            newAppointment.title = title
        }
        newAppointment.dateStart = strFromDate(date: dateStart)
        newAppointment.dateEnd = strFromDate(date: dateEnd)
        Amplify.DataStore.save(newAppointment){ res in
            switch res {
            case .success(let app):
                DispatchQueue.main.async {
                    self.didSave = true
                    isModalPresented.wrappedValue = false
                    self.savePayments(appointment: app)
                    appointment.wrappedValue = self.getAppointmentWithPayments(id: self.id) ?? app
                }
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
    func createAppointmentAndPatient(isModalPresented: Binding<Bool>, phoneNumber: String) {
        if self.selectedPatient == nil {
            let newPatient: Patient
            newPatient = Patient(fullname: self.title.capitalized, phone: phoneNumber.isEmpty ? nil : phoneNumber)
            Amplify.DataStore.save(newPatient) { [self] res in
                switch res {
                case .success(let patient):
                    let newAppointment = Appointment(id: id, patientID: patient.id, toothNumber: self.toothNumber.trimmingCharacters(in: .whitespaces), diagnosis: generateDiagnosisString(), dateStart: strFromDate(date: self.dateStart), dateEnd: strFromDate(date: self.dateEnd))
                    Amplify.DataStore.save(newAppointment) { result in
                        switch result {
                        case .success:
                            self.savePayments(appointment: newAppointment)
                            self.didSave = true
                            print("SUCCESSFUL CREATION OF PATIENT AND APPOINTMENT!!!!!")
                            isModalPresented.wrappedValue = false
                            DispatchQueue.main.async {
                                self.group?.leave()
                            }
                            
                        case .failure(let error):
                            self.error = error.errorDescription
                            self.isAlertPresented = true
                        }
                    }
                case .failure(let error):
                    self.error = error.errorDescription
                    self.isAlertPresented = true
                }
            }
        } else if self.selectedPatient != nil {
            let newAppointment = Appointment(id: id, title: selectedPatient!.fullname, patientID: selectedPatient!.id, toothNumber: self.toothNumber.trimmingCharacters(in: .whitespaces), diagnosis: generateDiagnosisString(), dateStart: strFromDate(date: self.dateStart), dateEnd: strFromDate(date: self.dateEnd))
            Amplify.DataStore.save(newAppointment) { result in
                switch result {
                case .success:
                    self.savePayments(appointment: newAppointment)
                    DispatchQueue.main.async {
                        self.group?.leave()
                    }
                case .failure(let error):
                    self.error = error.errorDescription
                    self.isAlertPresented = true
                }
            }
        }
        
        
    }
    
    func createNonPatientAppointment(isModalPresented: Binding<Bool>) {
        let newAppointment = Appointment(id: id, title: title, dateStart: strFromDate(date: dateStart), dateEnd: strFromDate(date: dateEnd))
        Amplify.DataStore.save(newAppointment) { res in
            switch res {
            case .success:
                self.didSave = true
                
                isModalPresented.wrappedValue = false

            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
    func savePayments(appointment: Appointment) {
        let difference = paymentsArray.difference(from: startPaymentsArray)
        for change in difference {
            switch change {
            case let .insert(_, payment, _):
                let newPayment = Payment(appointmentID: id, cost: payment.cost, date: payment.date)
                Amplify.DataStore.save(newPayment) { res in
                    switch res {
                    case .failure(let err):
                        self.error = err.errorDescription
                        self.isAlertPresented = true
                    default: break
                    }
                }
            case let .remove(_, payment, _):
                Amplify.DataStore.delete(Payment.self, withId: payment.id) { (res) in
                    print("RES ", res)
                    switch res {
                    case .success:
                    case .failure(let err):
                        self.error = err.localizedDescription
                        self.isAlertPresented = true
                    }
                }
            }
        }
    }
    
    
    func findPatientsByName(name: String) {
        if !name.isEmpty {
            Amplify.DataStore.query(Patient.self, where: Patient.keys.fullname.contains(name.capitalized)) { res in
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
    func generateDiagnosisString() -> String {
        return selectedDiagnosisList.map{$0.key.trimmingCharacters(in: .whitespaces) + ($0.price.decimalValue.stringValue == "0" || ($0.price.decimalValue.stringValue.isEmpty) ? "" : ":" + $0.price.decimalValue.stringValue + ($0.amount == 1 ? "" : "*" + String($0.amount)))}
            .joined(separator: ";")
    }
    
    func generateMoneyDataFunc() {
        var sumPrices: Decimal = 0
        var sumPayment: Decimal = 0
        _ = selectedDiagnosisList.map {
            sumPrices += ($0.price.decimalValue * Decimal($0.amount))
        }
        for payment in paymentsArray {
            sumPayment += payment.cost.decimalValue
        }
        self.sumPrices = sumPrices
        self.sumPayment = sumPayment
    }
    func getAppointmentWithPayments(id: String) -> Appointment? {
        var res: Appointment?
        Amplify.DataStore.query(Appointment.self, byId: id) { result in
            switch result {
            case .failure:
                break
            case .success(let app):
                res = app
            }
        }
        return res
    }
    
}

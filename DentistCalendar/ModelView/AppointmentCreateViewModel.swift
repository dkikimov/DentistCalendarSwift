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
    var title = ""
    var price = "0"
    var toothNumber = ""
    @Published var dateStart = Date()
    @Published var dateEnd = Date().addingTimeInterval(3600)
    @Published var isFirstDatePresented = false
    @Published var isSecondDatePresented = false
    var selectedDiagnosisList = [String: String]()
    @Published var isDiagnosisCreatePresented = false
    @Published var isAlertPresented: Bool = false
    @Published var error = ""
    
    var id = UUID().uuidString
    var startPaymentsArray = [PaymentModel]()
    //    @Published var isPaidFully: Bool = false
    @Published var paymentsArray = [PaymentModel]()
    @Published var selectedPatient: Patient?
    @Published var sumPrices: Decimal = 0
    @Published var sumPayment: Decimal = 0
    var didSave: Bool = false
    //    @Published var patient = PatientData(id: "1", fullname: "123", phone: "123", user: "123")
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
                self.title = appointment!.title
            } else {
                self.title = patient?.fullname ?? " "
                self.price = String(appointment!.price!)
                self.toothNumber = String(appointment!.toothNumber!)
                self.dateStart = dateFromStr(date: appointment!.dateStart)
                self.dateEnd = dateFromStr(date: appointment!.dateEnd)
                if appointment?.payments != nil {
                    if let payments = appointment!.payments {
                        for payment in payments {
                            self.paymentsArray.insert(PaymentModel(id: payment.id, cost: payment.cost, date: payment.date), at: 0)
                        }
                    }
                    //                    self.paymentsArray = getPayments(appointmentID: appointment!.id)
                    self.startPaymentsArray = self.paymentsArray
                }
                //                self.selectedDiagnosisList = appointment!.diagnosis!.components(separatedBy: ", ")
                for diagnosis in appointment!.diagnosis!.components(separatedBy: ";") {
                    let diagData = diagnosis.split(separator: ":")
                    if diagData.count >= 2 {
                        selectedDiagnosisList[String(diagData[0])] = String(diagData[1])
                    }
                    else if diagData.count == 1{
                        selectedDiagnosisList[String(diagData[0])] = "0"
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
                    //                                    data.debouncedFunction.call()
                }
            }
            //            cancellable = AnyCancellable(
            //                title.removeDuplicates()
            //                    .debounce(for: 0.5, scheduler: DispatchQueue.main)
            //                    .sink { searchText in
            //                        self.findPatientsByName(name: searchText)
            //                    })
            self.dateStart = dateStart ?? Date()
            self.dateEnd = dateEnd ?? Date().addingTimeInterval(3600)
            
            //            self.debouncedFunction.callback = {
            //                self.findPatientsByName()
            //            }
        }
    }
    
    func createAppointment(isModalPresented: Binding<Bool>, patientDetailData: PatientDetailViewModel) {
        let newAppointment = Appointment(
            id: id, title: patient!.fullname, patientID: patient!.id, toothNumber: toothNumber.trimmingCharacters(in: .whitespaces),
            diagnosis: generateDiagnosisString(),
             price: Int(price)!, dateStart: strFromDate(date: dateStart), dateEnd: strFromDate(date: dateEnd))
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
        newAppointment.price = Int(price)!
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
                presentSuccessAlert(message: "Запись успешно добавлена!")
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
                self.savePayments(appointment: app)
                DispatchQueue.main.async {
                    appointment.wrappedValue = self.getAppointmentWithPayments(id: self.id) ?? app
                }
                self.didSave = true
                isModalPresented.wrappedValue = false
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
    func createAppointmentAndPatient(phoneNumber: String) {
        print(group!)
        print("HEY I CRAETEded IT")
        //        print("PHONE", patientPhone)
        //        print(phoneNumberKit.isValidPhoneNumber(patientPhone))
        
        
        if self.selectedPatient == nil {
            let newPatient = Patient(fullname: self.title, phone: phoneNumber.replacingOccurrences(of: " ", with: ""))
            Amplify.DataStore.save(newPatient) { [self] res in
                switch res {
                case .success(let patient):
                    let newAppointment = Appointment(id: id, title: patient.fullname, patientID: patient.id, toothNumber: self.toothNumber.trimmingCharacters(in: .whitespaces), diagnosis: generateDiagnosisString(), price: Int(self.price)!, dateStart: strFromDate(date: self.dateStart), dateEnd: strFromDate(date: self.dateEnd))
                    Amplify.DataStore.save(newAppointment) { result in
                        switch result {
                        case .success:
                            self.savePayments(appointment: newAppointment)
                            self.didSave = true
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
            let newAppointment = Appointment(id: id, title: selectedPatient!.fullname, patientID: selectedPatient!.id, toothNumber: self.toothNumber.trimmingCharacters(in: .whitespaces), diagnosis: generateDiagnosisString(), price: Int(self.price)!, dateStart: strFromDate(date: self.dateStart), dateEnd: strFromDate(date: self.dateEnd))
            Amplify.DataStore.save(newAppointment) { result in
                switch result {
                case .success:
                    self.savePayments(appointment: newAppointment)
                    print("SUCCESSFUL CREATION OF PATIENT AND APPOINTMENT!!!!!")
                    self.group!.leave()
                case .failure(let error):
                    self.error = error.errorDescription
                    self.isAlertPresented = true
                    self.group!.leave()
                }
            }
        }
        
        print("I LEFT!!!")
        
        
    }
    
    func createNonPatientAppointment(isModalPresented: Binding<Bool>) {
        let newAppointment = Appointment(id: id, title: title, dateStart: strFromDate(date: dateStart), dateEnd: strFromDate(date: dateEnd))
        Amplify.DataStore.save(newAppointment) { res in
            switch res {
            case .success:
                print("Successful creation")
                self.didSave = true
                
                isModalPresented.wrappedValue = false
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
//    func getPayments(appointmentID: String) -> [Payment] {
//        var res = [Payment]()
//        Amplify.DataStore.query(Payment.self, where: Payment.keys.appointmentID == appointmentID){ result in
//            switch result {
//            case .success(let payments):
//                res = payments
//            case .failure(let error):
//                self.error = error.errorDescription
//                self.isAlertPresented = true
//            }
//        }
//        return res
//    }
    func savePayments(appointment: Appointment) {
        let difference = paymentsArray.difference(from: startPaymentsArray)
        print("PAYMENTS ARRAY", paymentsArray)
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
                        print("DELETE SUCCESS")
                    case .failure(let err):
                        self.error = err.localizedDescription
                        self.isAlertPresented = true
                    }
                }
                print("DELETE PAYMENT ", payment)
            }
        }
        //        for payment in paymentsArray {
        //            Amplify.DataStore.save(payment) { res in
        //                switch res {
        //                case .failure(let err):
        //                    self.error = err.errorDescription
        //                    self.isAlertPresented = true
        //                default: break
        //                }
        //            }
        //        }
        //        Amplify.DataStore.save(paymentsArray)
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
        //        return selectedDiagnosisList.map {$0.key.trimmingCharacters(in: .whitespaces) + ":" +
        //            NSDecimalNumber(string: $0.value.price.isEmpty ? "0" : String($0.value.price.trimmingCharacters(in: .whitespaces).doubleValue)).stringValue}
        //            .joined(separator: ";")
        
        return selectedDiagnosisList.map{$0.key.trimmingCharacters(in: .whitespaces) + ($0.value == "0" || $0.value.isEmpty ? "" : ":" + $0.value)}
            .joined(separator: ";")
    }
    
    func generateMoneyDataFunc() {
        var sumPrices: Decimal = 0
        var sumPayment: Decimal = 0
        _ = selectedDiagnosisList.map {
            sumPrices += Decimal(string: $1) ?? 0
        }
        for payment in paymentsArray {
            sumPayment += Decimal(string: payment.cost) ?? 0
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

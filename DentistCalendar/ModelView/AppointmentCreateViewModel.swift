//
//  AppointmentCreateViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI
import Amplify
import SPAlert
private func strFromDate(date: Date) -> String{
    return String(date.timeIntervalSince1970)
}

class AppointmentCreateViewModel : ObservableObject {
    
    @Published var price = ""
    @Published var toothNumber = ""
    @Published var dateStart = Date()
    @Published var dateEnd = Date().addingTimeInterval(3600)
    @Published var isFirstDatePresented = false
    @Published var isSecondDatePresented = false
    @Published var selectedDiagnosisList = [Diagnosis]()
    @Published var isDiagnosisCreatePresented = false
    @Published var isAlertPresented: Bool = false
    @Published var error = ""
//    @Published var patient = PatientData(id: "1", fullname: "123", phone: "123", user: "123")
    var patientID: String
    init(patientID: String) {
        self.patientID = patientID
    }
    func createAppointment(isModalPresented: Binding<Bool>, patientDetailData: PatientDetailViewModel) {
        let newAppointment = Appointment(patientID: patientID, toothNumber: Int(toothNumber)!, diagnosis: selectedDiagnosisList.map { String($0.text!) }.joined(separator: ", "), price: Int(price)!, dateStart: strFromDate(date: dateStart), dateEnd: strFromDate(date: dateEnd))
        Amplify.DataStore.save(newAppointment){ res in
            switch res{
            case .success(let appointment):
                patientDetailData.appointments.append(appointment)
                let alertView: SPAlertView = SPAlertView(title: "Успех", message: "Запись успешно добавлена!", preset: .done)
                alertView.duration = 3
                alertView.present()
                isModalPresented.wrappedValue = false
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
    
    
}

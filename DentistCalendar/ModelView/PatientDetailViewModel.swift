//
//  PatientDetailViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/21/20.
//

import SwiftUI
import Amplify
class PatientDetailViewModel : ObservableObject {
    
    @Published  var appointments = [Appointment]()

    @Published var isAlertPresented: Bool = false
    @Published var isSheetPresented: Bool = false
    @Published var isLoading = false
    @Published var error = ""
    @State var patient: Patient
//    @Published var patient = PatientData(id: "1", fullname: "123", phone: "123", user: "123")
    init(patient: Patient) {
        self.patient = patient
        fetchAppointments()
    }
    
    @AppStorage("isLogged") var status = false
    func fetchAppointments() {
        self.isLoading = true
        Amplify.DataStore.query(Appointment.self, where: Appointment.keys.patientID == patient.id) { res in
            switch res{
            case .success(let appointments):
                self.appointments = appointments
            case .failure(let err):
                print("DETAILVIEWMODEL ERROR", err)
                self.error = err.errorDescription
                self.isAlertPresented = true
            }
        }
        self.isLoading = false
    }
    
    
}

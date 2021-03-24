//
//  PatientDetailViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/21/20.
//

import SwiftUI
import Amplify
import SPAlert
class PatientDetailViewModel : ObservableObject {
    
    @Published  var appointments = [Appointment]()
    
    @Published var viewType: AppointmentType = .create
    @Published var selectedAppointment: Appointment?
    @Published var isAlertPresented: Bool = false
    @Published var isModalPresented: Bool = false
    @Published var isSheetPresented: Bool = false
    @Published var isDetailViewPresented: Bool = false
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
        Amplify.DataStore.query(Appointment.self, where: Appointment.keys.patientID == patient.id, sort: .descending(Appointment.keys.dateStart)) { res in
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
    func deleteAppointment() {
        if let appoint = selectedAppointment {
            Amplify.DataStore.delete(Appointment.self, withId: appoint.id) { res in
                switch res {
                case .success:
//                    presentSuccessAlert(message: "Запись успешно удалена!")
                    self.appointments = self.appointments.filter({ (app) -> Bool in
                        app.id != appoint.id
                    })
                case .failure(let error):
                    presentErrorAlert(message: error.errorDescription)
                }}
        } else {
            print("Error")
        }
    }
    
}

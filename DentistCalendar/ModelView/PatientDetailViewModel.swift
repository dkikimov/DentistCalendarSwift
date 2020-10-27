//
//  PatientDetailViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/21/20.
//

import SwiftUI

class PatientDetailViewModel : ObservableObject {
    
    @Published var appointments: Array<AppointmentData>? = nil
    @Published var isAlertPresented: Bool = false
    @Published var isSheetPresented: Bool = false
    @Published var isLoading = true
    @Published var error = ""
    
    @Published var patient: PatientData
    
    
    @AppStorage("isLogged") var status = false
    init (patient: PatientData) {
        self.patient = patient
        
    }
    func fetchAppointments() {
        self.isLoading = true
        Api().fetchAppointments(patient: self.patient.id) { (appointments, errMessage) in
            if errMessage != nil {
                if errMessage != "empty" {
                    self.error = errMessage!
                    self.isAlertPresented = true
                    
                }
            }
            else if appointments != nil {
                self.appointments = appointments!

            }
            self.isLoading = false

        }
    }
    
    
}

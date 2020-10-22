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
    @AppStorage("isLogged") var status = false
    
    func fetchAppointments(patient: String) {
        self.isLoading = true
        Api().fetchAppointments(patient: patient) { (appointments, errMessage) in
            if errMessage != nil {
                if errMessage == "empty" {
                    self.status = false
                } else {
                    self.error = errMessage!
                    self.isAlertPresented = true
                }

            }
            else if errMessage == nil && appointments == nil {
                self.appointments = []
            }
            else {

                self.appointments = appointments!
            }
        }
        self.isLoading = false
    }
    
    
}

//
//  AppointmentCalendarViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 07.12.2020.
//

import SwiftUI
import Amplify
import SPAlert
class AppointmentCalendarViewModel: ObservableObject {
    @Published var isSheetPresented = false
    @Published var error = ""
    @Published var isAlertPresented = false
    @Published var isActionSheetPresented = false
    var fullScreenIsCalendar: Binding<Bool>?
    var isEditAllowed: Bool
    @Published var appointment: Appointment
    
    init(appointment: Appointment, isEditAllowed: Bool, fullScreenIsCalendar: Binding<Bool>?) {
        self.appointment = appointment
        self.isEditAllowed = isEditAllowed
        self.fullScreenIsCalendar = fullScreenIsCalendar
    }
    
    func deleteAppointment(presentationMode: Binding<PresentationMode>) {
        Amplify.DataStore.delete(appointment) { res in
            switch res {
            case .success:
                DispatchQueue.main.async {
                    presentSuccessAlert(message: "Запись успешно удалена!")
                    print("DELETED")
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                print("ERROR", error.localizedDescription)
                self.error = error.localizedDescription
                self.isAlertPresented = true
        }}
    }
}

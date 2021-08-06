//
//  PatientDetailViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/21/20.
//

import SwiftUI
import Amplify
import SPAlert
import Combine



class PatientDetailViewModel : ObservableObject {
    
    @Published  var appointments = [Appointment]()
    @Published var sumServices = [Int: (String, String)]()
    @Published var viewType: AppointmentType = .create
    @Published var selectedAppointment: Appointment?
    @Published var isAlertPresented: Bool = false
    @Published var isModalPresented: Bool = false
    @Published var isSheetPresented: Bool = false
    @Published var isDetailViewPresented: Bool = false
    @Published var isLoading = false
    @Published var error = ""
    @State var patient: Patient
    var observationToken: AnyCancellable?
    //    @Published var patient = PatientData(id: "1", fullname: "123", phone: "123", user: "123")
    init(patient: Patient) {
        self.patient = patient
        fetchAppointments()
        observeAppointments()
    }
    deinit {
        observationToken?.cancel()
    }
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
                    DispatchQueue.main.async {
                        self.appointments = self.appointments.filter({ (app) -> Bool in
                            app.id != appoint.id
                        })
                    }
                case .failure(let error):
                    presentErrorAlert(message: error.errorDescription)
                }}
        } else {
            print("Error")
        }
    }
    func observeAppointments() {
        observationToken = Amplify.DataStore.publisher(for: Appointment.self)
            .sink { (completion) in
                if case .failure(let error) = completion {
                    print("ERROR IN OBSERVE PATIENTS", error.errorDescription)
                }
            } receiveValue: { (changes) in
//                print("CHANGES ", changes)
                guard let app = try? changes.decodeModel(as: Appointment.self) else {return}
                var resultAppointment = app
                if app.patientID == self.patient.id {
                    switch changes.mutationType {
                    case "update":
                        DispatchQueue.main.async {
                            if let index = self.appointments.firstIndex(where: {$0.id == app.id}) {
                                Amplify.DataStore.query(Payment.self, where: Payment.keys.appointmentID == app.id) { result in
                                    switch result {
                                    case .success(let payments):
                                        resultAppointment.payments = List(elements: payments)
                                    case .failure(let error):
                                        self.error = error.localizedDescription
                                        self.isAlertPresented = true
                                        return
                                    }
                                }
//                                self.appointments[index] = Appointment(id: "123", title: "ЛОЛ КЕК", patientID: "", owner: "", toothNumber: "13", diagnosis: "13", price: 13, dateStart: "123", dateEnd: "123", payments: nil)
                                let sumData = countBilling(appointment: resultAppointment)
                                self.sumServices[index] = (sumData.0.currencyFormatted , sumData.1.currencyFormatted)
                                self.appointments[index] = resultAppointment
                                
                            }
                        }
                        break
                    default:
                        break
                    }
                }
            }
    }
    func binded(app: Appointment) -> Binding<Appointment> {
            Binding(
                get: { self.appointments[self.appointments.firstIndex(of: app)!] },
                set: { self.appointments[self.appointments.firstIndex(of: app)!] = $0 }
            )
        }
}

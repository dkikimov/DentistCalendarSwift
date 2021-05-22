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
    }
    deinit {
        observationToken?.cancel()
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
//    func observeAppointments() {
//        observationToken = Amplify.DataStore.publisher(for: Patient.self)
//            .sink { (completion) in
//                if case .failure(let error) = completion {
//                    print("ERROR IN OBSERVE PATIENTS", error.errorDescription)
//                }
//            } receiveValue: { (changes) in
//                print("CHANGES ", changes)
//                guard let pat = try? changes.decodeModel(as: Appointment.self) else {return}
//                
//                switch changes.mutationType {
//                case "create":
//                    print("NEW PATIENT", pat)
//                    if !self.appointments.contains(where: { (patient) -> Bool in
//                        patient.id == pat.id
//                    }) {
//                        DispatchQueue.main.async {
//                            self.patientsList.append(pat)
//                            if !self.isSearching {
//                                self.filteredItems.append(pat)
//                            }
//                        }
//                    }
//                    break
//                case "delete":
//                    DispatchQueue.main.async {
//                        if let index = self.patientsList.firstIndex(where: {$0.id == pat.id}) {
//                            self.patientsList.remove(at: index)
//                            if !self.isSearching {
//                                self.filteredItems.remove(at: index)
//                            }
//                        }
//                        if self.isSearching {
//                            if let index = self.filteredItems.firstIndex(where: {$0.id == pat.id}) {
//                                self.filteredItems.remove(at: index)
//                            }
//                        }
//                    }
//                case "update":
//                    DispatchQueue.main.async {
//                        if let index = self.patientsList.firstIndex(where: {$0.id == pat.id}) {
//                            self.patientsList[index] = pat
//                            if !self.isSearching {
//                                self.filteredItems[index] = pat
//                            }
//                            print("UPDATED PATIENT")
//                        }
//                        if self.isSearching {
//                            if let index = self.filteredItems.firstIndex(where: {$0.id == pat.id}) {
//                                self.filteredItems[index] = pat
//                            }
//                        }
//                    }
//                    break
//                default:
//                    break
//                }
//            }
//    }
}

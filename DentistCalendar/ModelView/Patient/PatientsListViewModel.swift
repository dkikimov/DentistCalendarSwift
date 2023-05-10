//
//  PatientsListViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/10/20.
//

import SwiftUI
import SPAlert
import Amplify
import Combine
import UIKit
import GoogleMobileAds
class PatientsListViewModel: ObservableObject {
    @Published var filteredItems = [Patient]()
    @Published var patientsList = [Patient]()
    @Published var isLoading = false
    var isSearching = false
    var refreshControl = UIRefreshControl()
    var observationToken: AnyCancellable?
    deinit {
        observationToken?.cancel()
    }
    init() {
        refreshControl.addTarget(self, action: #selector(fetchPatients), for: .valueChanged)
    }
    @objc func fetchPatients(){
        Amplify.DataStore.query(Patient.self, sort: .ascending(Patient.keys.fullname)) { result in
            switch result {
            case .success(let patients):
                patientsList = patients
                if !isSearching {
                    filteredItems = patientsList
                }
            case .failure(let error):
                break
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.refreshControl.endRefreshing()
        }
        
    }
    func deletePatient(id: String) {
        Amplify.DataStore.delete(Patient.self, withId: id) { res in
            switch res {
            case .success:
                Amplify.DataStore.query(Appointment.self, where: Appointment.keys.patientID == id) { result in
                    switch result {
                    case .success(let appointments):
                        for appoint in appointments {
                            Amplify.DataStore.delete(appoint) {
                                switch $0 {
                                case .failure(let err):
                                    presentErrorAlert(message: err.localizedDescription)
                                default:
                                    break
                                }
                            }
                        }
                        break
                    case .failure(let error):
                        presentErrorAlert(message: error.localizedDescription)
                        break
                    }
                }
                break
            case .failure(let error):
                presentErrorAlert(message: error.localizedDescription)
            }
        }
    }
    func observePatients() {
        observationToken = Amplify.DataStore.publisher(for: Patient.self)
            .sink { (_) in } receiveValue: { (changes) in
                guard let pat = try? changes.decodeModel(as: Patient.self) else {return}
                
                switch changes.mutationType {
                case "create":
                    if !self.patientsList.contains(where: { (patient) -> Bool in
                        patient.id == pat.id
                    }) {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.patientsList.append(pat)
                                if !self.isSearching {
                                    self.filteredItems.append(pat)
                                }
                            }
                        }
                    }
                    break
                case "delete":
                    DispatchQueue.main.async {
                        withAnimation {
                            if let index = self.patientsList.firstIndex(where: {$0.id == pat.id}) {
                                self.patientsList.remove(at: index)
                                if !self.isSearching {
                                    self.filteredItems.remove(at: index)
                                }
                            }
                            if self.isSearching {
                                if let index = self.filteredItems.firstIndex(where: {$0.id == pat.id}) {
                                    self.filteredItems.remove(at: index)
                                }
                            }
                        }
                    }
                case "update":
                    DispatchQueue.main.async {
                        withAnimation {
                            if let index = self.patientsList.firstIndex(where: {$0.id == pat.id}) {
                                self.patientsList[index] = pat
                                if !self.isSearching {
                                    self.filteredItems[index] = pat
                                }
                            }
                            if self.isSearching {
                                if let index = self.filteredItems.firstIndex(where: {$0.id == pat.id}) {
                                    self.filteredItems[index] = pat
                                }
                            }
                        }
                    }
                    break
                default:
                    break
                }
            }
    }
}

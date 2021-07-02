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
                //                print("PATIENT lIST", patients)
                patientsList = patients
                if !isSearching {
                    filteredItems = patientsList
                }
            case .failure(let error):
                print("ERROR LIST", error.errorDescription)
            }
            print("FETCHED PATIENT")
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.refreshControl.endRefreshing()
        }
        
    }
    func deletePatient(id: String) {
        Amplify.DataStore.delete(Patient.self, withId: id) { res in
            switch res {
            case .success:
                break
//                presentSuccessAlert(message: "Пациент успешно удален!")
            case .failure(let error):
                presentErrorAlert(message: error.errorDescription)
            }
        }
        //        Api().deletePatient(id: id) { (success, err) in
        //            if err != nil {
        //                alertView = SPAlertView(title: "Ошибка", message: "При удалении произошла ошибка!", preset: .error)
        //                print(err!)
        //            }
        //            alertView.duration = 1.5
        //            alertView.present()
        //        }
        
    }
    func observePatients() {
        observationToken = Amplify.DataStore.publisher(for: Patient.self)
            .sink { (completion) in
                if case .failure(let error) = completion {
                    print("ERROR IN OBSERVE PATIENTS", error.errorDescription)
                }
            } receiveValue: { (changes) in
                print("CHANGES ", changes)
                guard let pat = try? changes.decodeModel(as: Patient.self) else {return}
                
                switch changes.mutationType {
                case "create":
                    print("NEW PATIENT", pat)
                    if !self.patientsList.contains(where: { (patient) -> Bool in
                        patient.id == pat.id
                    }) {
                        DispatchQueue.main.async {
                            self.patientsList.append(pat)
                            if !self.isSearching {
                                self.filteredItems.append(pat)
                            }
                        }
                    }
                    break
                case "delete":
                    DispatchQueue.main.async {
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
                case "update":
                    DispatchQueue.main.async {
                        if let index = self.patientsList.firstIndex(where: {$0.id == pat.id}) {
                            self.patientsList[index] = pat
                            if !self.isSearching {
                                self.filteredItems[index] = pat
                            }
                            print("UPDATED PATIENT")
                        }
                        if self.isSearching {
                            if let index = self.filteredItems.firstIndex(where: {$0.id == pat.id}) {
                                self.filteredItems[index] = pat
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

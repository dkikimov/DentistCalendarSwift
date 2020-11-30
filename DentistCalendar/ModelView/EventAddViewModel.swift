//
//  EventAddViewModel.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 28.11.2020.
//

import SwiftUI
import EventKit
import Amplify
class EventAddViewModel: ObservableObject {
    @Published var eventStore = EKEventStore()
    @Published var calendars: Set<EKCalendar>?
    @Published var isSheetPresented = true
    @Published var exampleData = ["1", "2", "3", "4"]
    @Published var isEditMode: EditMode = .active
    @Published var eventsList = [EKEvent]()
    @Published var selectedEvents = Set<EKEvent>()
    @Published var isLoading: Bool = false
    func getEvents(){
        eventStore.requestAccess(to: .event) { (status, err) in
            if err != nil {
                print("ERROR", err!)
                return
            }
            if status {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                // Create start and end date NSDate instances to build a predicate for which events to select
                let startDate = dateFormatter.date(from: "2019-08-01")
                let endDate = dateFormatter.date(from: "2021-01-01")
                
                if let startDate = startDate, let endDate = endDate {
                    
                    // Use an event store instance to create and properly configure an NSPredicate
                    print("CALENDARS", self.calendars)
                    DispatchQueue.main.async {
                        let eventsPredicate = self.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: Array(self.calendars ?? []))
                        self.eventsList = self.eventStore.events(matching: eventsPredicate)
                        print("EVENTs LIST", self.eventsList)
                        self.selectedEvents = Set(self.eventsList.map { $0 })
                    }
                }
            }
            
        }
       
    }
    func addEvents() {
        isLoading = true

        for i in selectedEvents {
            let data = i.title.split(separator: " ")
            let patientName = String(data[0]).trimmingCharacters(in: .whitespaces)
            var phone = "+77000000000"
            if patientName != "Не назначать" && patientName != "Осмотр" && patientName != "Лечение" && patientName != "Леч"{
                if data.count > 1 {
                    if phoneNumberKit.isValidPhoneNumber(String(data[1])) {
                        phone = String(data[1])
                    }
                }
                Amplify.DataStore.query(Patient.self, where: Patient.keys.fullname == patientName) { res in
                    switch res {
                    case .success(let patients):
                        if patients.count > 0 {
                            let newAppointment = Appointment(patientID: patients[0].id, patient: patients[0], toothNumber: 0, diagnosis: "", price: 0, dateStart: strFromDate(date: i.startDate), dateEnd: strFromDate(date: i.endDate))
                            Amplify.DataStore.save(newAppointment)
                        } else if patients.count == 0{
                            let newPatient = Patient(fullname: patientName, phone: phone)
                            
                            Amplify.DataStore.save(newPatient) { result in
                                switch result {
                                case .success(let pat):
                                    let newAppointment = Appointment(patientID: pat.id, patient: pat, toothNumber: 0, diagnosis: "", price: 0, dateStart: strFromDate(date: i.startDate), dateEnd: strFromDate(date: i.endDate))
                                    Amplify.DataStore.save(newAppointment)
                                case .failure(let error):
                                    print("ERROR SAVING PATIENT", error.errorDescription)

                                }
                                
                            }

                        }
                        break
                    case .failure(let error):
                        print("ERROR IN ADD EVENTS", error.errorDescription)
                    }
                    isLoading = false

                }
            }
        }
    }
}

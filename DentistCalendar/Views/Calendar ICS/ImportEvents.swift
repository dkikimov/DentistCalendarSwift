//
//  ImportEvents.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 15.02.2021.
//

import SwiftUI
import Amplify
import SwiftUIX
struct ImportEvents: View {
    @State var data: String?
    @State var isImportPresented = false
    @State var error = ""
    @State var isAlertPresented = false
    //    @State var patientsList = [Patient]()
    var body: some View {
        Form {
            Section {
                Button(action: {
                    isImportPresented.toggle()
                }, label: {
                    Text("Импортировать")
                })
            }
            
        }
        .navigationTitle("Импорт")
        .fileImporter(
            isPresented: $isImportPresented,
            allowedContentTypes: [.icsImport])
        { result in
            switch result {
            case .success(let url):
                print("SUCCESS")
                do {
                                let selectedFile: URL = url
                                if selectedFile.startAccessingSecurityScopedResource() {
                                    guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                                    self.data = input
                                    do { selectedFile.stopAccessingSecurityScopedResource() }
                                } else {
                                    // Handle denied access
                                }
                            } catch {
                                // Handle failure.
                                print("Unable to read file contents")
                                print(error.localizedDescription)
                            }
                importEventsFromFile(file: url)
            case .failure(let error):
                print("ERROR", error.localizedDescription)
            }
        }
        .onChange(of: isImportPresented, perform: { (newValue) in
            if newValue == false {
                setNavigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
            } else {
                setNavigationBarColor(backgroundColor: .white, tintColor: .systemBlue)

            }
        })
        
    }
    func importEventsFromFile(file: URL) {
        let cals = iCal.load(string: data!)
        //        let calendar = ICSCalendar(withComponents: cals)
        //        calendar.subComponents.
        
        for cal in cals {
            for event in cal.subComponents where event is ICSEvent {
                //                print(event as! ICSEvent)
                //            print(event)
                createAppointmentFromFile(event: event as! ICSEvent)
            }
        }
    }
    func createAppointmentFromFile(event: ICSEvent) {
        //    var newApp: Appointment = Appointment(title: event.summary!, dateStart: event.dtstart!, dateEnd: event.dtend!)
        var newApp: Appointment = Appointment(title: event.summary!, dateStart: strFromDate(date: event.dtstart!), dateEnd: strFromDate(date: event.dtend!))
        if (event.otherAttrs["patientID"] != nil) {
            Amplify.DataStore.query(Patient.self, byId: event.otherAttrs["patientID"]!) { res in
                switch res {
                case .success(let patient):
                    if (patient != nil) {
                        newApp.patientID = event.otherAttrs["patientID"]
                    } else {
                        if event.otherAttrs["patientData"] != nil {
                            let parsedPatient = parsePatientString(patient: event.otherAttrs["patientData"]!)
                            if (parsedPatient != nil) {
                                Amplify.DataStore.save(parsedPatient!) { result in
                                    switch result {
                                    case .success(let pat):
                                        newApp.patientID = pat.id
                                    case .failure(let err):
                                        self.error = err.errorDescription
                                        self.isAlertPresented = true
                                    }
                                }
                                
                            }
                        }
                    }
                case .failure(let error):
                    self.error = error.errorDescription
                    self.isAlertPresented = true
                }
                
            }
            newApp.price = Int(event.otherAttrs["price"]!)
            newApp.diagnosis = event.otherAttrs["diagnosis"]
            newApp.toothNumber = event.otherAttrs["toothNumber"]
        }
        Amplify.DataStore.save(newApp) { res in
            switch res {
            case .success(_):
                print("SUCCESS")
            case .failure(let error):
                self.error = error.errorDescription
                self.isAlertPresented = true
            }
            
        }
    }
    
}





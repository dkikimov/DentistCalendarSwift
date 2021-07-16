//
//  PatientCreateSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI

struct PatientCreateSection: View {
    @Binding var phoneNumber: String
    @EnvironmentObject var data: AppointmentCreateViewModel
    @State var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    @State var tableView: UITableView?
    var body: some View {
        Section {
            TextField("Имя пациента", text: titleBinding())
                .autocapitalization(.words)
                .disableAutocorrection(true)
            //                            .onChange(of: data.title) { newText in
            //                                data.debouncedFunction?.call()
            //                                if data.selectedPatient?.fullname != newText && data.viewType == .createWithPatient{
            //                                    data.selectedPatient = nil
            //                                    //                                    data.debouncedFunction.call()
            //                                }
            //
            //                            }
            //                            .onReceive(Just(data.title)) { newText in
            //                                if data.selectedPatient?.fullname != newText && data.viewType == .createWithPatient {
            //                                    data.selectedPatient = nil
            //                                    data.findPatientsByName(name: newText)
            //                                }
            //                            }
            if data.foundedPatientsList.count > 0 && data.selectedPatient == nil {
                List {
                    ForEach(data.foundedPatientsList, id: \.self) { patient in
                        Button(action: {
                            data.selectedPatient = patient
                            self.titleBinding().wrappedValue = patient.fullname
                            print("PATIENT", patient)
                        }, label :{
                            PatientsListRow(patient: patient)
                        })
                    }
                    .introspectTableView(customize: { uitable in
                        self.tableView = uitable
                    })
                }
                .listStyle(PlainListStyle())
                .frame(height:  65)
            }
            if data.selectedPatient == nil {
                PhoneNumberTextFieldView(phoneNumber: $phoneNumber)
                //                            iPhoneNumberField("Номер", text: data.patientPhone)
                //                                .flagHidden(true)
                //                                .flagSelectable(false)
                //                                .prefixHidden(false)
            }
            
        }
        .onReceive(timer, perform: { _ in
            showScrollIndicatorsInContacts()
        })
    }
    
    private func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001) {
            self.tableView?.flashScrollIndicators()
        }
    }
//    private func startTimerForShowScrollIndicator() {
//        self.timerForShowScrollIndicator = Timer.sche
//        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
//    }
    private func titleBinding() -> Binding<String> {
        return .init(
            get: {data.title},
            set: {
                data.title = $0
                data.debouncedFunction?.call()
            }
            
        )
    }
}

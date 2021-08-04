//
//  PatientCreateSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI
struct PatientCreateSection: View {
    @EnvironmentObject var data: AppointmentCreateViewModel
    @State var tableView: UITableView?
    @State var phoneNumber: String = ""
    var body: some View {
        Section {
            TextField("Имя пациента", text: titleBinding())
                .autocapitalization(.words)
                .disableAutocorrection(true)
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
                        .onAppear(perform: {
                            showScrollIndicatorsInContacts()
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
//                PhoneNumberTextFieldView(phoneNumber: $data.phoneNumber)
                iPhoneNumberField(text: $data.phoneNumber)
                    .maximumDigits(15)
                    .autofillPrefix(true)
//                TextField(phoneNumberKit.getExampleNumber(forCountry: Locale.current.regionCode!)!.numberString, text: $phoneNumber)
//                    .keyboardType(.phonePad)
//                    .textContentType(.telephoneNumber)
                //                            iPhoneNumberField("Номер", text: data.patientPhone)
                //                                .flagHidden(true)
                //                                .flagSelectable(false)
                //                                .prefixHidden(false)
            }
            
        }
    
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
                DispatchQueue.main.async {
                    data.debouncedFunction?.call()
                }
            }
            
        )
    }
}

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
                iPhoneNumberField(text: $data.phoneNumber)
                    .maximumDigits(15)
                    .autofillPrefix(true)
            }
            
        }
    
    }
    
    private func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001) {
            self.tableView?.flashScrollIndicators()
        }
    }
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

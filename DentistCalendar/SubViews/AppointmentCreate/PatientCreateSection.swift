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
                List{
                    ForEach(data.foundedPatientsList.indices, id: \.self) { index in
                        Button(action: {
                            let patient = data.foundedPatientsList[index]
                            data.selectedPatient = patient
                            self.titleBinding().wrappedValue = patient.fullname
                            print("PATIENT", patient)
                        }, label :{
                            PatientsListRow(patient: $data.foundedPatientsList[index])
                        })
                    }
                }
                .listStyle(PlainListStyle())
                .frame(minHeight: 65, maxHeight: 160)
            }
            if data.selectedPatient == nil {
                PhoneNumberTextFieldView(phoneNumber: $phoneNumber)
//                            iPhoneNumberField("Номер", text: data.patientPhone)
                //                                .flagHidden(true)
                //                                .flagSelectable(false)
                //                                .prefixHidden(false)
            }
            
        }
    }
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

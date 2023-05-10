//
//  PatientCreateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI

struct PatientCreateView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var data = PatientCreateViewModel()
    var patientsListData: PatientsListViewModel
    var body: some View {
        VStack(spacing: 15) {
            CustomTextField(label: "Имя и фамилия", title: "Василий Петров".localized, text: $data.patientName, isSecure: false, keyboardType: .default).autocapitalization(.words).padding(.horizontal, 20).padding(.top, 20)
            VStack(alignment: .leading) {
                Text("Номер телефона")
                    .font(.callout)
                    .bold()
                PhoneNumberTextFieldView(phoneNumber: $data.patientNumber)
                Divider()
            }.padding(.horizontal, 20).frame(height: 45)
            ActionButton(buttonLabel: "Создать", isLoading: $data.isLoading, action: {
                data.createPatient(patientData: patientsListData) { success in
                    if success {
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            })
            Spacer(minLength: 0)
            
        }
        .alert(isPresented: $data.isAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(data.error), dismissButton: .cancel())
        })
        .navigationBarTitle(Text("Создать пациента"))

        
    }
}

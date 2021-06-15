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
            
            //            CustomButton(action: {
            //                data.updatePatient { (res) in
            //                    if res {
            //                        presentationMode.wrappedValue.dismiss()
            //                    }
            //                }
            //            }, imageName: "pencil", label: "Изменить", disabled: (data.fullname.isEmpty || data.phone.isEmpty || (data.fullname == data.listData.patientsList[data.index].fullname && data.phone.replacingOccurrences(of: " ", with: "") == data.listData.patientsList[data.index].phone) ), isLoading: $data.isLoading).padding(.top, 10)
            Spacer().frame(height: 10)
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
                .navigationBarTitle(Text("Создать пациента"))
            
        }
        .alert(isPresented: $data.isAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(data.error), dismissButton: .cancel())
        })
        
    }
}
//struct PatientCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientCreateView()
//    }
//}

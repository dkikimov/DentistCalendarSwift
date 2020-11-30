//
//  PatientUpdateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/23/20.
//

import SwiftUI

struct PatientUpdateView: View {
    var listData: PatientsListViewModel
    @ObservedObject var data: PatientUpdateViewModel
    @Environment(\.presentationMode) var presentationMode
    var index: Int
    init(patient: Patient, index: Int, listData: PatientsListViewModel){
        self.data = PatientUpdateViewModel(patient: patient, index: index)
        self.index = index
        self.listData = listData
    }
    var body: some View {
        VStack(spacing: 15) {
            CustomTextField(label: "Имя", title: "Вася Пупкин", text: $data.fullname, isSecure: false, keyboardType: .default).autocapitalization(.words).padding(.horizontal, 20).padding(.top, 20)
            VStack(alignment: .leading) {
                Text("Номер телефона")
                    .font(.callout)
                    .bold()
                PhoneNumberTextFieldView(phoneNumber: $data.phone)
                Divider()
            }.padding(.horizontal, 20).frame(height: 45)
            
            CustomButton(action: {
                data.updatePatient(listData: self.listData) { (res) in
                    if res {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }, imageName: "pencil", label: "Изменить", disabled: (data.fullname.isEmpty || data.phone.isEmpty || (data.fullname == listData.patientsList[index].fullname && data.phone.replacingOccurrences(of: " ", with: "") == listData.patientsList[index].phone) || !phoneNumberKit.isValidPhoneNumber(data.phone) ), isLoading: $data.isLoading).padding(.top, 10)
            CustomButton(action: {
                data.isAlertPresented = true
            },
            imageName: "trash", label: "Удалить", color: "Red1", isLoading: $data.isLoading)
            
            Spacer(minLength: 0)
                .navigationBarTitle(Text("Изменить данные"))
            
        }.alert(isPresented: $data.isAlertPresented, content: {
            var alert: Alert = Alert(title: Text("Подтверждение"), message: Text("Вы точно хотите удалить пациента?"), primaryButton: .default(Text("Да"), action: {
                data.deletePatient(listData: listData)
            }), secondaryButton: .cancel())
            if data.error != "" {
                alert = Alert(title: Text("Ошибка"), message: Text(data.error) , dismissButton: .cancel())
                data.error = ""
            }
            return alert
        })
        
        //            .navigationBarColor( backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        
        
        
        
    }
}

//struct PatientUpdateView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientUpdateView()
//    }
//}

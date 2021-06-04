//
//  PatientUpdateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/23/20.
//

import SwiftUI

struct PatientUpdateView: View {
    var listData: PatientsListViewModel
    @StateObject var data: PatientUpdateViewModel
    @Environment(\.presentationMode) var presentationMode
    init(patient: Patient, listData: PatientsListViewModel){
        _data = StateObject(wrappedValue: PatientUpdateViewModel(patient: patient))
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
            Spacer()
                .frame(height: 10)
            ActionButton(buttonLabel: "Изменить", isLoading: $data.isLoading,
                         action: {
                            data.updatePatient(listData: self.listData) { (res) in
                                if res {
                                    DispatchQueue.main.async {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                         })
            //                (data.fullname.isEmpty || data.phone.isEmpty || (data.fullname == listData.patientsList[index].fullname && data.phone.replacingOccurrences(of: " ", with: "") == listData.patientsList[index].phone) || !phoneNumberKit.isValidPhoneNumber(data.phone) )
            //            CustomButton(action: {
            //                data.isAlertPresented = true
            //            },
            //            imageName: "trash", label: "Удалить", color: "Red1", isLoading: $data.isLoading)
            
            Spacer(minLength: 0)
                .navigationBarTitle(Text("Изменить данные"))
            
        }.alert(isPresented: $data.isAlertPresented, content: {
            //            var alert: Alert =
            //                Alert(title: Text("Подтверждение"), message: Text("Вы точно хотите удалить пациента?"), primaryButton: .default(Text("Да"), action: {
            //                data.deletePatient(listData: listData)
            //            }), secondaryButton: .cancel())
            //            if data.error != "" {
            //                alert = Alert(title: Text("Ошибка"), message: Text(data.error) , dismissButton: .cancel())
            //                data.error = ""
            //            }
            Alert(title: Text("Ошибка"), message: Text(data.error) , dismissButton: .cancel())
        })
        
        //            .navigationBarColor( backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        
        
        
        
    }
}

//struct PatientUpdateView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientUpdateView()
//    }
//}

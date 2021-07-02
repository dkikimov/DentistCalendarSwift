//
//  ServicesSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI
import AudioToolbox

struct ServicesSection: View {
    @AppStorage("dontShowAlert") var dontShownAlert = false
    @EnvironmentObject var data: AppointmentCreateViewModel
    @State var error = ""
    @State var isAlertPresented = false
    @State var wasAlertChecked = false
    var body: some View {
        Section(header: Text("Услуги")) {
            HStack {
                Text("Номер зуба") + Text(": ")
                
                TextField("15", text: $data.toothNumber)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            ForEach(data.selectedDiagnosisList.keys.sorted(), id: \.self) { key in
                HStack {
                    (Text(key) + Text(self.bindingAmount(for: key).wrappedValue == 1 ? "" : " x" + String( self.bindingAmount(for: key).wrappedValue))
                        .foregroundColor(.gray))
                        //                        .fixedSize()
                        .padding(.trailing, 5)
                    Stepper("", value: self.bindingAmount(for: key), in: 1...99, step: 1)
                        .fixedSize()
                    Spacer()
                    HStack(spacing: 5) {
                        Text("Цена: ")
                            .fixedSize()
                            .foregroundColor(.gray)
                        TextField("", text: self.bindingPrice(for: key))
                            .keyboardType(.decimalPad)
                            //                            .frame(minWidth: 30, idealWidth: 40, maxWidth: 150, alignment: .trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        //                        Text("\(self.bindingAmount(for: key).wrappedValue)")
                        //                            .frame(width: 22)
                        //                            .foregroundColor(.gray)
                        //                            .fixedSize()
                    }
                    //                    .multilineTextAlignment(.trailing)
                }
            }
            .onDelete(perform: { indexSet in
                DispatchQueue.main.async {
                    if let first = indexSet.first {
                        print("INDEX SET IS ", first)
                        let key = data.selectedDiagnosisList.keys.sorted()[first]
                        data.sumPrices -= ((Decimal(string: data.selectedDiagnosisList[key]!.price) ?? 0) * Decimal(data.selectedDiagnosisList[key]!.amount))
                        data.selectedDiagnosisList.removeValue(forKey: key)
                    }
                    
                }
            })
            Button(action: {
                data.isDiagnosisCreatePresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Добавить услугу")
                }
            })
            .disabled(data.selectedDiagnosisList.count >= 20)
        }.alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Ошибка"), message: Text(error), primaryButton: .cancel(Text("OK")), secondaryButton: .default(Text("Больше не показывать")) {
                dontShownAlert = true
            })
        }
    }
    
     func bindingPrice(for key: String) -> Binding<String> {
        return .init(
            get: {
                return self.data.selectedDiagnosisList[key]!.price
            },
            set: {
                let decimalString = Decimal(string: $0) ?? 0
                let amount = Decimal(data.selectedDiagnosisList[key]!.amount)
                let price = Decimal(string: data.selectedDiagnosisList[key]!.price) ?? 0
                guard $0.count < 15   else {
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { return }
                    if !wasAlertChecked && !dontShownAlert {
                        error = "Цена слишком большая"
                        isAlertPresented = true
                    }
                    return
                }
                data.sumPrices -= (price * amount)
                data.sumPrices += (decimalString * amount)
                self.data.selectedDiagnosisList[key]!.price = $0
                
                //                                data.generateMoneyData.call()
            })
    }
    
     func bindingAmount(for key: String) -> Binding<Int> {
        return .init(
            get: {
                self.data.selectedDiagnosisList[key]!.amount
                
            }, set: {
                //                data.sumPrices -= Decimal(string: self.data.selectedDiagnosisList[key]!.price) ?? 0
                //                data.sumPrices += Decimal(string: $0) ?? 0
                let decimalNumber = Decimal($0)
                let amount = Decimal(data.selectedDiagnosisList[key]!.amount)
                let price = Decimal(string: data.selectedDiagnosisList[key]!.price) ?? 0
                data.sumPrices -= (price * amount)
                data.sumPrices += (price * decimalNumber)
                self.data.selectedDiagnosisList[key]!.amount = $0
                
                //                data.generateMoneyData.call()
            })
    }
}

struct ServicesSection_Previews: PreviewProvider {
    static var previews: some View {
        ServicesSection()
            .environmentObject(AppointmentCreateViewModel(patient: Patient(id: "", fullname: "", phone: "", owner: ""), viewType: .editCalendar, appointment: Appointment(id: "", title: "", patientID: "", owner: "", toothNumber: "", diagnosis: "Пульпит:2000*2;Игра:1000*3", dateStart: "100", dateEnd: "200", payments: nil), dateStart: Date(), dateEnd: Date(), group: nil))
    }
}

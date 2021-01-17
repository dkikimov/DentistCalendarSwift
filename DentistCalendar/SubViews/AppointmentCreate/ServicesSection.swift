//
//  ServicesSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI

struct ServicesSection: View {
    @EnvironmentObject var data: AppointmentCreateViewModel
    var body: some View {
        Section(header: Text("Услуги")) {
            TextField("Номер зуба", text: $data.toothNumber)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            ForEach(data.selectedDiagnosisList.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                        .fixedSize()
                    Spacer()
                    TextField("Оплачено: 0", text: self.bindingPrePayment(for: key))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text(" / ")
                    HStack(spacing: 5) {
                        TextField("Цена: ", text: self.bindingPrice(for: key))
                            .keyboardType(.decimalPad)
                            .fixedSize()
                        Menu {
                            Button(action: {
                                self.bindingPrice(for: key).wrappedValue = self.bindingPrePayment(for: key).wrappedValue
                                data.generateMoneyData.call()

                            }, label: {
                                Text("Приравнять к первому")
                            })
                            Button(action: {
                                self.bindingPrePayment(for: key).wrappedValue = self.bindingPrice(for: key).wrappedValue
                                data.generateMoneyData.call()
                            }, label: {
                                Text("Приравнять к второму")
                            })
                            

                        } label:{
                            Image(systemName: "doc.on.doc")
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            .onDelete(perform: { indexSet in
                if let first = indexSet.first {
                    print("INDEX SET IS ", first)
                    let key = data.selectedDiagnosisList.keys.sorted()[first]
                    data.selectedDiagnosisList.removeValue(forKey: key)
                }
            })
            Button(action: {
                data.isDiagnosisCreatePresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus").padding(.trailing, 8)
                    Text("Добавить услугу")
                }
            })
        }
    }
    private func bindingPrePayment(for key: String) -> Binding<String> {
        return .init(
            get: { self.data.selectedDiagnosisList[key]!.prePayment },
            set: {
                self.data.selectedDiagnosisList[key]!.prePayment = $0
                data.generateMoneyData.call()
            })
    }
   
    private func bindingPrice(for key: String) -> Binding<String> {
        
        

        return .init(
            get: {
//                self.data.selectedDiagnosisList[key]!.price == 0 ? "" : String(self.data.selectedDiagnosisList[key]!.price)
                self.data.selectedDiagnosisList[key]!.price
            },
            set: {
                self.data.selectedDiagnosisList[key]!.price = $0
                data.generateMoneyData.call()

            })
    }
}

struct ServicesSection_Previews: PreviewProvider {
    static var previews: some View {
        ServicesSection()
    }
}

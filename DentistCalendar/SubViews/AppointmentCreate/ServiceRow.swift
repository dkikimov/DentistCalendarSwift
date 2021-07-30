//
//  Servicerow.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11.07.2021.
//

import SwiftUI

struct ServiceRow: View {
    var key: String
    @State var item: DiagnosisItem
    
    @EnvironmentObject var data: AppointmentCreateViewModel
    @State var amount: Int = 1
    @State var price: String = ""
    var body: some View {
        VStack(spacing: 7) {
            HStack(spacing: 5) {
                
                Text(key)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)

                 Text(" x" + String(amount))
                    .foregroundColor(.systemGray)
                    .padding(.trailing, 5)
                    
                
                Spacer()
                
                Text("Количество")
                    .fixedSize()
                Stepper("", value: $amount, in: 1...99, step: 1)
                    .fixedSize()
            }
            HStack {
                Text("Цена: ")
                    .fixedSize()
                    .foregroundColor(.gray)
//                            BottomLinedTextField(text: self.bindingPrice(for: key))
                BottomLinedTextField(text: $item.price)
//                TextField("", text: $price)
//                    .keyboardType(.decimalPad)
//                            Text(" " + (Locale.current.currencySymbol ?? ""))
//                                .fixedSize()
            }
        }
        .onAppear {
            self.price = data.selectedDiagnosisList[key]?.price ?? ""
            self.amount = data.selectedDiagnosisList[key]?.amount ?? 1
        }
        .onChange(of: item.price) { newPrice in
//            DispatchQueue.main.async {
//                data.selectedDiagnosisList[key]?.price = newPrice
                data.generateMoneyData.call()
//            }
            
        }
        .onChange(of: amount) { newAmount in
            DispatchQueue.main.async {
                data.selectedDiagnosisList[key]?.amount = newAmount
                data.generateMoneyData.call()
            }
        }
    }
}

//struct ServiceRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ServiceRow()
//    }
//}

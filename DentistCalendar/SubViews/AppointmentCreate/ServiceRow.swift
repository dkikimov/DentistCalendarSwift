//
//  Servicerow.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11.07.2021.
//

import SwiftUI

struct ServiceRow: View {
    @ObservedObject var item: DiagnosisItem
    @EnvironmentObject var data: AppointmentCreateViewModel
    
    var body: some View {
        
        VStack(spacing: 7) {
            HStack(spacing: 5) {
                
                Text(item.key)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(" x" + String(item.amount))
                    .foregroundColor(.systemGray)
                    .padding(.trailing, 5)
                
                
                Spacer()
                
                Text("Количество")
                    .fixedSize()
                    Stepper("", value: $item.amount, in: 1...99, step: 1)
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
                .onChange(of: item.price) { newPrice in
                    DispatchQueue.main.async {
                        data.generateMoneyData.call()
                    }
        //            }
        
                }
                .onChange(of: item.amount) { newAmount in
                    DispatchQueue.main.async {
//                        let priceDecimal = item.price.decimalValue
//                        print("SUM PRICES", data.sumPrices)
//                        data.sumPrices -= (priceDecimal * Decimal(item.amount))
//                        print("SUM PRICES", data.sumPrices)
//                        data.sumPrices += (priceDecimal * Decimal(newAmount))
//                        print("SUM PRICES", data.sumPrices)
                        data.generateMoneyData.call()

                    }
                }
    }
//
//    func makeBoolItemBinding(_ item: DiagnosisItem) -> Binding<DiagnosisItem>? {
//        guard let index = data.selectedDiagnosisList.firstIndex(where: { $0.id == item.id }) else { return nil }
//        return .init(get: { self.data.selectedDiagnosisList[index] ?? DiagnosisItem(key: "", amount: 0, price: "0")},
//                     set: { self.data.selectedDiagnosisList[index] = $0 })
//    }
}
//struct ServiceRow: View {
//    var index: Int
//
//    @EnvironmentObject var data: AppointmentCreateViewModel
//
//    var body: some View {
//        VStack(spacing: 7) {
//            HStack(spacing: 5) {
//
//                Text(data.selectedDiagnosisList[index].key)
//                    .lineLimit(4)
//                    .fixedSize(horizontal: false, vertical: true)
//
//                Text(" x" + String(data.selectedDiagnosisList[index].amount))
//                    .foregroundColor(.systemGray)
//                    .padding(.trailing, 5)
//
//
//                Spacer()
//
//                Text("Количество")
//                    .fixedSize()
//                Stepper("", value: $data.selectedDiagnosisList[index].amount, in: 1...99, step: 1)
//                    .fixedSize()
//            }
//            HStack {
//                Text("Цена: ")
//                    .fixedSize()
//                    .foregroundColor(.gray)
////                            BottomLinedTextField(text: self.bindingPrice(for: key))
//                BottomLinedTextField(text: $data.selectedDiagnosisList[index].price)
////                TextField("", text: $price)
////                    .keyboardType(.decimalPad)
////                            Text(" " + (Locale.current.currencySymbol ?? ""))
////                                .fixedSize()
//            }
//        }
//        .onChange(of: data.selectedDiagnosisList[index].price) { newPrice in
////            DispatchQueue.main.async {
////            DispatchQueue.main.async {
////                assignPrice.call()
////            }
//            DispatchQueue.main.async {
////                data.sumPrices -= Decimal(string: self.data.selectedDiagnosisList[key]!.price) ?? 0
//              //                //                data.sumPrices += Decimal(string: $0) ?? 0
//                data.sumPrices -= data.selectedDiagnosisList[index].price.decimalValue * Decimal(data.selectedDiagnosisList[index].amount)
//                data.sumPrices += newPrice.decimalValue * Decimal(data.selectedDiagnosisList[index].amount)
////                data.generateMoneyData.call()
//            }
////            }
//
//        }
//        .onChange(of: data.selectedDiagnosisList[index].amount) { newAmount in
//            DispatchQueue.main.async {
//                let priceDecimal = data.selectedDiagnosisList[index].price.decimalValue
//                data.sumPrices -= priceDecimal * Decimal(data.selectedDiagnosisList[index].amount)
//                data.sumPrices += priceDecimal * Decimal(newAmount)
////                data.generateMoneyData.call()
//            }
//        }
//    }
//
//
//}
//struct ServiceRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ServiceRow()
//    }
//}

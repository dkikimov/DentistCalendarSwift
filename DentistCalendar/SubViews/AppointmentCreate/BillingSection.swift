//
//  BillingSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 26.02.2021.
//

import SwiftUI
import Amplify



struct BillingSection: View {
    @EnvironmentObject var data: AppointmentCreateViewModel
    @State var text = ""
    @State var isAlertPresented = false
    @State var isErrorAlertPresented = false
    @State var error = ""
    @State var alertText = ""
    var body: some View {
        Group {
            
        
        Section(header: SumSection(), content: {
            ForEach(data.paymentsArray, id: \.self) { payment in
                VStack(alignment: .leading) {
                    Text("Платеж на сумму ") + Text(payment.cost).bold()
                    Text("Дата: \(stringToDate(date: payment.date))").font(.caption)
                }
            }.onDelete(perform: { indexSet in
                deletePayment(at: indexSet)
                data.generateMoneyData.call()
            })
            Button(action: {
                isAlertPresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Добавить платеж")
                }
            })
            
        })
        if isAlertPresented {
            AlertControlView(alerts: [
                .init(text: $text, placeholder: "Сумма", keyboardType: .decimalPad, autoCapitalizationType: .none)
            ], showAlert: $isAlertPresented, action: {
                addPayment()
            }, title: "Платеж", message: "Введите данные платежа")
        }
    }
    .alert(isPresented: $isErrorAlertPresented, content: {
        Alert(title: Text("Ошибка"), message: Text(error), dismissButton: .cancel())
    })
}
func deletePayment(at offsets: IndexSet) {
    if let first = offsets.first {
        //            if listData.patientsList.count >= first {
        //                let id = listData.patientsList[first].id
        //    //            self.listData.patientsList.remove(at: first)
        //                print("LISTDATA", listData.patientsList)
        //                print("INDEX", first)
        //                listData.deletePatient(id: id)
        ////                self.listData.patientsList.remove(atOffsets: offsets)
        //                print("DELETED OK", listData.patientsList)
        //            }
        if data.paymentsArray.count >= first {
//            let id = data.paymentsArray[first].id
            data.paymentsArray.remove(at: first)
//            data.deletePayment(id: id)
        }
    }
}
func addPayment() {
    let newPayment = PaymentModel(cost: text, date: String(Date().timeIntervalSince1970))
    withAnimation {
        data.paymentsArray.insert(newPayment, at: 0)
    }
    data.sumPayment += Decimal(string: text) ?? 0
    //        data.appointment?.payments
    //        Amplify.DataStore.save(newPayment) { res in
    //            switch res {
    //            case .failure(let error):
    //                self.error = error.errorDescription
    //                self.isErrorAlertPresented = true
    //            default:
    //                break
    //            }
    //        }
    self.text = ""
}

}

//struct BillingSection_Previews: PreviewProvider {
//    static var previews: some View {
//        BillingSection(finalCost: Decimal(10000))
//    }
//}

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
    @State var isErrorAlertPresented = false
    @State var error = ""
    @State var alertText = ""
    @Binding var isAlertPresented: Bool
    var body: some View {
        Group {
        Section(header: SumSection(), content: {
            ForEach(data.paymentsArray, id: \.self) { payment in
                VStack(alignment: .leading) {
                    Text("Платеж на сумму ") + Text(payment.cost).bold()
                    Text("Дата: \(stringToDate(date: payment.date))").font(.caption)
                }
            }.onDelete(perform: { indexSet in
                DispatchQueue.main.async {
                    deletePayment(at: indexSet)
                }
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
//        if isAlertPresented {
//            AlertControlView(alerts: [
//                .init(text: $text, placeholder: "Сумма", keyboardType: .decimalPad, autoCapitalizationType: .none)
//            ], showAlert: $isAlertPresented, action: {
//                DispatchQueue.main.async {
//                    addPayment()
//                }
//            }, title: "Платеж", message: "Введите данные платежа")
//        }
    }
    .alert(isPresented: $isErrorAlertPresented, content: {
        Alert(title: Text("Ошибка"), message: Text(error), dismissButton: .cancel())
    })
}
func deletePayment(at offsets: IndexSet) {
    if let first = offsets.first {
        if data.paymentsArray.count >= first {
        data.sumPayment -= Decimal(string: data.paymentsArray[first].cost) ?? 0
        data.paymentsArray.remove(at: first)
        }
    }
}
   

}

//struct BillingSection_Previews: PreviewProvider {
//    static var previews: some View {
//        BillingSection(finalCost: Decimal(10000))
//    }
//}

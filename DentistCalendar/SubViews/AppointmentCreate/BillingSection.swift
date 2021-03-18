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
        Section(header: SumSection(), content: {
            ForEach(data.paymentsArray, id: \.self) { payment in
                VStack {
                    Text("Платеж на сумму ") + Text(payment.cost).bold()
                    Text("Дата: \(stringToDate(date: payment.date))").font(.caption)
                }
            }

            if isAlertPresented {
                AlertControlView(alerts: [
                    .init(text: $text, placeholder: "Сумма", keyboardType: .decimalPad, autoCapitalizationType: .none)
                ], showAlert: $isAlertPresented, action: {
                    addPayment()
                }, title: "Платеж", message: "Введите данные платежа")
//                AlertControlView(textString: , priceString: $diagnosisPrice, showAlert: $isAlertPresented, action: {
//                    addDiagnosis()
//                }, title: "Услуга", message: "Введите данные услуги")
            }
            Button(action: {
                isAlertPresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Добавить платеж")
                }
            })
        })
        .alert(isPresented: $isErrorAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(error), dismissButton: .cancel())
        })
    }
    
    func addPayment() {
        let newPayment = Payment(appointmentID: data.id, cost: text, date: String(Date().timeIntervalSince1970))
        withAnimation {
            data.paymentsArray.append(newPayment)
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

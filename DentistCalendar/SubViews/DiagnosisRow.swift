//
//  DiagnosisRow.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI

struct DiagnosisRow: View {
    @EnvironmentObject var data: AppointmentCreateViewModel
    @State var isSelected = false
    @Binding var selectedDiagnosis: Diagnosis?
    var diag: Diagnosis
    var body: some View {
        Button (action:{
            isSelected.toggle()
            if data.selectedDiagnosisList[diag.text!] != nil {
                DispatchQueue.main.async {
                    data.selectedDiagnosisList.removeValue(forKey: diag.text!)
                }
            } else {
                DispatchQueue.main.async {
                    data.selectedDiagnosisList[diag.text!] = DiagnosisItem(amount: 1, price: diag.price!.description(withLocale: Locale.current))
                }
                print("SELECTED DIAGNOSIS LIST", data.selectedDiagnosisList)
            }
        },label: {
            HStack {
                Text(diag.text ?? "Error").foregroundColor(isSelected ? .blue : Color("Black1"))
                Spacer()
                //                Text("Цена: \(diag.price != nil ? diag.price!.stringValue : "0")")
                (Text("Цена: ") + Text(diag.price != nil ? (diag.price! as Decimal).currencyFormatted : "0"))
                    .foregroundColor(isSelected ? .blue : Color("Black1")).multilineTextAlignment(.trailing)
                Button {
//                        data.selectedDiagnosisList.removeValue(forKey: diag.text!)
                        self.selectedDiagnosis = diag
                    
                    //                    self.isAlertPresented = true
                } label: {
                    Image(systemName: "info.circle")
                }
                
                
            }
        })
        .onAppear(perform: {
            isSelected = data.selectedDiagnosisList[diag.text ?? ""] != nil
        })
    }
}

//struct DiagnosisRow_Previews: PreviewProvider {
//    static var previews: some View {
//        DiagnosisRow()
//    }
//}

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
    @Binding var selectedDiagnosisItem: DiagnosisItem?
    var diag: Diagnosis
    var body: some View {
        Button (action:{
            DispatchQueue.main.async {
                isSelected.toggle()
                if let firstIndex = data.selectedDiagnosisList.firstIndex(where: {$0.key == diag.text!}) {
                    
                    data.selectedDiagnosisList.remove(at: firstIndex)
                    
                } else {
                    DispatchQueue.main.async {
                        data.selectedDiagnosisList.append(DiagnosisItem(key: diag.text!, amount: 1, price: diag.price!.description(withLocale: Locale.current)))
                    }
                    print("SELECTED DIAGNOSIS LIST", data.selectedDiagnosisList)
                }
            }
        },label: {
            HStack {
                Text(diag.text ?? "Error")
                    .foregroundColor(isSelected ? .blue : Color("Black1"))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                //                Text("Цена: \(diag.price != nil ? diag.price!.stringValue : "0")")
                (Text("Цена: ") + Text(diag.price != nil ? (diag.price! as Decimal).currencyFormatted : "0"))
                    .foregroundColor(isSelected ? .blue : Color("Black1"))
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: false, vertical: true)
                Button {
                    self.selectedDiagnosis = diag
//                    self.selectedDiagnosisItem = data.selectedDiagnosisList[diag.text!]
//                    data.selectedDiagnosisList.removeValue(forKey: diag.text!)
                    
                    //                    self.isAlertPresented = true
                } label: {
                    Image(systemName: "info.circle")
                }
                
                
            }
        })
        .onAppear(perform: {
            isSelected = data.selectedDiagnosisList.contains(where: { diagnosis in
                return diag.text == diagnosis.key
            })
        })
    }
}

//struct DiagnosisRow_Previews: PreviewProvider {
//    static var previews: some View {
//        DiagnosisRow()
//    }
//}

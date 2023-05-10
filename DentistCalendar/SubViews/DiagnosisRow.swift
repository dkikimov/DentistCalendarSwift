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
    var diag: Diagnosis
    var action: () -> ()
    var infoAction: () -> ()
    var body: some View {
        Button (action:{
            isSelected.toggle()
            action()
        },label: {
            HStack {
                Text(diag.text ?? "Error")
                    .foregroundColor(isSelected ? .blue : Color("Black1"))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                (Text("Цена: ") + Text(diag.price != nil ? (diag.price! as Decimal).currencyFormatted : "0"))
                    .foregroundColor(isSelected ? .blue : Color("Black1"))
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: false, vertical: true)
                Button {
                    infoAction()
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

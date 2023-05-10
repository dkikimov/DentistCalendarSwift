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
                    BottomLinedTextField(text: $item.price)
            }
            
        }
                .onChange(of: item.price) { newPrice in
                    DispatchQueue.main.async {
                        data.generateMoneyData.call()
                    }
        
                }
                .onChange(of: item.amount) { newAmount in
                    DispatchQueue.main.async {
                        data.generateMoneyData.call()
                    }
                }
    }
}

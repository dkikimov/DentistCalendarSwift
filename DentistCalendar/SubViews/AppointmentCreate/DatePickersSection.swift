//
//  DatePickersSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI
struct DatePickersSection: View {
    @Binding var isDatePickerPresented: Bool
    @Binding var datePickerDate: Date
    
    @EnvironmentObject var data: AppointmentCreateViewModel
    var body: some View {
        Section {
            }, label: {
                HStack {
                    Text(data.segmentedMode == .withPatient ? "Начало приема" : "Начало события").foregroundColor(Color("Black1"))
                    Spacer()
                    Text(stringFromDate(date: data.dateStart))
                }
            }).lineLimit(1)
            Button(action: {
                data.isSecondDatePresented = true
                data.isFirstDatePresented = false
            }, label: {
                HStack {
                    Text(data.segmentedMode == .withPatient ? "Конец приема" : "Конец события").foregroundColor(Color("Black1"))
                    Spacer()
                    Text(stringFromDate(date: data.dateEnd))
                }
            }).lineLimit(1)
        }
        
        .onChange(of: data.dateStart) { newDateStart in
            DispatchQueue.main.async {
                if data.dateEnd < newDateStart {
                    data.dateEnd = newDateStart.addingTimeInterval(3600)
                }
            }
        }
    }
}

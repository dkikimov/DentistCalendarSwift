//
//  DatePickersSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI

struct DatePickersSection: View {
    @EnvironmentObject var data: AppointmentCreateViewModel
    var body: some View {
        Section {
            Button(action: {
                withAnimation {
                    if data.isSecondDatePresented {
                        data.isFirstDatePresented.toggle()
                        data.isSecondDatePresented.toggle()
                    } else {
                        data.isFirstDatePresented.toggle()
                    }
                }
            }, label: {
                
                HStack {
                    Text("Начало приема").foregroundColor(Color("Black1"))
                    Spacer()
                    Text(stringFromDate(date: data.dateStart))
                }
            }).lineLimit(1)
            if data.isFirstDatePresented {
                //                        DatePicker("Выберите начало приема", selection: $data.dateStart)
                //                            .datePickerStyle(GraphicalDatePickerStyle())
                startDatePicker()
                
            }
            Button(action: {
                withAnimation {
                    if data.isFirstDatePresented {
                        data.isFirstDatePresented.toggle()
                        data.isSecondDatePresented.toggle()
                    } else {
                        data.isSecondDatePresented.toggle()
                    }
                }
            }, label: {
                HStack {
                    Text("Конец приема").foregroundColor(Color("Black1"))
                    Spacer()
                    Text(stringFromDate(date: data.dateEnd))
                }
            }).lineLimit(1)
            if data.isSecondDatePresented {
                //                        DatePicker("Выберите конец приема", selection: $data.dateEnd).datePickerStyle(GraphicalDatePickerStyle())
                endDatePicker()
            }
        }
    }
    func startDatePicker() -> some View {
        DatePicker("Выберите начало приема", selection: $data.dateStart)
            .datePickerStyle(GraphicalDatePickerStyle())
    }
    func endDatePicker() -> some View {
        DatePicker("Выберите конец приема", selection: $data.dateEnd).datePickerStyle(GraphicalDatePickerStyle())
    }
}

struct DatePickersSection_Previews: PreviewProvider {
    static var previews: some View {
        DatePickersSection()
    }
}

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
//            DatePicker("Начало приема", selection: $data.dateStart, displayedComponents: [.date, .hourAndMinute])
//                .datePickerStyle(DatePickerStyle)
//            DatePicker("Конец приема", selection: $data.dateEnd, displayedComponents: [.date, .hourAndMinute])

            Button(action: {
                withAnimation(.easeInOut) {
                    data.isSecondDatePresented = false
                    data.isFirstDatePresented.toggle()
//                    if data.isSecondDatePresented {
//                        data.isFirstDatePresented.toggle()
//                        data.isSecondDatePresented.toggle()
//                    } else {
//                        data.isFirstDatePresented.toggle()
//                    }
                }
            }, label: {
                HStack {
                    Text("Начало приема").foregroundColor(Color("Black1"))
                    Spacer()
                    Text(stringFromDate(date: data.dateStart))
                }
            }).lineLimit(1)
            //                        DatePicker("Выберите начало приема", selection: $data.dateStart)
            //                            .datePickerStyle(GraphicalDatePickerStyle())
            if data.isFirstDatePresented {
                    DatePicker("Выберите начало приема", selection: $data.dateStart)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .id(1)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
            }

            Button(action: {
                withAnimation(.easeInOut) {
                data.isFirstDatePresented = false
                data.isSecondDatePresented.toggle()
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
                
                    DatePicker("Выберите конец приема", selection: $data.dateEnd)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .id(2)
                
                        .multilineTextAlignment(.center)
            }
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

struct DatePickersSection_Previews: PreviewProvider {
    static var previews: some View {
        DatePickersSection()
    }
}

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
//                withAnimation {
                    data.isSecondDatePresented = false
                    data.isFirstDatePresented.toggle()
//                    if data.isSecondDatePresented {
//                        data.isFirstDatePresented.toggle()
//                        data.isSecondDatePresented.toggle()
//                    } else {
//                        data.isFirstDatePresented.toggle()
//                    }
//                }
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
                VStack {
                    DatePicker("Выберите начало приема", selection: $data.dateStart)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .id(1)
                }
                .animation(.linear)
                .transition(.opacity)
            }
            
            Button(action: {
//                withAnimation {
                data.isFirstDatePresented = false
                data.isSecondDatePresented.toggle()
//                }
            }, label: {
                HStack {
                    Text("Конец приема").foregroundColor(Color("Black1"))
                    Spacer()
                    Text(stringFromDate(date: data.dateEnd))
                }
            }).lineLimit(1)
            if data.isSecondDatePresented {
                //                        DatePicker("Выберите конец приема", selection: $data.dateEnd).datePickerStyle(GraphicalDatePickerStyle())
                VStack {
                    DatePicker("Выберите конец приема", selection: $data.dateEnd)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .id(2)
                }
                .animation(.linear)
                .transition(.opacity)
            }
        }
    }
}

struct DatePickersSection_Previews: PreviewProvider {
    static var previews: some View {
        DatePickersSection()
    }
}

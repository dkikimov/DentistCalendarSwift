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
//            DatePicker("Начало приема", selection: $data.dateStart, displayedComponents: [.date, .hourAndMinute])
//                .datePickerStyle(DatePickerStyle)
//            DatePicker("Конец приема", selection: $data.dateEnd, displayedComponents: [.date, .hourAndMinute])

            Button(action: {
                datePickerDate = data.dateStart
                data.isSecondDatePresented = false
                data.isFirstDatePresented = true
//                withAnimation(.easeInOut) {
//                    data.isSecondDatePresented = false
//                    data.isFirstDatePresented.toggle()
////                    if data.isSecondDatePresented {
////                        data.isFirstDatePresented.toggle()
////                        data.isSecondDatePresented.toggle()
////                    } else {
////                        data.isFirstDatePresented.toggle()
////                    }
//                }
            }, label: {
                HStack {
                    Text(data.segmentedMode == .withPatient ? "Начало приема" : "Начало события").foregroundColor(Color("Black1"))
                    Spacer()
                    Text(stringFromDate(date: data.dateStart))
                }
            }).lineLimit(1)
            //                        DatePicker("Выберите начало приема", selection: $data.dateStart)
            //                            .datePickerStyle(GraphicalDatePickerStyle())
//            Group {
//                if data.isFirstDatePresented {
//                        DatePicker("Выберите начало приема", selection: $data.dateStart)
//                            .datePickerStyle(GraphicalDatePickerStyle())
//                            .labelsHidden()
//                            .id(1)
//                            .multilineTextAlignment(.center)
//                            .frame(maxWidth: .infinity)
//                }
//
//            }
            Button(action: {
                data.isSecondDatePresented = true
                data.isFirstDatePresented = false
//                withAnimation(.easeInOut) {
//                data.isFirstDatePresented = false
//                data.isSecondDatePresented.toggle()
//                }
            }, label: {
                HStack {
                    Text(data.segmentedMode == .withPatient ? "Конец приема" : "Конец события").foregroundColor(Color("Black1"))
                    Spacer()
                    Text(stringFromDate(date: data.dateEnd))
                }
            }).lineLimit(1)
//            if data.isSecondDatePresented {
//                //                        DatePicker("Выберите конец приема", selection: $data.dateEnd).datePickerStyle(GraphicalDatePickerStyle())
//
//                    DatePicker("Выберите конец приема", selection: $data.dateEnd)
//                        .datePickerStyle(WheelDatePickerStyle())
//                        .labelsHidden()
//                        .id(2)
//                        .multilineTextAlignment(.center)
//                        .frame(maxWidth: .infinity)
//
//            }
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

//struct DatePickersSection_Previews: PreviewProvider {
//    static var previews: some View {
//        DatePickersSection()
//    }
//}

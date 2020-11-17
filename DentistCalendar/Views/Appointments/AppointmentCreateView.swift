//
//  AppointmentCreateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI
func stringFromDate(date: Date) -> String {
    let dateFormatter = DateFormatter() //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "d MMMM YYYY HH:mm" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate
    
}
struct AppointmentCreateView: View {
    @EnvironmentObject var patientDetailData: PatientDetailViewModel
    var isModalPresented: Binding<Bool>
    var persistenceContainer: PersistenceController
    @ObservedObject var data: AppointmentCreateViewModel
    init(patientID: String, isAppointmentPresented: Binding<Bool>) {
        data = AppointmentCreateViewModel(patientID: patientID)
        isModalPresented = isAppointmentPresented
        persistenceContainer = PersistenceController.shared
    }
    var body: some View {
        NavigationView{
            List{
                Section{
                    TextField("Цена", text: $data.price).keyboardType(.numberPad)
                    TextField("Номер зуба", text: $data.toothNumber).keyboardType(.numberPad)

                    Button(action: {
                        data.isDiagnosisCreatePresented.toggle()
                    }, label: {
                        Text("Диагнозы: ") + Text(data.selectedDiagnosisList.count > 0 ? data.selectedDiagnosisList.map { String($0.text!) }.joined(separator: ", ") : "Пусто").foregroundColor(.black).bold()
                    })
                    
                }
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
                            Text("Начало приема").foregroundColor(.black)
                            Spacer()
                            Text(stringFromDate(date: data.dateStart))
                        }
                    }).lineLimit(1)
                    if data.isFirstDatePresented {
                        DatePicker("Выберите начало приема", selection: $data.dateStart).datePickerStyle(GraphicalDatePickerStyle())
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
                            Text("Конец приема").foregroundColor(.black)
                            Spacer()
                            Text(stringFromDate(date: data.dateEnd))
                        }
                    }).lineLimit(1)
                    if data.isSecondDatePresented {
                        DatePicker("Выберите конец приема", selection: $data.dateEnd).datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
                Section {
                    Button(action: {
                        data.createAppointment(isModalPresented: self.isModalPresented, patientDetailData: patientDetailData)
                    }, label: {
                        Text("Сохранить")
                    }).disabled(data.price.isEmpty || data.selectedDiagnosisList.count == 0 || data.toothNumber.isEmpty || data.dateEnd < data.dateStart)
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Создание записи", displayMode: .inline)
            
            .navigationBarItems(leading: Button(action: {
                isModalPresented.wrappedValue = false
            }, label: {
                Text("Готово").foregroundColor(.blue)
            }))
            .navigationBarColor(backgroundColor: .white, tintColor: .black)
            //            , trailing: Button(action: {
            //
            //            }, label: {
            //                Image(systemName: "plus").foregroundColor(.blue)
            //            }))
        }
        .sheet(isPresented: $data.isDiagnosisCreatePresented, content: {
                DiagnosisCreateView(data: data).environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        })
    }
    
}

//struct AppointmentCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentCreateView()
//    }
//}

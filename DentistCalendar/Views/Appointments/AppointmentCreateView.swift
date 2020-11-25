//
//  AppointmentCreateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI
import Combine


enum AppointmentType {
    case create
    case edit
    case createWithPatient
}

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
    var group: DispatchGroup?
    @ObservedObject var data: AppointmentCreateViewModel
    
    //edit and create
    init(patient: Patient, isAppointmentPresented: Binding<Bool>, viewType: AppointmentType, appointment: Appointment?) {
        data = AppointmentCreateViewModel(patient: patient, viewType: viewType, appointment: appointment, dateStart: nil, dateEnd: nil, group: nil)
        isModalPresented = isAppointmentPresented
        persistenceContainer = PersistenceController.shared
    }
    
    //createWithPatient
    init(isAppointmentPresented: Binding<Bool>, viewType: AppointmentType, dateStart: Date?, dateEnd: Date?, group: DispatchGroup) {
        data = AppointmentCreateViewModel(patient: nil, viewType: viewType, appointment: nil, dateStart: dateStart, dateEnd: dateEnd, group: group)
        isModalPresented = isAppointmentPresented
        persistenceContainer = PersistenceController.shared
        self.group = group
    }
    var body: some View {
        NavigationView{
            List{
                Section{
                    if data.viewType == .createWithPatient {
                        TextField("Имя пациента", text: $data.patientName).autocapitalization(.words)
                            .onReceive(Just(data.patientName)) { newText in
                                if data.selectedPatient?.fullname != newText {
                                    data.selectedPatient = nil
                                }
                            }
                        if data.foundedPatientsList.count > 0 && data.selectedPatient == nil {
                            List{
                                ForEach(data.foundedPatientsList.indices, id: \.self) { index in
                                    Button(action: {
                                        print("IM HERE")
                                        let patient = data.foundedPatientsList[index]
                                        data.selectedPatient = patient
                                        data.patientName = patient.fullname
                                    }, label :{
                                        PatientsListRow(patient: $data.foundedPatientsList[index])
                                    })
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(minHeight: 55, maxHeight: 110)
                        }
                        if data.selectedPatient == nil {
                            TextField("Номер телефона пациента", text: $data.patientPhone)
                        }
                    }
                    
                    
                }
                Section {
                    TextField("Цена", text: $data.price).keyboardType(.numberPad)
                    TextField("Номер зуба", text: $data.toothNumber).keyboardType(.numberPad)
                    
                    Button(action: {
                        data.isDiagnosisCreatePresented.toggle()
                    }, label: {
                        Text("Диагнозы: ") + Text(data.selectedDiagnosisList.count > 0 ? data.selectedDiagnosisList.joined(separator: ", ") : "Пусто").foregroundColor(.black).bold()
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
                        if data.viewType == .create {
                            data.createAppointment(isModalPresented: self.isModalPresented, patientDetailData: patientDetailData)
                        } else if data.viewType == .edit{
                            data.updateAppointment(isModalPresented: self.isModalPresented, patientDetailData: patientDetailData)
                        } else if data.viewType == .createWithPatient {
                            data.createAppointmentAndPatient()
                        }
                    }, label: {
                        Text("Сохранить")
                    })
//                    .disabled(data.price.isEmpty || data.selectedDiagnosisList.count == 0 || data.toothNumber.isEmpty || data.dateEnd < data.dateStart)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(data.viewType == .create || data.viewType == .createWithPatient ? "Создание записи" : "Изменение записи", displayMode: .inline)
            
            .navigationBarItems(leading: Button(action: {
                if data.viewType == .createWithPatient {
                    group!.leave()
                }
                isModalPresented.wrappedValue = false
            }, label: {
                Text("Отменить").foregroundColor(.blue)
            }))
            //            , trailing: Button(action: {
            //
            //            }, label: {
            //                Image(systemName: "plus").foregroundColor(.blue)
            //            }))
        }
        .sheet(isPresented: $data.isDiagnosisCreatePresented, content: {
            DiagnosisCreateView(data: data).environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        })
        .navigationBarColor(backgroundColor: .white, tintColor: .black)
    }
    
}

//struct AppointmentCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentCreateView()
//    }
//}

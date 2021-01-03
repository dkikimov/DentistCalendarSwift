//
//  AppointmentCreateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI
import Combine
import PhoneNumberKit
import iPhoneNumberField


func stringFromDate(date: Date) -> String {
    let dateFormatter = DateFormatter() //Set timezone that you want
    dateFormatter.locale = Locale.init(identifier: Locale.preferredLanguages.first!)
    dateFormatter.dateFormat = "d MMMM YYYY HH:mm" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    return strDate  
    
}

struct AppointmentCreateView: View {
    @EnvironmentObject var patientDetailData: PatientDetailViewModel
    var isModalPresented: Binding<Bool>
    var appointmentCalendar: Binding<Appointment>?
    var persistenceContainer: PersistenceController
    var group: DispatchGroup?
    @ObservedObject var data: AppointmentCreateViewModel
    //edit and create
    init(patient: Patient?, isAppointmentPresented: Binding<Bool>, viewType: AppointmentType, appointment: Appointment?, appointmentCalendar: Binding<Appointment>? = nil) {
        data = AppointmentCreateViewModel(patient: patient, viewType: viewType, appointment: appointment, dateStart: nil, dateEnd: nil, group: nil)
        isModalPresented = isAppointmentPresented
        persistenceContainer = PersistenceController.shared
        if appointmentCalendar != nil {
            self.appointmentCalendar = appointmentCalendar
        }
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
                if data.viewType == .createWithPatient  {
                    Section(header: Text("Тип календаря")) {
                        Picker(selection: $data.segmentedMode, label: Text("Выберите календарь")) {
                            Text("Рабочий").tag(CurrentSegmentedState.withPatient)
                            Text("Домашний").tag(CurrentSegmentedState.nonPatient)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                if data.viewType == .createWithPatient && data.segmentedMode == .withPatient {
                    Section {
                        
                        TextField("Имя пациента", text: $data.title).autocapitalization(.words)
                                                        .onChange(of: data.title) { newText in
                                                            if data.selectedPatient?.fullname != newText && data.viewType == .createWithPatient{
                                                                data.selectedPatient = nil
                            //                                    data.debouncedFunction.call()
                                                            }
                            
                                                        }
//                            .onReceive(Just(data.title)) { newText in
//                                if data.selectedPatient?.fullname != newText && data.viewType == .createWithPatient {
//                                    data.selectedPatient = nil
//                                    data.findPatientsByName(name: newText)
//                                }
//                            }
                        if data.foundedPatientsList.count > 0 && data.selectedPatient == nil {
                            List{
                                ForEach(data.foundedPatientsList.indices, id: \.self) { index in
                                    Button(action: {
                                        let patient = data.foundedPatientsList[index]
                                        data.selectedPatient = patient
                                        data.title = patient.fullname
                                    }, label :{
                                        PatientsListRow(patient: $data.foundedPatientsList[index])
                                    })
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(minHeight: 65, maxHeight: 130)
                        }
                        if data.selectedPatient == nil {
                                                        PhoneNumberTextFieldView(phoneNumber: $data.patientPhone)
//                            iPhoneNumberField("Номер", text: $data.patientPhone)
////                                .flagHidden(true)
////                                .flagSelectable(false)
////                                .prefixHidden(false)
                        }
                        
                    }
                } else if data.segmentedMode == .nonPatient{
                    TextField("Название", text: $data.title)
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
                            Text("Начало приема").foregroundColor(Color("Black1"))
                            Spacer()
                            Text(stringFromDate(date: data.dateStart))
                        }
                    }).lineLimit(1)
                    if data.isFirstDatePresented {
                        DatePicker("Выберите начало приема", selection: $data.dateStart)
                            .datePickerStyle(GraphicalDatePickerStyle())
                        
                        
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
                        DatePicker("Выберите конец приема", selection: $data.dateEnd).datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
                
                if data.segmentedMode == .withPatient {
                        
                        
                        //                        Button(action: {
                        //                            data.isDiagnosisCreatePresented.toggle()
                        //                        }, label: {
                        //                            Text("Услуги: ") + Text(data.selectedDiagnosisList.count > 0 ? data.selectedDiagnosisList.map { $0.0 + ":" + String($0.1) }.joined(separator: ", ") : "Пусто").foregroundColor(Color("Black1")).bold()
                        //                        })
                    
                    
                    Section(header: Text("Услуги")) {
                        TextField("Номер зуба", text: $data.toothNumber)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        ForEach(data.selectedDiagnosisList.keys.sorted(), id: \.self) { key in
                            HStack {
                                Text(key)
                                    .fixedSize()
                                Spacer()
                                TextField("Оплачено: 0", text: self.bindingPrePayment(for: key))
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                Text(" / ")
                                TextField("Цена: ", text: self.bindingPrice(for: key))
                                    .keyboardType(.numberPad)
                                    .fixedSize()
                            }
                        }
                        .onDelete(perform: { indexSet in
                            if let first = indexSet.first {
                                print("INDEX SET IS ", first)
                                let key = data.selectedDiagnosisList.keys.sorted()[first]
                                data.selectedDiagnosisList.removeValue(forKey: key)
                            }
                        })
                        Button(action: {
                            data.isDiagnosisCreatePresented.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "plus").padding(.trailing, 8)
                                Text("Добавить услугу")
                            }
                        })
                    }
                }
                Section(header: data.segmentedMode == .withPatient ? VStack(alignment: .leading) {
                            Text("Общая стоимость: ").bold() + Text(String(data.sumPrices))
                            Text("Оплачено: ").bold() + Text(String(data.sumPayments))
                            Text("Осталось к оплате: ").bold() + Text(String(data.sumPrices - data.sumPayments))
                    } : nil) {
                    

                    Button(action: {
                        if data.viewType == .editCalendar {
                            data.updateAppointmentCalendar(isModalPresented: self.isModalPresented, appointment: self.appointmentCalendar!)
                        }
                        else if data.segmentedMode == .withPatient {
                            if data.viewType == .create {
                                data.createAppointment(isModalPresented: self.isModalPresented, patientDetailData: patientDetailData)
                            } else if data.viewType == .edit{
                                data.updateAppointment(isModalPresented: self.isModalPresented, patientDetailData: patientDetailData)
                            } else if data.viewType == .createWithPatient {
                                data.createAppointmentAndPatient()
                            }
                            
                        } else if data.segmentedMode == .nonPatient {
                            data.createNonPatientAppointment(isModalPresented: self.isModalPresented)
                        }
                    }, label: {
                        Text("Сохранить")
                    })
                    .disabled(data.segmentedMode == .withPatient ? (data.toothNumber.isEmpty || data.dateEnd < data.dateStart || data.title.isEmpty) : (data.title.isEmpty || data.dateEnd < data.dateStart))
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(data.viewType == .create || data.viewType == .createWithPatient ? "Создание записи" : "Изменение записи", displayMode: .inline)
            
            .navigationBarItems(leading: Button(action: {
                if data.viewType == .createWithPatient {
                    group!.leave()
                    data.cancellable?.cancel()

                }
                isModalPresented.wrappedValue = false
                
            }, label: {
                Text("Отменить")
            }))
        }
        .alert(isPresented: $data.isAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(data.error), dismissButton: .cancel())
        })
        .sheet(isPresented: $data.isDiagnosisCreatePresented, content: {
            DiagnosisCreateView(data: data).environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        })
//        .navigationBarColor(backgroundColor: UIColor(named: "White1")!, tintColor: UIColor(named: "Black1")!)
        .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        
        //            .colorScheme(.light)
        
        //        .preferredColorScheme(.dark)
        //            .onAppear(perform: {UIApplication.setStatusBarStyle(.darkContent)})
        
    }
    private func bindingPrePayment(for key: String) -> Binding<String> {
        return .init(
            get: { self.data.selectedDiagnosisList[key]!.prePayment },
            set: {
                self.data.selectedDiagnosisList[key]!.prePayment = $0
                data.generateMoneyData()
            })
    }
    private func bindingPrice(for key: String) -> Binding<String> {
        return .init(
            get: { self.data.selectedDiagnosisList[key]!.price == 0 ? "" : String(self.data.selectedDiagnosisList[key]!.price)
            },
            set: {
                self.data.selectedDiagnosisList[key]!.price = Int32($0) ?? 0
                data.generateMoneyData()
            })
    }
    //    func getDisabled() -> Bool {
    //        switch data.segmentedMode {
    //        case .nonPatient:
    //            data.title.isEmpty
    //
    //        }
    //    }
}

//struct AppointmentCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentCreateView()
//    }
//}

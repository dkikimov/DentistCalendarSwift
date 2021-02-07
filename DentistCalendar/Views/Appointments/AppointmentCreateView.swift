//
//  AppointmentCreateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI
import Combine
import PhoneNumberKit


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
    var rewardedAd = Rewarded()
    @StateObject var data: AppointmentCreateViewModel
    //    @ObservedObject var data: AppointmentCreateViewModel
    
    @State var phoneNumber: String = ""
    @State var test = ""
    //edit and create
    init(patient: Patient?, isAppointmentPresented: Binding<Bool>, viewType: AppointmentType, appointment: Appointment?, appointmentCalendar: Binding<Appointment>? = nil) {
        isModalPresented = isAppointmentPresented
        persistenceContainer = PersistenceController.shared
        _data = StateObject(wrappedValue: AppointmentCreateViewModel(patient: patient, viewType: viewType, appointment: appointment, dateStart: nil, dateEnd: nil, group: nil))
        //        data = AppointmentCreateViewModel(patient: patient, viewType: viewType, appointment: appointment, dateStart: nil, dateEnd: nil, group: nil)
        
        if appointmentCalendar != nil {
            self.appointmentCalendar = appointmentCalendar
        }
    }
    
    //createWithPatient
    init(isAppointmentPresented: Binding<Bool>, viewType: AppointmentType, dateStart: Date?, dateEnd: Date?, group: DispatchGroup) {
        isModalPresented = isAppointmentPresented
        persistenceContainer = PersistenceController.shared
        _data = StateObject(wrappedValue: AppointmentCreateViewModel(patient: nil, viewType: viewType, appointment: nil, dateStart: dateStart, dateEnd: dateEnd, group: group))
        //       data = AppointmentCreateViewModel(patient: nil, viewType: viewType, appointment: nil, dateStart: dateStart, dateEnd: dateEnd, group: group)
//        print("DATE START", dateStart)
        self.group = group
        
    }
    var body: some View {
        NavigationView{
            List{
                if data.viewType == .createWithPatient  {
                    //                    PickerCalendarSection(data: $data)
                    PickerCalendarSection()
                    //                    PickerCalendarSec
                    
                }
                
                if data.viewType == .createWithPatient && data.segmentedMode == .withPatient {
                    PatientCreateSection(phoneNumber: $phoneNumber)
                    
                } else if data.segmentedMode == .nonPatient{
                    TextField("Название", text: $data.title)
                }
                
                DatePickersSection()
                
                if data.segmentedMode == .withPatient {
                    ServicesSection()
                }
                Section(header: data.segmentedMode == .withPatient ? SumSection() : nil) {
                    
                    
                    Button(action: {
                        
                         if data.segmentedMode == .withPatient {
                            guard data.selectedPatient != nil  || data.viewType != .createWithPatient || phoneNumberKit.isValidPhoneNumber(phoneNumber) else {
                                    print("NUMBER", phoneNumber)
                                    data.error = "Введите корректный номер".localized
                                    data.isAlertPresented = true
                                    return
                            }
                            guard !data.toothNumber.isEmpty else {
                                data.error = "Введите номер зуба".localized
                                data.isAlertPresented = true
                                return
                            }
                            
//                            if data.viewType == .editCalendar {
//                                data.updateAppointmentCalendar(isModalPresented: self.isModalPresented, appointment: self.appointmentCalendar!)
//                            }
                                if data.viewType == .create {
                                    data.createAppointment(isModalPresented: self.isModalPresented, patientDetailData: patientDetailData)
                                }
//                               else if data.viewType == .edit{
//                                    data.updateAppointment(isModalPresented: self.isModalPresented, patientDetailData: patientDetailData)       }
                         else if data.viewType == .createWithPatient {
                                    data.createAppointmentAndPatient(phoneNumber: phoneNumber)
                                }
                        } else if data.segmentedMode == .nonPatient {
                            if data.viewType == .create || data.viewType == .createWithPatient{
                                data.createNonPatientAppointment(isModalPresented: self.isModalPresented)
                            }
                        }
                        if data.viewType == .editCalendar {
                            data.updateAppointmentCalendar(isModalPresented: self.isModalPresented, appointment: self.appointmentCalendar!)
                        }
                        else if data.viewType == .edit{
                            data.updateAppointment(isModalPresented: self.isModalPresented, patientDetailData: patientDetailData)
                        }
                    }, label: {
                        Text("Сохранить")
                    })
                    .disabled(data.dateEnd < data.dateStart)
                }
            }
            .environmentObject(data)
            
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
        //        .onDisappear(perform: {
        //            if data.didSave {
        //                rewardedAd.showAd {}
        //            }
        //        })
        .alert(isPresented: $data.isAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(data.error), dismissButton: .cancel())
        })
        .sheet(isPresented: $data.isDiagnosisCreatePresented, content: {
            DiagnosisCreateView(data: data)
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
            
        })
        
        //        .navigationBarColor(backgroundColor: UIColor(named: "White1")!, tintColor: UIColor(named: "Black1")!)
        .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        
        //            .colorScheme(.light)
        
        //        .preferredColorScheme(.dark)
        //            .onAppear(perform: {UIApplication.setStatusBarStyle(.darkContent)})
        
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

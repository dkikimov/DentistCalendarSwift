//
//  AppointmentCalendarView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 06.12.2020.
//

import SwiftUI
import CalendarKit
import Amplify
private func dateFormatter(date: String, _ time: Bool = false) -> String{
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: Locale.preferredLanguages.first!)
    formatter.dateFormat = "EEEE, d MMMM yyyy"
    if time {
        formatter.dateFormat = "HH:mm"
    }
    return formatter.string(from: Date(timeIntervalSince1970: Double(date)!))
}

struct AppointmentCalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var data: AppointmentCalendarViewModel
    var intestital: Interstitial?
    var diagnosisList = [[Substring]]()
    var serviceSum: Decimal = 0
    var servicePaid: Decimal = 0
    init(appointment: Appointment, _ isEditAllowed: Bool = true, fullScreenIsCalendar: Binding<Bool>? = nil, intestital: Interstitial? = nil) {
        data = AppointmentCalendarViewModel(appointment: appointment, isEditAllowed: isEditAllowed, fullScreenIsCalendar: fullScreenIsCalendar)
        if appointment.diagnosis != nil {
            var sum: Decimal = 0
            var paid: Decimal = 0
            let a = appointment.diagnosis!.split(separator: ";")
            a.forEach({
                let b = $0.split(separator: ":")
//                print("FOREACH B", b )
                if b.count == 3 {
                    sum += Decimal(string: String(String(b[1]).doubleValue)) ?? 0
                    paid += Decimal(string: String(String(b[2]).doubleValue)) ?? 0
                    diagnosisList.append(b)
                }
            })
            self.serviceSum = sum
            self.servicePaid = paid
            
            print("DIAGNOSIs LIST", diagnosisList)
        }
        self.intestital = intestital
        
        
    }
    var body: some View {
        NavigationView {
            content()
                .navigationBarTitle(Text("Детали записи"), displayMode: .inline)
        }
//        .onDisappear(perform: {
//            if intestital != nil {
//                print("INTESTITAL", intestital!)
//
//                intestital!.showAd()
//            }
//        })
//        .navigationViewWrapper()
        
        
        
        //        .toolbar(content: {
        //            ToolbarItem(placement: .status, content: {
        //                Button(action: {
        //                    data.deleteAppointment(presentationMode: presentationMode)
        //                }, label: {
        //                    Text("Удалить")
        //                        .foregroundColor(.red)
        //
        //                })
        //
        //            })
        //
        
        //        })
        
    }
    
    func content() -> some View {
        return ZStack {
            ScrollView{
                VStack(alignment: .leading) {
                    Text(data.appointment.title).font(.title).bold()
                    Text(dateFormatter(date: data.appointment.dateStart))
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#8a8888"))
                    Text("с " + dateFormatter(date: data.appointment.dateStart, true) + " до " + dateFormatter(date: data.appointment.dateEnd, true))
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#8a8888"))
                    Divider()
                    if diagnosisList.count > 0 {
                        Spacer(minLength: 10)
                            VStack(alignment: .leading) {
                                Text("Услуги: ").font(.title2).bold()
                                ServiceList(diagnosisList: diagnosisList)
//                                Print(Decimal(0).formatted)
//                                Print(Decimal(49.12).formatted)

                            }
                            Spacer(minLength: 25)
                            VStack(alignment: .leading) {
                                Text("Общая стоимость: ").bold() + Text(serviceSum.formatted)
                                Text("Оплачено: ").bold() + Text(servicePaid.formatted)
                                Text("Осталось к оплате: ").bold() + Text((serviceSum - servicePaid).formatted)
                            }
                        
                    } else {
                        if data.appointment.patientID != nil {
                            Text("Список услуг пуст").font(.title2).bold()
                        }
                    }
                    Spacer()
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                
                
            }
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        data.isActionSheetPresented = true
                    }, label: {
                        Text("Удалить")
                            .foregroundColor(.red)
                            .frame(width: UIScreen.main.bounds.width, height: 49)
                    })
                    
                    
                    Spacer()
                }
                .overlay(Divider(), alignment: .top)
                .background(Color("White2").edgesIgnoringSafeArea([.bottom, .leading, .trailing])
)
            }
            .actionSheet(isPresented: $data.isActionSheetPresented, content: {
                ActionSheet(title: Text("AppointmentConfirmation"), message: nil, buttons: [
                    .destructive(Text("Удалить")){
                        data.deleteAppointment(presentationMode: presentationMode)
                    },
                    .cancel()
                ])
            })
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Отменить")
            })  ,trailing:  data.isEditAllowed ? Button(action: {
                data.isSheetPresented = true
            }, label: {
                Text("Изменить").foregroundColor(.white)
                }) : nil)
            
//                .introspectTabBarController { (UITabBarController: UITabBarController) in
//                            UITabBarController.tabBar.isHidden = true
//                }
        }
        .sheet(isPresented: $data.isSheetPresented, content: {
            AppointmentCreateView(patient: nil, isAppointmentPresented: $data.isSheetPresented, viewType: .editCalendar, appointment: data.appointment, appointmentCalendar: $data.appointment)
        })
        .onDisappear(perform: {
            if data.fullScreenIsCalendar != nil {
                data.fullScreenIsCalendar!.wrappedValue = false
            }
        })
        
    }
    
}

//struct AppointmentCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentCalendarView(appointment: Appointment(id: "1", title: "Кикимов Даниил", patientID: "1", owner: "1", toothNumber: "1К", diagnosis: "Пульпит:20000:10000;Чистка зубов:5000:3000", price: 0, dateStart: "1608740728", dateEnd: "1608740928"), true, fullScreenIsCalendar: <#Binding<Bool>#>)
//    }
//}

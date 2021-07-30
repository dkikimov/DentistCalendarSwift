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
    //    @EnvironmentObject var internetConnectionManager: InternetConnectionManager
    @ObservedObject var data: AppointmentCalendarViewModel
    @State var diagnosisList = [Service]()
    @State var serviceSum: Decimal = 0
    @State var servicePaid: Decimal = 0
    init(appointment: Appointment, _ isEditAllowed: Bool = true) {
        data = AppointmentCalendarViewModel(appointment: appointment, isEditAllowed: isEditAllowed)
    }
    var body: some View {
        NavigationView {
            ZStack {
                Print("UPDATING CALENDAR VIEW")
                ScrollView{
                    VStack(alignment: .leading) {
                        Text(data.appointment.title).font(.title).bold()
                        Text(dateFormatter(date: data.appointment.dateStart))
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#8a8888"))
                        Text("с ".localized + dateFormatter(date: data.appointment.dateStart, true) + " до ".localized + dateFormatter(date: data.appointment.dateEnd, true))
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
                                Text("Общая стоимость: ").bold() + Text(serviceSum.currencyFormatted)
                                Text("Оплачено: ").bold() + Text(servicePaid.currencyFormatted)
                                ( Text("Осталось к оплате: ").bold() + Text((serviceSum - servicePaid).currencyFormatted))
                                    .minimumScaleFactor(0.8)
                                
                                
                            }
                            .lineLimit(10)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineBreakMode(.byCharWrapping)
                            
                        } else {
                            if data.appointment.patientID != nil {
                                Text("Список услуг пуст").font(.title2).bold()
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    
                    
                }
                VStack {
                    Spacer()
                    HStack{
                        Button(action: {
                            data.isActionSheetPresented = true
                        }, label: {
//                            Spacer()
                            Text("Удалить")
                                .foregroundColor(.red)
                                .frame(height: 49)
                                .frame(maxWidth: .infinity)
//                            Spacer()
                        }).actionSheet(isPresented: $data.isActionSheetPresented, content: {
                            ActionSheet(title: Text("AppointmentConfirmation"), message: nil, buttons: [
                                .destructive(Text("Удалить")){
                                    data.deleteAppointment(presentationMode: presentationMode)
                                },
                                .cancel()
                            ])
                        })
                        
                        
                    }
                    .overlay(Divider(), alignment: .top)
                    .background(Color("White2").edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                    )
                }
                .navigationBarItems(leading: Button(action: {
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
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
            
            
            
            .onChange(of: data.isSheetPresented, perform: { value in
                if value == false {
                    let res = countBilling(appointment: data.appointment)
                    self.serviceSum = res.1
                    self.servicePaid = res.0
                    self.diagnosisList = res.2
                    
                }
            })
            .onAppear(perform: {
                let res = countBilling(appointment: data.appointment)
                self.serviceSum = res.1
                self.servicePaid = res.0
                self.diagnosisList = res.2
                showInterstitial(placement: "AppointmentCalendarView")
                print("SHOWING INTERSTITIAL")

            })
            .navigationBarTitle(Text("Детали записи"), displayMode: .inline)
            .sheet(isPresented: $data.isSheetPresented, content: {
                AppointmentCreateView(patient: nil, isAppointmentPresented: $data.isSheetPresented, viewType: .editCalendar, appointment: data.appointment, appointmentCalendar: $data.appointment)
                
            })
        }
        
    }
    
    
}

//struct AppointmentCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppointmentCalendarView(appointment: Appointment(id: "1", title: "Кикимов Даниил", patientID: "1", owner: "1", toothNumber: "1К", diagnosis: "Пульпит:20000:10000;Чистка зубов:5000:3000", price: 0, dateStart: "1608740728", dateEnd: "1608740928"), true, fullScreenIsCalendar: <#Binding<Bool>#>)
//    }
//}

//
//  PatientDetailCard.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/20/20.
//

import SwiftUI

func stringToDate(date: String) -> String {
    let convertedDate = Date(timeIntervalSince1970: Double(date)!)
    let dateFormatter = DateFormatter() //Set timezone that you want
    dateFormatter.locale = Locale.init(identifier: Locale.preferredLanguages.first!)
    dateFormatter.dateFormat = "d MMMM YYYY - HH:mm" //Specify your format that you want
    let strDate = dateFormatter.string(from: convertedDate)
    return strDate
}

struct PatientDetailCard: View {
    var appointment: Appointment
    var detailButtonAction: () -> Void
    var moreButtonAction: () -> Void
    @State var serviceSum = 0.0
    @State var servicePaid = 0.0
    var body: some View {
                    
        //        Text(diagnosis)
//        VStack(spacing: 10) {
//            HStack(spacing: 10){
//                Text("Зуб: ").bold()
//                Spacer(minLength: 0)
//                Button(action: moreButtonAction, label: {
//                    Image("menu")
//                        .renderingMode(.template)
//                        .resizable()
//                        .frame(width: 18, height: 18)
//                        .foregroundColor(Color("Gray1"))
//                })
//
//            }
//            HStack(spacing: 10){
//
//                Text("Диагноз: ").bold()
//
//                Spacer(minLength: 0)
//                Button(action: moreButtonAction, label: {
//                    Image("menu")
//                        .renderingMode(.template)
//                        .resizable()
//                        .frame(width: 18, height: 18)
//                        .foregroundColor(.white)
//                })
//
//            }
//            HStack(spacing: 10) {
//                Text(stringToDate(date: appointment.dateStart))
//                    .font(.system(size: 14, weight: .bold, design: .default))
//                    .fontWeight(.bold)
//                    .clipShape(Rectangle()).padding(10)
//                    .background(Color("Blue"))
//                    .foregroundColor(.white)
//                    .frame(height: 32)
//                    .cornerRadius(18)
//
//                Text(String(appointment.price))
//                    .font(.system(size: 14, weight: .bold, design: .default))
//                    .fontWeight(.bold)
//                    .clipShape(Rectangle()).padding(10)
//                    .foregroundColor(Color(hex: "#61BB42"))
//                    .background(Color(hex: "#e5f6e0"))
//                    .frame(height: 32)
//                    .cornerRadius(18)
//                    }
//        }
        Button(action: {
            detailButtonAction()
        }, label: {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing:3){
                    Image("tooth").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .padding(.horizontal, 10)
                        .foregroundColor(Color("Gray1"))
                    Text("Зуб:")
                    Text(String(appointment.toothNumber ?? "Пусто".localized)).fontWeight(.bold)
                    Spacer()
//                        HStack(spacing:10) {
//    //                        Button(action: detailButtonAction) {
//    //                            Image(systemName: "eye")
//    //                                .resizable()
//    //                                .aspectRatio(contentMode: .fit)
//    //                                .frame(width: 18, height: 18)
//    //                                .foregroundColor(Color("Gray1"))
//    //                        }
////                            Button(action: moreButtonAction) {
////                                Image(systemName: "ellipsis")
////                                    .resizable()
////                                    .aspectRatio(contentMode: .fit)
////                                    .frame(width: 18, height: 18)
////                                    .foregroundColor(Color("Gray1"))
////                                    .rotationEffect(.init(degrees: 90))
////                            }
//                        }
//                    .padding(.horizontal, 15)
                }
                
                
                HStack(alignment: VerticalAlignment.firstTextBaseline, spacing:3){
                    Image("id-card").resizable().aspectRatio(contentMode: .fit).frame(width: 18, height: 18).offset(y: 2)
                        .foregroundColor(Color("Gray1")).padding(.horizontal, 10)
                    Text("Услуги: ")
                        + Text(convertDiagnosisString(str: appointment.diagnosis!).localized)
                        .fontWeight(.bold)
                        
                }
                HStack(alignment: VerticalAlignment.firstTextBaseline, spacing:3){
                    Image(systemName: "calendar").resizable().aspectRatio(contentMode: .fit).frame(width: 18, height: 18).offset(y: 2)
                        .foregroundColor(Color("Gray1")).padding(.horizontal, 10)
                    Text("Дата: ")
                        + Text(stringToDate(date: appointment.dateStart))
                        .fontWeight(.bold)
                        
                }
                if appointment.payments != nil && !appointment.diagnosis!.isEmpty {
                    HStack {
                        VStack(spacing: 2) {
                            HStack {
                                Text((servicePaid.formattedAmount ?? "0") + " " + String(describing: Locale.current.currencySymbol ?? ""))
                                    .bold()
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                Spacer()
                                Text((serviceSum.formattedAmount ?? "0") + " " + String(describing: Locale.current.currencySymbol ?? ""))
                                    .bold()
                                    .font(.footnote)
                                    .lineLimit(1)
                            }
                            ProgressView(value: servicePaid, total: serviceSum)
                                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                                .progressViewStyle(LinearProgressViewStyle())
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 12)
                }
    //            HStack{
    //                Spacer()
    //                Text(stringToDate(date: appointment.dateStart))
    //                    .font(.system(size: 14, weight: .bold, design: .default))
    //                    .fontWeight(.bold)
    //                    .clipShape(Rectangle()).padding(10)
    //                    .background(Color("Blue2"))
    //                    .foregroundColor(.white)
    //                    .frame(height: 32)
    //                    .cornerRadius(18)
    //
    //                Text(String(appointment.price!))
    //                    .font(.system(size: 14, weight: .bold, design: .default))
    //                    .fontWeight(.bold)
    //                    .clipShape(Rectangle()).padding(10)
    //                    .foregroundColor(Color(hex: "#61BB42"))
    //                    .background(Color(hex: "#e5f6e0"))
    //                    .frame(height: 32).cornerRadius(18)
    //                Spacer()
    //
    //            }.padding(.top, 7)
            }
            
            
            .padding(20)
    //        .shadow(color: Color(.black).opacity(0.03), radius: 10, x: 0, y: 1)
            .background(Color("White1"))
            .cornerRadius(20)
            
            .foregroundColor(Color("Black1"))
        })
        .overlay(
            Button(action: moreButtonAction) {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color("Gray1"))
                    .rotationEffect(.init(degrees: 90))
                    .padding(.horizontal, 15)
                    .padding(.top, 3)
                    .padding()
            }
            
            , alignment: .topTrailing
        )
        .onAppear(perform: {
            let res = countBilling(appointment: appointment)
            self.servicePaid = Double(truncating: res.1 as NSNumber)
            self.serviceSum = Double(truncating: res.0 as NSNumber)
            print("SERVICE SUM", serviceSum)
            print("SERVICE PAID", servicePaid)
            if serviceSum < servicePaid {
                self.serviceSum = servicePaid
            }
        })
    }
    
    
}

//struct PatientDetailCard_Previews: PreviewProvider {
//    static var previews: some View {
////        PatientDetailCard(toothNumber: "31", diagnosis: "Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, ", date: "2020-10-15", time: "23:00", price: 25000)
//        PatientDetailCard(appointment: Appointment.init(id: "1", title: "Вася Пупкин", patientID: "1", owner: "1", toothNumber: "13 П, 16 Д", diagnosis: "Пульпит, восстановление, кариес", price: 100000, dateStart: "1620662138", dateEnd: "1620665738", payments: nil)) {
//
//        } moreButtonAction: {
//
//        }
//
//    }
//}


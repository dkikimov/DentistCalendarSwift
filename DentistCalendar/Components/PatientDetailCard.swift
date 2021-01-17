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
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing:3){
                Image("tooth").resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color("Gray1"))
                Text("Зуб:")
                Text(String(appointment.toothNumber!)).fontWeight(.bold)
                Spacer()
                    HStack(spacing:10) {
                        Button(action: detailButtonAction) {
                            Image(systemName: "eye")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color("Gray1"))
                        }
                        Button(action: moreButtonAction) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color("Gray1"))
                                .rotationEffect(.init(degrees: 90))
                        }
                    }
                .padding(.horizontal, 15)
            }
            
            HStack(alignment: VerticalAlignment.firstTextBaseline, spacing:3){
                Image("id-card").resizable().aspectRatio(contentMode: .fit).frame(width: 18, height: 18).offset(y: 2)
                    .foregroundColor(Color("Gray1")).padding(.horizontal, 10)
                Text("Услуги: ")
                    + Text(convertDiagnosisString(str: appointment.diagnosis!).localized)
                    .fontWeight(.bold)
                    
            }
            HStack{
                Spacer()
                Text(stringToDate(date: appointment.dateStart))
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .fontWeight(.bold)
                    .clipShape(Rectangle()).padding(10)
                    .background(Color("Blue2"))
                    .foregroundColor(.white)
                    .frame(height: 32)
                    .cornerRadius(18)

                Text(String(appointment.price!))
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .fontWeight(.bold)
                    .clipShape(Rectangle()).padding(10)
                    .foregroundColor(Color(hex: "#61BB42"))
                    .background(Color(hex: "#e5f6e0"))
                    .frame(height: 32).cornerRadius(18)
                Spacer()

            }.padding(.top, 7)
        }
        .padding(20)
//        .shadow(color: Color(.black).opacity(0.03), radius: 10, x: 0, y: 1)
        .background(Color("White1"))
        .cornerRadius(20)
    }
}

//struct PatientDetailCard_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientDetailCard(toothNumber: "31", diagnosis: "Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, ", date: "2020-10-15", time: "23:00", price: 25000)
//    }
//}


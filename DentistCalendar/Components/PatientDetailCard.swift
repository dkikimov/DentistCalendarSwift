//
//  PatientDetailCard.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/20/20.
//

import SwiftUI

func stringToDate(date: String) -> String {
    let formatter4 = DateFormatter()
    formatter4.dateFormat = "YYYY-MMMM-DD"
    formatter4.locale = .autoupdatingCurrent
    let date = formatter4.date(from: date) ?? Date()
    return date.format(with: "d MMMM YYYY", locale: .autoupdatingCurrent)
    
}

struct PatientDetailCard: View {
    var toothNumber: String
    var diagnosis: String
    var date: String
    var time: String
    var price: Int
    var moreButtonAction: () -> Void
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            HStack{
                Spacer()
            }
            HStack(){
                Spacer()
                Button(action: moreButtonAction, label: {
                    Image(systemName: "ellipsis")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("Gray1"))
                        .frame(width: 50, height: 50)
                        .zIndex(10000)
                        .rotationEffect(.init(degrees: 90))
                    
                }).frame(width: 36, height: 50)

                
                
            }.padding(.horizontal, 15)
            .zIndex(10)
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing:3){
                    
                    Image("tooth").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .padding(.horizontal, 10)
                        .foregroundColor(Color("Gray1"))
                    Text("Зуб:")
                    Text(toothNumber).fontWeight(.bold)
                }
                HStack(alignment: VerticalAlignment.firstTextBaseline, spacing:3){
                    Image("id-card").resizable().aspectRatio(contentMode: .fit).frame(width: 18, height: 18).offset(y: 2)
                        .foregroundColor(Color("Gray1")).padding(.horizontal, 10)
                    Text("Диагноз: ")
                        + Text(diagnosis).fontWeight(.bold)

                    
                }
                HStack{
                    Spacer()
                    Text("\(stringToDate(date: date)) - \(self.time)")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .fontWeight(.bold)
                        .clipShape(Rectangle()).padding(10)
                        .background(Color("Blue"))
                        .foregroundColor(.white)
                        .frame(height: 32 )
                        .cornerRadius(18)
                        
                    Text(String(price))
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .fontWeight(.bold)
                        .clipShape(Rectangle()).padding(10)
                        .foregroundColor(Color(hex: "#61BB42"))
                        .background(Color(hex: "#e5f6e0"))
                        .frame(height: 32).cornerRadius(18)
                    Spacer()

                }.padding(.top, 7)
            }
            
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .shadow(color: Color(.black).opacity(0.03), radius: 10, x: 0, y: 1)
            .background(Color.white)

        }
        .cornerRadius(10)
.shadow(color: Color(.black).opacity(0.03), radius: 10, x: 0, y: 1)
    }
}

//struct PatientDetailCard_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientDetailCard(toothNumber: "31", diagnosis: "Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, Пульпит, ", date: "2020-10-15", time: "23:00", price: 25000)
//    }
//}

//
//  BuySubscriptionView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 03.01.2021.
//

import SwiftUI

struct BuySubscriptionView: View {
    let benefitsList = ["Больше никакой рекламы", "Синхронизируйте ваши данные", "Используйте на нескольких устройствах", "Импортируйте данные из календаря", "В будущем: генерируйте документы и выписки"]
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject private var store: Store
//    @ObservedObject var productsStore : ProductsStore


    var body: some View {

        VStack(alignment: .leading, spacing: 25) {

            VStack(alignment: .leading) {
                Button(action: {
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundColor(Color("StaticBlue"))

                }).padding(.bottom, 5)
                Text("DentistApp Premium")
                    .font(.largeTitle)
                    .bold()
                Text("Разблокируйте:")
                    .font(.title2)
                    .bold()
            }
            VStack(alignment: .leading, spacing: 8) {
                ForEach(benefitsList, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color("StaticBlue"))
                        Text(item.localized)
                            .bold()
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            VStack {
                HStack {
                    Text("1 месяц").bold()
                    Spacer()
                    Text("849 тенге").bold()
                }
                .frame(maxWidth: 450)
                .padding()
                .background(Color("StaticBlue"))
                .foregroundColor(.white)
                .clipShape(Rectangle())
                .cornerRadius(8)


                HStack {
                    Spacer()
                    Button(action: {

                    }, label: {
                        Text("Восстановить покупки")
                            .font(.caption)
                            .bold()
                    })
                    Spacer()
                }
                HStack(spacing: 5) {
                    Spacer()
                    Button(action: {

                    }, label: {
                        Text("Условия использования")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(Color("Black1"))

                    })
                    Button(action: {

                    }, label: {
                        Text("Политика конфиденциальности")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(Color("Black1"))
                            .lineLimit(1)
                    })
                    Spacer()
                }
            }




            Spacer()
                .frame(maxHeight: 300)

            HStack {
                Spacer()
                Button(action: {

                }, label: {

                    Text("Подписаться")
                        .bold()
                        .frame(maxWidth: 450)
                        .padding()
                })
                .background(Color("StaticBlue"))
                .foregroundColor(.white)
                .clipShape(Rectangle())
                .cornerRadius(8)
                Spacer()
            }
        }
        .padding()

        //        }.frame(maxHeight: UIScreen.main.bounds.height)
    }
}
//struct BuySubscriptionView: View {
//    @State var selectedDate = Date()
//    var body: some View {
//        Form {
//            DatePicker("When is your birthday?", selection: $selectedDate, displayedComponents: .date)
//                .datePickerStyle(GraphicalDatePickerStyle())
//        }
//    }
//}
//struct BuySubscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            BuySubscriptionView()
//            
//        }
//    }
//}

//
//  WalktroughView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 24.02.2021.
//

import SwiftUI
//            VStack(spacing: 10) {
//                Text("Приветствуем!")
//                    .font(.largeTitle)
//
//                    .fontWeight(.heavy)
//                    .multilineTextAlignment(.leading)
//                    .lineLimit(nil)
//                    .frame(width: UIScreen.main.bounds.width - 10)
//
//
//                Text("Спасибо что пользуетесь нашим приложением! Если вы новенький, то можете пройти краткую экскурсию по всем основным функциям нашего приложения!")
//                    .fontWeight(.semibold)
//                    .frame(width: UIScreen.main.bounds.width - 10)
//                    .multilineTextAlignment(.leading)
//                    .lineLimit(nil)
//
//
//                Spacer(minLength: 0)
//                    .frame(height: 50)
//                HStack {
//                    Button(action: {
//                        isShown = false
//                    }, label: {
//                        Text("Пропустить")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(width: 170, height: 44)
//                            .background(Color.blue)
//                            .cornerRadius(12)
//                            .padding(.horizontal, 5)
//
//                    })
//                    Button(action: {
//                        selection += 1
//                    }, label: {
//                        Text("Пройти экскурсию")
//                            .fontWeight(.heavy)
//                            .padding()
//                            .frame(width: 170, height: 44)
//                            .background(Color.blue)
//                            .cornerRadius(12)
//                            .padding(.horizontal, 5)
//
//                    })
//                }
//            }

//            .foregroundColor(.white)
struct WalktroughView: View {
    @State private var selection = -1
    @Binding var isWalkthroughViewShowing: Bool
    var body: some View {
        ZStack {
            Color(hex: "#3D5A80").ignoresSafeArea()
            VStack {
                if selection == -1 {
                    TabDetailsView(imageUrl: "", title: "Приветствуем!", content: "Спасибо что пользуетесь нашим приложением! Если вы новенький, то можете пройти краткую экскурсию по всем основным функциям нашего приложения!")
                    ButtonsView(selection: $selection, isShown: $isWalkthroughViewShowing, buttons: [
                                    "Пропустить".localized, "Начать".localized])
                } else {
                    PageTabView(selection: $selection, isShown: $isWalkthroughViewShowing)
                    ButtonsView(selection: $selection, isShown: $isWalkthroughViewShowing, buttons: [
                        "Предыдущий".localized,
                        "Следующий".localized
                    ])
                }
                
            }
        }
        .transition(AnyTransition.move(edge: .bottom))
    }
}

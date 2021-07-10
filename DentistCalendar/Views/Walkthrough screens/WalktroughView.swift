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
            Color(hex: "#2474E2").ignoresSafeArea()
            
            VStack {
                HStack(alignment: .bottom) {
                    Spacer()

                    Button(action: {
                        DispatchQueue.main.async {
                            isWalkthroughViewShowing = false
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2, weight: .bold)
                            .foregroundColor(.white)
    //                        .backgroundFill(Color(hex: "#2474E2"))
                        })
                    .opacity(0.7)
                    .padding()
                    
                }
                .padding(.bottom, 5)
                .padding(.top, 12)
                .frame(height: 30)
                
                Spacer()
//                HStack {
//                    Spacer()
//
//                }
//                .padding(.bottom, 5)
                
                //                if selection == -1 {
                //                    TabDetailsView(imageUrl: "", title: "Приветствуем!", content: "Спасибо что пользуетесь нашим приложением! Если вы новенький, то можете пройти краткую экскурсию по всем основным функциям нашего приложения!")
                ////                        .padding()
                //                    ButtonsView(selection: $selection, isShown: $isWalkthroughViewShowing, buttons: [
                //                                    "Пропустить".localized, "Начать".localized], backgroundColor: Color(hex: "#E7EFFF"), foregroundColor: Color(#colorLiteral(red: 0.1647058824, green: 0.5254901961, blue: 1, alpha: 1)))
                //                } else {
                PageTabView(selection: $selection, isShown: $isWalkthroughViewShowing)
                ButtonsView(selection: $selection, isShown: $isWalkthroughViewShowing, backgroundColor: Color(hex: "#E7EFFF"), foregroundColor: Color(#colorLiteral(red: 0.1647058824, green: 0.5254901961, blue: 1, alpha: 1)))
                    .frame(maxHeight: 50)
                    .padding(.bottom, 8)
                //                }
                
            }
            
        }
        .transition(AnyTransition.move(edge: .bottom))
    }
}

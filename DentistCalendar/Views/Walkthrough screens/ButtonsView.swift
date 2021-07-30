//
//  ButtonsView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 24.02.2021.
//

import SwiftUI
struct BlueButton: View {
    var buttonLabel: String
    var action: () -> Void
    var backgroundColor = Color.blue
    var foregroundColor = Color.white
    var width: CGFloat = 170
    var height: CGFloat = 44
    var body: some View {
        Button(action: action, label: {
            Text(buttonLabel)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity)
                
                
        })
        .padding()
        .frame(width: width, height: height)
        .background(backgroundColor)
        .cornerRadius(12)
        .padding(.horizontal, 5)
        .foregroundColor(foregroundColor)
        
    }
}
// а расположение то что они рядом норм?
struct ButtonsView: View {
    @Binding var selection: Int
    @Binding var isShown: Bool
    @State var buttonLabel: String = "Далее".localized
    var backgroundColor = Color.blue
    var foregroundColor = Color.white
    var body: some View {
        //        VStack {
        //            Spacer()
        //            HStack {
        //    //            Button {
        //    //                buttonAction("Пропустить") // тут не надо, тут по дефу localized
        //    //
        //    //            } label: {
        //    //                Text("Пропустить")
        //    //                    .foregroundColor(.white)
        //    //            }.padding()
        //    //            Spacer()
        //                Button {
        //                    buttonAction()
        //                } label: {
        //                    Image(systemName: .arrowRightCircleFill)
        //                        .font(.largeTitle)
        //                        .foregroundColor(.white)
        //                }
        //                .padding()
        //    //            .frame(width: 50, height: 50)
        //    //            .cornerRadius(25)
        //    //            BlueButton(buttonLabel: buttonLabel, action: {
        //    //                buttonAction()
        //    //            }, backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        //    //            ForEach(buttons, id: \.self) { buttonLabel in
        //    //                BlueButton(buttonLabel: buttonLabel, action: {
        //    //                    buttonAction(buttonLabel)
        //    //                }, backgroundColor: backgroundColor, foregroundColor: foregroundColor)
        //    //            }
        //            }
        //            Spacer()
        //        }
        GeometryReader { geom in
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    BlueButton(buttonLabel: buttonLabel, action: {
                        buttonAction()
                    }, backgroundColor: backgroundColor, foregroundColor: foregroundColor, width: geom.size.width - 40)
                    
                    Spacer()
                }
//                Button(action: {
//                    DispatchQueue.main.async {
//                        isShown = false
//                    }
//                }, label: {
//                    Text("Пропустить")
//                        .bold()
//                        .foregroundColor(.systemGray6)
//                })
                Spacer()
            }
        }
        .onChange(of: selection, perform: { newValue in
            withAnimation {
                if newValue == tabs.count - 1 {
                    self.buttonLabel = "Приступить к работе".localized
                } else {
                    self.buttonLabel = "Далее".localized
                }
            }
        })
    }
    func buttonAction() {
        withAnimation {
            if selection < tabs.count - 1{
                selection += 1
            }
            else if selection == tabs.count - 1 {
                withAnimation {
                    isShown = false
                }
            }
        }
    }
}

//struct ButtonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonsView()
//    }
//}

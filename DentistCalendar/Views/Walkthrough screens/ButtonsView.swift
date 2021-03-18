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
    var body: some View {
        Button(action: action, label: {
            Text(buttonLabel)
                .fontWeight(.heavy)
                .padding()
                .frame(width: 170, height: 44)
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal, 5)
        })
        .foregroundColor(.white)

    }
}
struct ButtonsView: View {
    @Binding var selection: Int
    @Binding var isShown: Bool
    @State var buttons: [String]
    var body: some View {
        HStack {
            ForEach(buttons, id: \.self) { buttonLabel in
                BlueButton(buttonLabel: buttonLabel) {
                    buttonAction(buttonLabel)
                }
            }
        }
        .onChange(of: selection, perform: { newValue in
            if newValue == tabs.count - 1 {
                self.buttons[1] = "Закончить".localized
            } else {
                self.buttons[1] = "Следующий".localized
            }
        })
        .padding()
    }
    func buttonAction(_ buttonLabel: String) {
        withAnimation {
            if buttonLabel == "Пропустить".localized {
                withAnimation {
                    isShown = false
                }
            }
            else if buttonLabel == buttons[0] && selection > 0{
                selection -= 1
            } else if buttonLabel == buttons[1] {
                if  selection < tabs.count - 1{
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
}

//struct ButtonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonsView()
//    }
//}

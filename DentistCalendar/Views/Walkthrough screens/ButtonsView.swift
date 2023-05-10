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

struct ButtonsView: View {
    @Binding var selection: Int
    @Binding var isShown: Bool
    @State var buttonLabel: String = "Далее".localized
    var backgroundColor = Color.blue
    var foregroundColor = Color.white
    var body: some View {

        GeometryReader { geom in
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    BlueButton(buttonLabel: buttonLabel, action: {
                        buttonAction()
                    }, backgroundColor: backgroundColor, foregroundColor: foregroundColor, width: geom.size.width - 40)
                    
                    Spacer()
                }
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

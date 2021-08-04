//
//  CloseButton.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 14.07.2021.
//

import SwiftUI
struct CloseButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    var presentationMode: Binding<PresentationMode>
    var color: Color?
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
//            SOCExitButton()
//            ZStack {
//                Circle()
//                    .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
//                Image(systemName: "xmark")
//                    .resizable()
//                    .scaledToFit()
//                    .font(Font.body.weight(.bold))
//                    .scaleEffect(0.416)
//                    .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
//            }
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2, weight: .bold)
                            .foregroundColor(color != nil ? color! : Color("CloseButtonGray"))
            
            
            
        })
        .padding()
//        .frame(width: 24, height: 24)
        //        .buttonStyle(SOCExitButton())
    }
}

//struct CloseButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CloseButton()
//    }
//}

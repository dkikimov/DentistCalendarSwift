//
//  CloseButton.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 14.07.2021.
//

import SwiftUI

struct CloseButton: View {
    var presentationMode: Binding<PresentationMode>
    var color: Color?
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            
            Image(systemName: "xmark.circle.fill")
                .font(.title2, weight: .bold)
                .foregroundColor(color != nil ? color! : Color("CloseButtonGray"))
                //
            
            
        })
        .padding()
    }
}

//struct CloseButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CloseButton()
//    }
//}

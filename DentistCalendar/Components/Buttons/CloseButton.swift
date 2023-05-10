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
    var action: () -> () = {}
    var body: some View {
        Button(action: {
            action()
            presentationMode.wrappedValue.dismiss()
        }, label: {
            SOCExitButton()
        })
        .frame(width: 36, height: 36)
    }
}

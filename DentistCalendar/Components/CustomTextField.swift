//
//  CustomTextField.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/18/20.
//

import SwiftUI

struct CustomTextField: View {
    var label : String
    var title: String
    @Binding var text: String
    var isSecure : Bool
    var keyboardType : UIKeyboardType
    var body: some View {
        VStack(alignment: .leading) {
            if isSecure {
                Text(label)
                    .font(.callout)
                    .bold()
                SecureField(title, text: self.$text).keyboardType(keyboardType)
                Divider()
            } else {
                Text(label)
                    .font(.callout)
                    .bold()
                TextField(title, text: self.$text).keyboardType(keyboardType)
                Divider()
            }
            
        }
    }
}

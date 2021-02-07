//
//  CustomButton.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/18/20.
//

import SwiftUI

struct CustomButton: View{
    var action:  () -> Void
    var imageName: String?
    var label : String
    var color : String = "Green"
    var textColor : Color = .white
    var disabled: Bool = false
    @Binding var isLoading: Bool
    var body: some View {
        Button(action: action) {
            HStack {
                if !isLoading {
                    if imageName != nil {
                        Image(systemName: imageName!)
                            .font(.title3)
                    }
                    
                    Text(label.localized)
                        .fontWeight(.semibold)
                        .font(.title3)
                } else {
                    ProgressView()
                }
            }
            .frame(minWidth: 0, maxWidth: 450)
            .padding()
            .foregroundColor(disabled ? textColor.opacity(0.6) : textColor)
            .background(disabled ? Color.gray : Color(color))
            .cornerRadius(40)
            .padding(.horizontal, 20)
        }
        .disabled(disabled)
        
    }
}

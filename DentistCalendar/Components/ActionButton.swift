//
//  ActionButton.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10.04.2021.
//

import SwiftUI

struct ActionButton: View {
    var buttonLabel: String
    var action: () -> Void
    var color: Color
    var fontColor: Color
    var fontWeight: Font.Weight
    var font: Font
    
    @Binding var isLoading: Bool
    @Binding var isDisabled: Bool
    init(buttonLabel: String, color: Color = Color("PrimaryColor"), fontWeight: Font.Weight = .semibold, font: Font = .title3, fontColor: Color = .white, isLoading: Binding<Bool>? = nil, isDisabled: Binding<Bool>? = nil, action: @escaping () -> Void) {
        self.buttonLabel = buttonLabel
        self.action = action
        self.color = color
        self.fontWeight = fontWeight
        self.font = font
        self._isLoading = isLoading ?? Binding.constant(false)
        self.fontColor = fontColor
        self._isDisabled = isDisabled ?? Binding.constant(false)
    }
    
    var body: some View {
        Button(action: action, label: {
            ZStack {
                if !isLoading  {
                    HStack {
                        Text(buttonLabel.localized)
                            .fontWeight(fontWeight)
                            .font(font)
                            .foregroundColor(fontColor)
                    }

                        
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: fontColor))
                }
            }
            .frame(height: 60)
            .frame(maxWidth: 450)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .shadow(color: Color.black.opacity(0.13), radius: 8, x: 5, y: 5)

        })
        
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(buttonLabel: "nil", color: .accentColor, action: {
        })
    }
}

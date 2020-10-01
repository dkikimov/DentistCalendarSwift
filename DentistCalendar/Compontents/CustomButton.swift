//
//  CustomButton.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/26/20.
//

import SwiftUI

struct CustomButton: View {
    var action:  () -> Void
    var imageName: String
    var label : String
    var color : String = "Green"
    var textColor : Color = .white
    @Binding var isLoading: Bool
    var body: some View {
        Button(action: action) {
            HStack {
                if !isLoading {
                    Image(systemName: imageName)
                        .font(.title3)
                
                Text(label)
                    .fontWeight(.semibold)
                    .font(.title3)
                } else {
                    ProgressView()
                }
            }
            .frame(minWidth: 0, maxWidth: 450)
            .padding()
            .foregroundColor(textColor)
            .background(Color(color))
            .cornerRadius(40)
            .padding(.horizontal, 20)
            
        }
    }
}


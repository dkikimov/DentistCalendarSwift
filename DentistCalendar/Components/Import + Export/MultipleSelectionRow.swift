//
//  MultipleSelectionRow.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.12.2020.
//

import SwiftUI

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                Spacer()
                if self.isSelected {
                    VStack {
                        ZStack {
                            Color.white
                                .frame(width: 14, height: 14)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
        }
        .listRowBackground(isSelected ? Color("Gray3") : Color.clear)
    }
}

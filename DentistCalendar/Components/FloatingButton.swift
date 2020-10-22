//
//  FloatingButton.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/22/20.
//

import SwiftUI

struct FloatingButton: View {
    var moreButtonAction: () -> Void
    
    var body: some View {
        
        Button(action: moreButtonAction, label: {
            Image(systemName: "plus").resizable().frame(width: 15, height: 15).padding(22)
        }).background(Color("Blue"))
        .foregroundColor(.white)
        .clipShape(Circle())
        
    }
}


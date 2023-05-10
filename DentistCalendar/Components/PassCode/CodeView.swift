//
//  CodeView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 28.02.2021.
//

import SwiftUI

struct CodeView: View {
    var code: String
    
    var body: some View{
        
        VStack(spacing: 10){
            Text(code)
                .fontWeight(.bold)
                .font(.title2)
                .frame(height: 45)
            
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(height: 4)
        }
    }
}

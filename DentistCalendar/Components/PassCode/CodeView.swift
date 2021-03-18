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
                .foregroundColor(.black)
                .fontWeight(.bold)
                .font(.title2)
            // default frame...
                .frame(height: 45)
            
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(height: 4)
        }
    }
}

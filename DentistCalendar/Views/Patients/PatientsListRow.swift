//
//  PatientsListRow.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/9/20.
//

import SwiftUI

struct PatientsListRow: View {
    @State var fullname: String
    @State var id: String
    @State var phoneNumber: String
    var body: some View {
        HStack (spacing: 10){
            AvatarBlock(fullname: fullname.split(separator: " "))
            
            VStack(alignment: .leading) {
                Text(fullname).fontWeight(.bold)
                Text(phoneNumber).foregroundColor(.gray)
            }
            
        }.frame(height: 55)
    }
}




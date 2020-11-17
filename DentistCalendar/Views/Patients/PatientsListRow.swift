//
//  PatientsListRow.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/9/20.
//

import SwiftUI

struct PatientsListRow: View {
//    @State var fullname: String
//    @State var id: String
//    @State var phoneNumber: String
    @Binding var patient: Patient
    var body: some View {
        HStack (spacing: 10){
            AvatarBlock(fullname: patient.fullname.split(separator: " "))
            
            VStack(alignment: .leading) {
                Text(patient.fullname).fontWeight(.bold)
                Text(patient.phone).foregroundColor(.gray)
            }
            
        }.frame(height: 55)
    }
}




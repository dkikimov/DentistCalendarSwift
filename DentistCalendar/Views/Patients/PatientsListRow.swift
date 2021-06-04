//
//  PatientsListRow.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/9/20.
//

import SwiftUI
import PhoneNumberKit
struct PatientsListRow: View {
//    @State var fullname: String
//    @State var id: String
//    @State var phoneNumber: String
    @State var patient: Patient
    var body: some View {
        HStack (spacing: 10){
            AvatarBlock(fullname: patient.fullname)
            
            VStack(alignment: .leading) {
                Text(patient.fullname).fontWeight(.bold)
                Text(partialFormatter.formatPartial(patient.phone ?? "")).foregroundColor(.gray)
            }
            
        }.frame(height: 55)
    }
}




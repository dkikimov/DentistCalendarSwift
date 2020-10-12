//
//  PatientsDetailView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/12/20.
//

import SwiftUI

struct PatientsDetailView: View {
    @State var patient: PatientData
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(patient.fullname).fontWeight(.bold).font(.title2)
                Text(patient.phone).foregroundColor(.gray).font(.body)
                HStack(spacing: 10) {
                    Button(action: {
                        
                    }, label: {
                        Spacer()
                        Text("Изменить").frame(height: 25).foregroundColor(.white).padding([.vertical, .horizontal], 10)
                        Spacer()

                    }).background(Color("Blue")).cornerRadius(40)
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "phone.fill").frame(width: 50, height: 45).padding([.vertical, .horizontal], 10).foregroundColor(.white)
                    }).background(Color("Green")).frame(width: 50, height: 45).clipShape(Circle())
                }
            }
            Spacer()
        }
        .padding(16)
        .navigationTitle("Карта пациента")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor( backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
    }
}

struct PatientsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PatientsDetailView(patient: PatientData(id: "123", fullname: "Кикимов Даниил", phone: "91231023", user: "123123"))
    }
}

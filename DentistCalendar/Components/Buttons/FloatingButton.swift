//
//  FloatingButton.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/22/20.
//

import SwiftUI
struct FloatingButton: View {
    var moreButtonAction: () -> Void
    var isNavigationLink: Bool = false
    var patientsListData: PatientsListViewModel?
    var body: some View {
        if isNavigationLink {
            NavigationLink(destination: PatientCreateView(patientsListData: self.patientsListData!), label: {
                Image(systemName: "plus").resizable().frame(width: 15, height: 15).padding(22)
            }).background(Color("Blue"))
            .foregroundColor(.white)
            .clipShape(Circle())
        } else {
            Button(action: moreButtonAction, label: {
                Image(systemName: "plus").resizable().frame(width: 15, height: 15).padding(22)
            }).background(Color("Blue"))
            .foregroundColor(.white)
            .clipShape(Circle())
        }
    }
}


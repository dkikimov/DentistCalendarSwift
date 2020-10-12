//
//  PatientsListView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/9/20.
//

import SwiftUI
import SwiftUIRefresh

struct PatientsListView: View {
    @StateObject var listData = PatientsListViewModel()
    var body: some View {
        NavigationView{
            Group {
                if listData.patientsList != nil && listData.patientsList!.count > 0{
                    List{
                        ForEach(listData.patientsList!, id: \.self) { patient in
                            NavigationLink(
                                destination: PatientsDetailView(patient: patient),
                                label: {
                                    PatientsListRow(fullname: patient.fullname, id: patient.id, phoneNumber: patient.phone)
                                })

                        }.onDelete(perform: deleteItem)
                    }
    
                    .pullToRefresh(isShowing: $listData
                                    .isLoading) {
                        listData.fetchPatients()
                    }
                    }
                 else if listData.patientsList?.count == 0 {
                    Text("Самое время добавить пациентов!").foregroundColor(.gray)

                } else {
                    ProgressView()
                }
            }.navigationTitle("Пациенты").navigationBarTitleDisplayMode(.large)
            .navigationBarColor( backgroundColor: .white, tintColor: .black)
            
        }

        .onAppear(perform: {
            listData.fetchPatients()
        })
    }
    func deleteItem(at offsets: IndexSet) {
        if let first = offsets.first {
            let id = listData.patientsList![first].id
            self.listData.patientsList?.remove(at: first)
            listData.deletePatient(id: id)
        }
    }
}

struct PatientsListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientsListView()
    }
}

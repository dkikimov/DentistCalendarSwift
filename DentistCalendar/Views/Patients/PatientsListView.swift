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
                if listData.patientsList != nil{
                    List{
                        ForEach(listData.patientsList!) { patient in
                            NavigationLink(
                                destination: PatientsDetailView(patientInput: patient),
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
            .edgesIgnoringSafeArea(.all)

            
        }
        
        .edgesIgnoringSafeArea(.all)
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

//
//  PatientsListView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/9/20.
//

import SwiftUI
import SwiftUIRefresh

struct PatientsListView: View {
    @ObservedObject var listData = PatientsListViewModel()
    var body: some View {
        NavigationView{
            Group {
                if listData.patientsList.count > 0 {
                    List{
                        ForEach(listData.patientsList.indices, id: \.self) { index in
                            NavigationLink(destination: PatientsDetailView(index: index, listData: listData),
                                           label: {
                                            PatientsListRow(patient: $listData.patientsList[index])
                                           })
                        }.onDelete(perform: { indexSet in
                            //                            listData.isAlertPresented = true
                            //                            listData.deleteIndexSet = indexSet
                            deleteItem(at: indexSet)
                        })
                    }.listStyle(PlainListStyle())
                    
                    .pullToRefresh(isShowing: $listData
                                    .isLoading) {
                        listData.fetchPatients()
                    }
                }
                else if listData.isLoading {
                    ProgressView()
                }
                else if listData.patientsList.count == 0 {
                    Text("Самое время добавить пациентов!").foregroundColor(.gray)
                    Text("Если вы создавали данные ранее, то они находятся в загрузке").font(.caption).foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("Пациенты")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: NavigationLink(destination: PatientCreateView(patientsListData: listData), label: {
                Image(systemName: "plus").foregroundColor(.white)
            }))
            
            
            
        }
        .onAppear(perform: {
            listData.fetchPatients()
            listData.observePatients()
        })
        .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        
    }
    func deleteItem(at offsets: IndexSet) {
        if let first = offsets.first {
            let id = listData.patientsList[first].id
            self.listData.patientsList.remove(at: first)
            listData.deletePatient(id: id)
        }
    }
}

struct PatientsListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientsListView()
    }
}

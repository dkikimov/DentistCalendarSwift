//
//  PatientsListView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/9/20.
//

import SwiftUI
import SwiftUIRefresh
import UIKit
struct PatientsListView: View {
    @ObservedObject var listData = PatientsListViewModel()
    var body: some View {
        NavigationView {
            ZStack {
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
                        }
                        .listStyle(PlainListStyle())
    //                    .pullToRefresh(isShowing: $listData
    //                                    .isLoading) {
    //                        listData.fetchPatients()
    //                    }
                        .introspectTableView { (tableView: UITableView) in
                            tableView.refreshControl = listData.refreshControl
                        }
                    }
                    else if listData.isLoading {
                        ProgressView()
                    }
                    else if listData.patientsList.count == 0 {
                        VStack(spacing: 6) {
                            Text("Самое время добавить пациентов!").foregroundColor(.gray)
                            Text("Если вы создавали данные ранее, то они находятся в загрузке")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        FloatingButton(moreButtonAction: {}, isNavigationLink: true, patientsListData: listData)
                    }.padding([.bottom, .trailing], 15)
                }
            }
            .navigationBarTitle("Пациенты", displayMode: .large)
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

//
//  PatientsListView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/9/20.
//

import SwiftUI
import UIKit
import Introspect
struct PatientsListView: View {
    @ObservedObject var listData = PatientsListViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                    if listData.patientsList.count > 0 {
                        List{
                            ForEach(Array(zip(listData.patientsList.indices, listData.patientsList)), id: \.0) { (index, item) in
//                                if index % 5 == 0 {
//                                    NativeAdView()
//                                        .frame(height: 250)
//                                }
                                NavigationLink(destination: PatientsDetailView(index: index, listData: listData, item: item),
                                               label: {
                                                PatientsListRow(patient: item)
                                               })
                            }.onDelete(perform: { indexSet in
                                //                            listData.isAlertPresented = true
                                //                            listData.deleteIndexSet = indexSet
                                deleteItem(at: indexSet)
                            })
                        }
                        .listStyle(PlainListStyle())
                        .introspectTableView { (tableView: UITableView) in
                            tableView.refreshControl = listData.refreshControl
                        }
                    }
                     if listData.isLoading {
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
        
    }
    func deleteItem(at offsets: IndexSet) {
        if let first = offsets.first {
            if listData.patientsList.count >= first {
                let id = listData.patientsList[first].id
    //            self.listData.patientsList.remove(at: first)
                print("LISTDATA", listData.patientsList)
                print("INDEX", first)
                listData.deletePatient(id: id)
//                self.listData.patientsList.remove(atOffsets: offsets)
                print("DELETED OK", listData.patientsList)
            }

        }
    }
}

struct PatientsListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientsListView()
    }
}

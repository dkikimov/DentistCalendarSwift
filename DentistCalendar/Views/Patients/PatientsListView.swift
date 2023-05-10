//
//  PatientsListView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/9/20.
//

import SwiftUI
import UIKit
import Introspect
import SwiftUIX

struct PatientsListView: View {
    @ObservedObject var listData = PatientsListViewModel()
    @State var searchText = ""
    var body: some View {
        CustomNavigationView(view: AnyView(PatientsListSearch(listData: listData)), placeHolder: "Поиск".localized, largeTitle: true, title: "Пациенты".localized, onSearch: { txt in
            if txt != "" {
                listData.isSearching = true
                withAnimation {
                    self.listData.filteredItems = listData.patientsList.filter{$0.fullname.lowercased().contains(txt.lowercased())}
                }
            }
            else{
                listData.isSearching = false
                withAnimation {
                    self.listData.filteredItems = listData.patientsList
                }
            }
            
        }, onCancel: {
            listData.isSearching = false
            withAnimation {
                self.listData.filteredItems = listData.patientsList
            }
        })
        .ignoresSafeArea()
        .onAppear(perform: {
            listData.fetchPatients()
            listData.observePatients()
        })
    }
    
}

struct PatientsListSearch: View {
    @ObservedObject var listData: PatientsListViewModel
    @State var isAlertPresented = false
    @State var selectedIndexSet: IndexSet.Element?
    @State var selectedPatient: Patient?
    var body: some View {
        ZStack {
            if listData.patientsList.count > 0 {
                List {
                    ForEach(listData.filteredItems, id: \.id) { item in
                        NavigationLink(destination: PatientsDetailView(listData: listData, item: item),
                                       label: {
                            HStack (spacing: 10){
                                AvatarBlock(fullname: item.fullname)
                                VStack(alignment: .leading) {
                                    Text(item.fullname).fontWeight(.bold)
                                    if item.phone != nil {
                                        Text(formatPhone(item.phone ?? "") ?? "").foregroundColor(.gray)
                                    }
                                }
                                
                            }.frame(height: 55)
                        })
                    }.onDelete(perform: { indexSet in
                        if let first = indexSet.first {
                            self.selectedIndexSet = first
                            self.selectedPatient = listData.filteredItems[first]
                        }
                        isAlertPresented = true
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
                    Text("Самое время добавить пациентов!")
                        .foregroundColor(.gray)
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
        .alert(isPresented: $isAlertPresented, content: {
            Alert(title: Text("Подтверждение"), message: Text("Вы уверены, что хотите удалить пациента?") , primaryButton: .cancel(), secondaryButton: .destructive(Text("Удалить"), action: {
                if let selectedIndexSet = selectedIndexSet {
                    guard listData.filteredItems[selectedIndexSet] == selectedPatient else {
                        presentErrorAlert(message: "Произошла ошибка")
                        return
                    }
                    withAnimation {
                        deleteItem(at: selectedIndexSet)
                    }
                }
                
            }))
            
        })
        
    }
    func deleteItem(at first: IndexSet.Element) {
        if listData.patientsList.count >= first {
            let id: String
            if listData.isSearching {
                id = listData.filteredItems[first].id
            } else {
                id = listData.patientsList[first].id
            }
            print("LISTDATA", listData.patientsList)
            print("INDEX", first)
            listData.deletePatient(id: id)
        }
        
        
    }
}

struct PatientsListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientsListView()
    }
}

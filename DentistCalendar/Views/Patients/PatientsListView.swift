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
            ZStack {
                Group {
                    if listData.patientsList.count > 0{
                        List{
                            ForEach(Array(listData.patientsList)) {  patient in
                                NavigationLink(destination: PatientsDetailView(patient: patient),
                                               label: {
                                    PatientsListRow(patient: patient)
                                })
                            }.onDelete(perform: { indexSet in
    //                            listData.isAlertPresented = true
    //                            listData.deleteIndexSet = indexSet
                                deleteItem(at: indexSet)
                            })
                        }
                        .pullToRefresh(isShowing: $listData
                                        .isLoading) {
                            listData.fetchPatients()
                        }
                    }
                    else if listData.patientsList.count == 0 {
                        Text("Самое время добавить пациентов!").foregroundColor(.gray)
                        
                    } else if listData.isLoading {
                        ProgressView()
                    }
                }.navigationTitle("Пациенты").navigationBarTitleDisplayMode(.large)
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        FloatingButton(moreButtonAction: {
                            print("clicked")
                        })
                    }.padding([.bottom, .trailing], 30)
                }
            }
            
            
        }
//        .alert(isPresented: $listData.isAlertPresented, content: {
//            Alert(title: Text("Подтверждение"), message: Text("Вы уверены, что хотите удалить пациента?"), primaryButton: .default(Text("Да"), action: {
//                deleteItem()
//            }), secondaryButton: .cancel())
//        })
        .edgesIgnoringSafeArea(.all)
//        .onAppear(perform: {
//            listData.fetchPatients()
//        })
        
        
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

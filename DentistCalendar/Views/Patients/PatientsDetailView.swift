//
//  PatientsDetailView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/12/20.
//

import SwiftUI
import SwiftUIRefresh


struct PatientsDetailView: View {
    @ObservedObject var detailData: PatientDetailViewModel
    @ObservedObject var listData: PatientsListViewModel
    var index: Int
    init(index: Int, listData: PatientsListViewModel) {
        detailData = PatientDetailViewModel(patient: listData.patientsList![index])
        self.listData = listData
        self.index = index
        
    }
    var body: some View {
        ZStack {
            ScrollView {
                
                VStack(alignment: .leading) {
                    Group {
                        Text(detailData.patient.fullname).fontWeight(.bold).font(.title2)
                        Text(detailData.patient.phone).foregroundColor(.gray).font(.body)
                    }
                    HStack(spacing: 10) {
                        NavigationLink(
                            destination: PatientUpdateView(patient: self.listData, index: self.index),
                            label: {
                                Spacer()
                                Text("Изменить").frame(height: 25).foregroundColor(.white).padding([.vertical, .horizontal], 10)
                                Spacer()
                            }).background(Color("Blue")).cornerRadius(40)
                        Link(destination: URL(string: "tel:\(detailData.patient.phone)")!) {
                            Image(systemName: "phone.fill").frame(width: 50, height: 45).padding([.vertical, .horizontal], 10).foregroundColor(.white)
                        }.background(Color("Green")).frame(width: 50, height: 45).clipShape(Circle())
                    }
                }
                .padding(16)
                .background(Color.white)
                VStack(spacing: 10) {
                    
                    if detailData.appointments != nil {
                        ForEach(detailData.appointments!) { app in
                            PatientDetailCard(toothNumber: app.toothNumber, diagnosis: app.diagnosis, date: app.date, time: app.timeStart, price: app.price, moreButtonAction: {
                                detailData.isSheetPresented.toggle()
                            } )
                            .cornerRadius(20)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            
                            //                        PatientDetailCard(toothNumber: app.fullname, diagnosis: app.diagnosis, date: app.date, time: app.timeStart, price: app.price)
                        }
                        
                    }
                    else if detailData.isLoading == true{
                        ProgressView()
                    }
                    else if detailData.appointments == nil && detailData.isLoading == false{
                        Text("Записей нет").foregroundColor(.gray)
                    }
                    else {
                        Text("Произошла ошибка").foregroundColor(.gray)
                    }
                }
                .padding(.top, 5)
                .padding(.bottom, 20)
                .navigationTitle("Карта пациента")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: detailData.fetchAppointments)
                .alert(isPresented: $detailData.isAlertPresented, content: {
                    Alert(title: Text("Ошибка"), message: Text(detailData.error), dismissButton: .cancel())
                })
                .actionSheet(isPresented: $detailData.isSheetPresented) {
                    ActionSheet(title: Text("Выберите опции"), buttons: [
                        .default(Text("Изменить")),
                        .destructive((Text("Удалить"))),
                        .cancel(Text("Отменить"))
                    ])
                }
            }
            
            
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
        .background(Color(hex: "#F8F8F8"))
        
        
    }
}
//
//struct PatientsDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientsDetailView(patientInput: PatientData(id: "123", fullname: "Кикимов Даниил", phone: "91231023", user: "123123"))
//    }
//}

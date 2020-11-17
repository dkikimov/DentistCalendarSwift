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
        self.detailData = PatientDetailViewModel(patient: listData.patientsList[index])
        self.index = index
        self.listData = listData
    }
    var body: some View {
        ZStack {
            ScrollView {
                
                VStack(alignment: .leading) {
                    Group {
                        Text(listData.patientsList[index].fullname).fontWeight(.bold).font(.title2)
                        Text(listData.patientsList[index].phone).foregroundColor(.gray).font(.body)
                    }
                    HStack(spacing: 10) {
                        NavigationLink(
                            destination: PatientUpdateView(patient: listData.patientsList[index], index: index, listData: listData),
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
                    if detailData.appointments.count > 0 {
                        ForEach(detailData.appointments) { app in
                            PatientDetailCard(appointment: app, moreButtonAction: {
                                detailData.isSheetPresented.toggle()
                            } )
                            .padding(.horizontal, 15)
                            
                        }
                        
                        
                    }
                    else if detailData.isLoading == true{
                        ProgressView()
                    }
                    else if detailData.appointments.count == 0 && detailData.isLoading == false{
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
                //                .onAppear(perform: detailData.fetchAppointments)
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
                .sheet(isPresented: $detailData.isModalPresented, content: {
                    AppointmentCreateView(patientID: detailData.patient.id, isAppointmentPresented: $detailData.isModalPresented)
                        .presentation(isModal: true)
                        .environmentObject(detailData)
                    
                })
                
            }
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    FloatingButton {
                        self.detailData.isModalPresented.toggle()
                    }
                }.padding([.bottom, .trailing], 15)
            }
            
            //        .onAppear(perform: {
            //            print("PATIENT", patient.appointments!)
            //            if patient.appointments != nil {
            //                self.appointments = Array(patient.appointments!)
            //            }
            //
            //        })
        }
        .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        
        .background(Color(hex: "#F8F8F8"))
        
        
    }
}

//
//struct PatientsDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientsDetailView(patientInput: PatientData(id: "123", fullname: "Кикимов Даниил", phone: "91231023", user: "123123"))
//    }
//}

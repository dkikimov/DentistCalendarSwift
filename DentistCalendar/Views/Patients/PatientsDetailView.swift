//
//  PatientsDetailView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/12/20.
//

import SwiftUI
import SwiftUIRefresh


struct PatientsDetailView: View {
    var patient: PatientData
    @StateObject var detailData = PatientDetailViewModel()
    init(patientInput: PatientData) {
        patient = patientInput
    }
    var body: some View {
        ZStack {
            ScrollView {
                
                    VStack(alignment: .leading) {
                        Group {
                            Text(patient.fullname).fontWeight(.bold).font(.title2)
                            Text(patient.phone).foregroundColor(.gray).font(.body)
                        }
                        HStack(spacing: 10) {
                            Button(action: {
                                
                            }, label: {
                                Spacer()
                                Text("Изменить").frame(height: 25).foregroundColor(.white).padding([.vertical, .horizontal], 10)
                                Spacer()
                                
                            }).background(Color("Blue")).cornerRadius(40)
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "phone.fill").frame(width: 50, height: 45).padding([.vertical, .horizontal], 10).foregroundColor(.white)
                            }).background(Color("Green")).frame(width: 50, height: 45).clipShape(Circle())
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
                          
                           else if  detailData.appointments?.count == 0 && detailData.isLoading == false{
                            Text("Записей нет")
                        }
                        else {
                            ProgressView()
                        }
                    }
                    .padding(.top, 5)
                    .navigationTitle("Карта пациента")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear(perform: {
                        detailData.fetchAppointments(patient: patient.id)
                    })
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

struct PatientsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PatientsDetailView(patientInput: PatientData(id: "123", fullname: "Кикимов Даниил", phone: "91231023", user: "123123"))
    }
}

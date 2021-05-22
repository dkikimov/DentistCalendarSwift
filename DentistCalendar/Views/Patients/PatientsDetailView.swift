//
//  PatientsDetailView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/12/20.
//

import SwiftUI
import GoogleMobileAds

struct PatientsDetailView: View {
    @ObservedObject var detailData: PatientDetailViewModel
    @ObservedObject var listData: PatientsListViewModel
    var index: Int
    init(index: Int, listData: PatientsListViewModel, item: Patient) {
        self.detailData = PatientDetailViewModel(patient: item)
        self.index = index
        self.listData = listData
    }
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text(detailData.patient.fullname).fontWeight(.bold).font(.title2)
                        Text(detailData.patient.phone!).foregroundColor(.gray).font(.body)
                    }
                    HStack(spacing: 10) {
                        NavigationLink(
                            destination: PatientUpdateView(patient: detailData.patient, index: index, listData: listData),
                            label: {
                                Spacer()
                                Text("Изменить").frame(height: 25).foregroundColor(.white).padding([.vertical, .horizontal], 10)
                                Spacer()
                            }).background(Color("Blue2")).cornerRadius(40)
                        //                        Link(destination: URL(string: "tel:\(String(describing: detailData.patient.phone?.replacingOccurrences(of: " ", with: "")))")!) {
                        //                            Image(systemName: "phone.fill").frame(width: 50, height: 45).padding([.vertical, .horizontal], 10).foregroundColor(.white)
                        //                        }
                        //                        .background(Color("Green")).frame(width: 50, height: 45).clipShape(Circle())
                        //                        .disabled(detailData.patient.phone?.isEmpty ?? true)
                        Button(action: {
                            let phone = "tel://"
                            let phoneNumberformatted = phone + detailData.patient.phone!
                            guard let url = URL(string: phoneNumberformatted) else { return }
                            UIApplication.shared.open(url)
                        }) {
                            Image(systemName: "phone.fill").frame(width: 50, height: 45).padding([.vertical, .horizontal], 10).foregroundColor(.white)
                        }
                        .background(
                            detailData.patient.phone!.isEmpty ? Color.gray : Color("Green")).frame(width: 50, height: 45).clipShape(Circle()
                        )
                        .disabled(detailData.patient.phone?.isEmpty ?? true)
                    }
                }
                .padding(16)
                .background(Color("White1"))
                VStack(spacing: 10) {
                    if detailData.appointments.count > 0 {
                        ForEach(detailData.appointments) { app in
                            PatientDetailCard(appointment: app, detailButtonAction: {
                                detailData.selectedAppointment = app
                                detailData.viewType = .detailView
                                detailData.isModalPresented.toggle()
                            }, moreButtonAction: {
                                detailData.selectedAppointment = app
                                detailData.isSheetPresented.toggle()
                            })
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
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
                        .default(Text("Изменить")) {
                            detailData.viewType = .edit
                            detailData.isModalPresented = true
                            print("SET")
                        },
                        .destructive((Text("Удалить"))) {
                            detailData.deleteAppointment()
                        },
                        .cancel()
                    ])
                }
                .sheet(isPresented: $detailData.isModalPresented, content: {
                    if detailData.viewType == .detailView {
                        AppointmentCalendarView(appointment: detailData.selectedAppointment!, false)
                    } else {
                        AppointmentCreateView(patient: detailData.patient, isAppointmentPresented: $detailData.isModalPresented, viewType: detailData.viewType, appointment: detailData.selectedAppointment)
                            .presentation(isModal: true)
                            .environmentObject(detailData)
                            .allowAutoDismiss(false)
                    }
                    
                    
                })
                
            }
            
            
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    FloatingButton {
                        self.detailData.selectedAppointment = nil
                        self.detailData.viewType = .create
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
        .background(Color("Gray2"))
    }
    //        .onAppear(perform: self.listData.interstital.showAd)
    
    
    
}


//
//struct PatientsDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientsDetailView(patientInput: PatientData(id: "123", fullname: "Кикимов Даниил", phone: "91231023", user: "123123"))
//    }
//}

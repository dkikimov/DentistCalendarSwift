//
//  PatientsDetailView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/12/20.
//

import SwiftUI
import GoogleMobileAds
import PhoneNumberKit
struct PatientsDetailView: View {
    @StateObject var detailData: PatientDetailViewModel
    @StateObject var listData: PatientsListViewModel
    init(listData: PatientsListViewModel, item: Patient) {
        _detailData = StateObject(wrappedValue: PatientDetailViewModel(patient: item))
        _listData = StateObject(wrappedValue: listData)
    }
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text(detailData.patient.fullname).fontWeight(.bold).font(.title2)
                        if detailData.patient.phone != nil {
                            Text(formatPhone(detailData.patient.phone ?? "") ?? "")
                                .foregroundColor(.gray)
                                .font(.body)
                        }
                    }
                    HStack(spacing: 10) {
                        NavigationLink(
                            destination: PatientUpdateView(patient: detailData.patient, listData: listData),
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
                            let phoneNumberformatted = phone + (detailData.patient.phone ?? "")
                            guard let url = URL(string: phoneNumberformatted) else { return }
                            UIApplication.shared.open(url)
                        }) {
                            Image(systemName: "phone.fill").frame(width: 50, height: 45).padding([.vertical, .horizontal], 10).foregroundColor(.white)
                        }
                        .background(
                            detailData.patient.phone == nil ? Color.gray : Color("Green")).frame(width: 50, height: 45).clipShape(Circle()
                            )
                        .disabled(detailData.patient.phone?.isEmpty ?? true)
                    }
                }
                .padding(16)
                .background(Color("White1"))
                VStack(spacing: 10) {
                    if detailData.appointments.count > 0 {
                        Print(detailData.appointments)
                        ForEach(Array(zip(detailData.appointments.indices, detailData.appointments)), id: \.0) { index, item in
                            PatientDetailCard(appointment: item,
//                                                Binding(
//                                get: {
//                                    if detailData.appointments[index] != nil {
//                                        detailData.appointments[index]
//                                    } else {
//                                        Appointment(id: "1", title: "", patientID: "", owner: "", toothNumber: "", diagnosis: "", price: 0, dateStart: "0", dateEnd: "0", payments: nil)
//                                    }
//
//
//                                },
//                                set: {
//                                    detailData.appointments[index] = $0
//                                }),
                                              detailViewModel: detailData, index: index, detailButtonAction: {
                                detailData.selectedAppointment = detailData.appointments[index]
                                detailData.viewType = .detailView
                                detailData.isModalPresented.toggle()
                            }, moreButtonAction: {
                                detailData.selectedAppointment = detailData.appointments[index]
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
        }
        .onAppear(perform: {
            showInterstitial(placement: "PatientDetailView")
        })
    
        .navigationTitle("Карта пациента")
        .navigationBarTitleDisplayMode(.inline)
            //        .onAppear(perform: {
            //            print("PATIENT", patient.appointments!)
            //            if patient.appointments != nil {
            //                self.appointments = Array(patient.appointments!)
            //            }
            //
            //        })
            
        
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

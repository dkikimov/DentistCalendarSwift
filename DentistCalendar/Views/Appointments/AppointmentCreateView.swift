//
//  AppointmentCreateView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/12/20.
//

import SwiftUI
import Combine
import PhoneNumberKit
import ApphudSDK
import Appodeal
import FirebaseAnalytics

func stringFromDate(date: Date, formatString: String = "d MMMM YYYY HH:mm") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = formatString
    let strDate = dateFormatter.string(from: date)
    return strDate  
    
}
enum ActiveAlert {
    case error
    case internet
}
struct AppointmentCreateView: View {
    @EnvironmentObject var patientDetailData: PatientDetailViewModel
    @Binding var isModalPresented: Bool
    var appointmentCalendar: Binding<Appointment>?
    var persistenceContainer: PersistenceController
    var group: DispatchGroup?
    @State var isBillingAlertPresented = false
    @State var text = ""
    @State var isRewardedPresented = false
    @State var wasRewardedVideoChecked = false
    @State var alertType: ActiveAlert = .error
    @State var isFullScreenPresented = false
    @State var isDatePickerPresented = false
    @State var datePickerDate = Date()
    @StateObject var data: AppointmentCreateViewModel
    @StateObject var internetConnectionManager = InternetConnectionManager()
    
    @Environment(\.presentationMode) var presentationMode
    init(patient: Patient?, isAppointmentPresented: Binding<Bool>, viewType: AppointmentType, appointment: Appointment?, appointmentCalendar: Binding<Appointment>? = nil) {
        _isModalPresented = isAppointmentPresented
        persistenceContainer = PersistenceController.shared
        _data = StateObject(wrappedValue: AppointmentCreateViewModel(patient: patient, viewType: viewType, appointment: appointment, dateStart: nil, dateEnd: nil, group: nil))
        
        self.appointmentCalendar = appointmentCalendar
        
    }
    
    init(isAppointmentPresented: Binding<Bool>, viewType: AppointmentType, dateStart: Date?, dateEnd: Date?, group: DispatchGroup) {
        _isModalPresented = isAppointmentPresented
        persistenceContainer = PersistenceController.shared
        _data = StateObject(wrappedValue: AppointmentCreateViewModel(patient: nil, viewType: viewType, appointment: nil, dateStart: dateStart, dateEnd: dateEnd, group: group))
        self.group = group
        
    }
    var body: some View {
        NavigationView {
            ZStack {

                if isBillingAlertPresented {
                    AlertControlView(fields: [
                        .init(text: $text, placeholder: "Сумма", keyboardType: .decimalPad, autoCapitalizationType: .none)
                    ], showAlert: $isBillingAlertPresented, action: {
                        DispatchQueue.main.async {
                            addPayment()
                        }
                    }, title: "Платеж", message: "Введите данные платежа")
                }
                VStack {

                    if data.segmentedMode == .withPatient {
                        ListContent()
                    } else if data.segmentedMode == .nonPatient {
                        ListContent()
                    }
                }
                .environmentObject(data)
                .listStyle(GroupedListStyle())
                .navigationBarTitle(data.viewType == .create || data.viewType == .createWithPatient ? "Создание записи" : "Изменение записи", displayMode: .inline)
                
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                                if data.viewType == .createWithPatient {
                                    data.cancellable?.cancel()
                                        DispatchQueue.main.async {
                                            group?.leave()
                                        }
                            }
                            
                        }, label: {
                            Text("Отменить")
                                .bold()
                                .foregroundColor(.white)
                        })
                    }
                }
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .slideOverCard(isPresented: $data.isFirstDatePresented) {
            VStack {
                Text("Начало приема")
                    .bold()
                    .font(.title)
                
                DatePicker("", selection: $data.dateStart, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
            }
        }
        .slideOverCard(isPresented: $data.isSecondDatePresented) {
            VStack {
                Text("Конец приема")
                    .bold()
                    .font(.title)
                DatePicker("", selection: $data.dateEnd, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
            }
        }
                .onDisappear(perform: {
                    if data.didSave {
                        showRewardedVideo {}
                        Analytics.logEvent("appointment_created", parameters: [
                            "isUpdated": (data.viewType == .edit || data.viewType == .editCalendar)
                        ])
                    }
                })
        
        .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
    }
    private func showRewardedVideo(_ completion: @escaping () -> ()) {
        Dentor.showRewardedVideo(placement: "AppointmentCreateView") { res in
            DispatchQueue.main.async {
                completion()
            }
            if !res {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20)) {
                    showRewardedVideo {}
                }
            }
        }
    }
    func addPayment() {
        let formattedText = Decimal(string: text)?.stringValue
        if let formattedText = formattedText {
            guard !formattedText.isEmpty else {
                return
            }
            guard formattedText.count <= priceMaxLength else {
                data.error = "Сумма платежа слишком большая"
                alertType = .error
                data.isAlertPresented = true
                return
            }
            let newPayment = PaymentModel(cost: formattedText, date: String(Date().timeIntervalSince1970))
            data.sumPayment += text.decimalValue
            withAnimation {
                data.paymentsArray.insert(newPayment, at: 0)
            }
            self.text = ""
        }
    }
    
    func ListContent() -> some View {
        List {
            if data.viewType == .createWithPatient  {
                PickerCalendarSection(segmentedMode: $data.segmentedMode)
            }
            if data.viewType == .createWithPatient && data.segmentedMode == .withPatient {
                PatientCreateSection()
                
            } else if data.segmentedMode == .nonPatient{
                TextField("Название", text: $data.title)
            }
            
            DatePickersSection(isDatePickerPresented: $isDatePickerPresented, datePickerDate: $datePickerDate)
            
            if data.segmentedMode == .withPatient {
                ServicesSection()
                BillingSection(isAlertPresented: $isBillingAlertPresented)
            }
            Section(footer: Group {
                    Label("Дата окончания записи не может быть раньше даты начала.".localized, icon: {
                        Image(systemName: "info.circle")
                    })
                    .foregroundColor(.red)
                    .hidden(data.dateEnd > data.dateStart)
                    .animation(.easeInOut)
                    .transition(.opacity)
            }) {
                Button(action: {
                        if internetConnectionManager.isInternetEnabled() {
                            saveAppointment()
                        } else {
                            alertType = .internet
                            data.isAlertPresented = true
                        }
                }, label: {
                    Text("Сохранить")
                })
                .disabled(data.dateEnd <= data.dateStart)
            }
            
            }
        
        .onAppear(perform: {
            if !Appodeal.isReadyForShow(with: .rewardedVideo) && !Apphud.hasActiveSubscription(){
                Appodeal.cacheAd(.rewardedVideo)
                checkInternetConnection()
            }
        })
        .onChange(of: internetConnectionManager.isNotInternetConnected) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
                if newValue == true {
                    alertType = .internet
                    data.isAlertPresented = true
                } else {
                    alertType = .error
                    data.isAlertPresented = false
                }
            }
        }
        .alert(isPresented: $data.isAlertPresented, content: {
            switch alertType {
            case .error:
                return Alert(title: Text("Ошибка"), message: Text(data.error.localized), dismissButton: .cancel())
            case .internet:
                return Alert(title: Text("Подключите устройство к интернету"), message: Text("Добавление и изменение записей без доступа к интернету доступно только для пользователей Dentor Premium"), dismissButton: .default(Text("Перейти к покупке"), action: {
                    isFullScreenPresented = true
                }))
            }
        })
        .sheet(isPresented: $isFullScreenPresented, onDismiss: {
            checkInternetConnection()
        }, content: {
            BuySubscriptionView()
        })
        .sheet(isPresented: $data.isDiagnosisCreatePresented, content: {
            DiagnosisCreateView(data: data)
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)

        })
    }
    
    func saveAppointment() {
        guard data.selectedDiagnosisList.count < servicesMaxCount else {
            self.data.error = "Можно создавать до \(servicesMaxCount) услуг"
            self.data.isAlertPresented = true
            return
        }
        guard data.title.count <= titleMaxLength else {
            if data.segmentedMode == .withPatient {
                data.error = "Имя пациента слишком длинное"
            } else {
                data.error = "Название слишком длинное"
            }
            data.isAlertPresented = true
            return
        }
        if data.segmentedMode == .withPatient {
            
            if data.viewType == .createWithPatient {
                guard !data.title.isEmpty else {
                    data.error = "Укажите пациента"
                    data.isAlertPresented = true
                    return
                }
                guard data.toothNumber.count <= toothNumberFieldMaxLength else {
                    data.error = "Значение поля 'Номер зуба' слишком длинное"
                    data.isAlertPresented = true
                    return
                }
                var phoneFormattedNumber: String = ""
                if !data.phoneNumber.isEmpty {
                    do {
                        phoneFormattedNumber = phoneNumberKit.format(try phoneNumberKit.parse(data.phoneNumber, ignoreType: true), toType: .e164)
                    } catch {
                        //                    print("NUMBER", phoneNumber, phoneFormattedNumber)
                        
                        data.error = "Введите корректный номер".localized
                        data.isAlertPresented = true
                        return
                    }
                }
                data.createAppointmentAndPatient(isModalPresented: self.$isModalPresented, phoneNumber: phoneFormattedNumber)
            }
            else if data.viewType == .create {
                data.createAppointment(isModalPresented: self.$isModalPresented, patientDetailData: patientDetailData)
            }
        } else if data.segmentedMode == .nonPatient {
            if data.viewType == .create || data.viewType == .createWithPatient{
                guard !data.title.isEmpty else {
                    data.error = "Укажите название"
                    data.isAlertPresented = true
                    return
                }
                data.createNonPatientAppointment(isModalPresented: self.$isModalPresented)
            }
        }
        if data.viewType == .editCalendar {
            data.updateAppointmentCalendar(isModalPresented: self.$isModalPresented, appointment: self.appointmentCalendar!)
        }
        else if data.viewType == .edit{
            data.updateAppointment(isModalPresented: self.$isModalPresented, patientDetailData: patientDetailData)
        }
    }
    
    private func checkInternetConnection() {
        if internetConnectionManager.isNotInternetConnected {
            alertType = .internet
            data.isAlertPresented = true
        }
        
    }
}

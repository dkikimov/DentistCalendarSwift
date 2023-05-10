//
//  CalendarKitViewController.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/18/20.
//

import UIKit
import CalendarKit
import SwiftUI
import Amplify
import Combine
import Lobster
import FirebaseRemoteConfig
import ApphudSDK

let group = DispatchGroup()

public struct newModel {
    static var appointment: Appointment? = nil
}


private func trimDate(_ date: Date) -> (String, String) {
    return (
        String(Date(year: date.year, month: date.month, day: date.day, hour: 0, minute: 0, second: 0).timeIntervalSince1970),
        String(Date(year: date.year, month: date.month, day: date.day + 1, hour: 0, minute: 0, second: 0).timeIntervalSince1970)
    )
}
private func getAppStartDate(_ date: String) -> Date {
    let date = Date(timeIntervalSince1970: TimeInterval(date)!)
    return Date(year: date.year, month: date.month, day: date.day, hour: 0, minute: 0, second: 0)
}
private func fromTimestampToDate(date: String) -> Date{
    return Date(timeIntervalSince1970: TimeInterval(date)!)
}
enum SheetType: String, Identifiable {
    var id: String {
        rawValue
    }
    case calendarView
    case createView
}
class CustomDayViewController: ObservableObject {
    let id = UUID()
    var customDayView: DayView?
    var selectedAppointment: Appointment = Appointment(title: "Загрузка...", dateStart: "0", dateEnd: "0")
    @Published var selectedDate: Date =  Date()
    @Published var isDatePickerPresented = false
    @Published var isSheetPresented = false
    @Published var selectedSheetType: SheetType = .calendarView
    var dateStart: Date = Date()
    var dateEnd: Date = Date()
}
class CustomCalendarExampleController: DayViewController {
    @AppStorage("createdAppointmentsCount") var createdAppointmentsCount = 0
    @State var addedAppointments = [String]()
    @State var deletedAppointments = [String]()
    var appointmentObservationToken: AnyCancellable?
    var patientObservationToken: AnyCancellable?
    var dateStart: Binding<Date>
    var selectedAppointment: Binding<Appointment>
    var dateEnd: Binding<Date>
    var defData = [Appointment]()
    var generatedEvents = [EventDescriptor]()
    var viewData: CustomDayViewController
    var alreadyGeneratedSet = Set<Date>()
    var style = CalendarStyle()
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]
    func observeAppointments() {
        appointmentObservationToken = Amplify.DataStore.publisher(for: Appointment.self)
            .receive(on: DispatchQueue.main)
            .sink { (_) in } receiveValue: { (changes) in
                guard let app = try? changes.decodeModel(as: Appointment.self) else {return}
                
                switch changes.mutationType {
                case ("create"):
                    if !self.generatedEvents.contains(where: { (event) -> Bool in
                        event.id == app.id
                    }) && self.alreadyGeneratedSet.contains(getAppStartDate(app.dateStart)) {
                        DispatchQueue.main.async {
                            let event = self.generateEvent(appointment: app)
                            self.endEventEditing()
                            self.generatedEvents.append(event)
                            self.endEventEditing()
                            self.reloadData()
                        }
                    }
                    if !self.addedAppointments.contains(app.id) {
                        self.createdAppointmentsCount += 1
                        self.addedAppointments.append(app.id)
                    }
                    break
                case "update":
                    if let index = self.generatedEvents.firstIndex(where: {$0.id == app.id}) {
                        DispatchQueue.main.async {
                            let event = self.generateEvent(appointment: app)
                            self.generatedEvents[index] = event
                            if app.id == self.selectedAppointment.wrappedValue.id {
                                self.selectedAppointment.wrappedValue = app
                            }
                            self.reloadData()
                        }
                    }
                case "delete":
                    if let index = self.generatedEvents.firstIndex(where: {$0.id == app.id}) {
                        DispatchQueue.main.async {
                            self.generatedEvents.remove(at: index)
                            self.reloadData()
                        }
                    }
                    if !self.deletedAppointments.contains(app.id) {
                        self.createdAppointmentsCount -= 1
                        self.deletedAppointments.append(app.id)
                    }
                    break
                default:
                    break
                }
            }
        
    }
    func observePatients() {
        patientObservationToken = Amplify.DataStore.publisher(for: Patient.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { changes in
                guard let patient = try? changes.decodeModel(as: Patient.self) else {return}
                
                switch changes.mutationType {
                case ("create"):
                    break
                case "update":
                    if let index = self.generatedEvents.firstIndex(where: {$0.patientID == patient.id}) {
                        DispatchQueue.main.async {
                            let event = self.generatedEvents[index]
                            event.text = patient.fullname
                            self.generatedEvents[index] = event
                            self.reloadData()
                        }
                    }
                case "delete":
                    break
                default:
                    break
                }
            })
    }
    
    func generateEvent(appointment: Appointment) -> Event {
        let newEvent = Event(id: appointment.id, patientID: appointment.patientID)
        newEvent.startDate = fromTimestampToDate(date: appointment.dateStart)
        newEvent.endDate = fromTimestampToDate(date: appointment.dateEnd)
        newEvent.lineBreakMode = .byTruncatingTail
        if appointment.patientID != nil {
            let info = [getPatientName(patientID: appointment.patientID!), convertDiagnosisString(str: appointment.diagnosis ?? "", returnEmpty: false)]
            newEvent.text = info.reduce("", {$0 + $1 + "\n"})
            if traitCollection.userInterfaceStyle == .dark {
                newEvent.textColor = .white
                newEvent.backgroundColor = newEvent.color.withAlphaComponent(0.6)
            }
            
            
        } else {
            newEvent.text = appointment.title ?? ""
            newEvent.backgroundColor = UIColor(named: "Red2")!
            newEvent.color = UIColor(named: "Red2")!
            newEvent.textColor = UIColor(named: "Red2Text")!
        }
        return newEvent
    }
    private lazy var rangeFormatter: DateIntervalFormatter = {
        let fmt = DateIntervalFormatter()
        fmt.dateStyle = .none
        fmt.timeStyle = .short
        
        return fmt
    }()
    
    override func loadView() {
        dayView = DayView(calendar: calendar)
        style.header.daySelector.todayActiveBackgroundColor = UIColor(Color(hex: "#2A86FF"))
        dayView.updateStyle(style)
        view = dayView
        viewData.customDayView = dayView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayView.autoScrollToFirstEvent = false
        
        reloadData()
        observeAppointments()
        observePatients()
    }
    init(dateStart: Binding<Date>, dateEnd: Binding<Date>, selectedAppointment: Binding<Appointment>, viewData: CustomDayViewController)
    {
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.selectedAppointment = selectedAppointment
        self.viewData = viewData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    // MARK: EventDataSource
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let formattedDate = Date(year: date.year, month: date.month, day: date.day, hour: 0, minute: 0, second: 0)
        if !alreadyGeneratedSet.contains(formattedDate) {
            //            print("generate events", date)
            alreadyGeneratedSet.insert(formattedDate)
            self.generatedEvents.append(contentsOf: self.generateEventsForDate(date))
            
        }
        return generatedEvents
    }
    private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
        let date = trimDate(date)
        var fetchedData = [Appointment]()
        Amplify.DataStore.query(Appointment.self, where:
                                    Appointment.keys.dateStart >= date.0 && Appointment.keys.dateEnd <= date.1) { res in
            switch res {
            case .success(let appointments):
                fetchedData = appointments
            case .failure(let error):
                return
            }
        }
        for appointment in fetchedData {
            events.append(generateEvent(appointment: appointment))
        }
        return events
    }
    private var createdEvent: EventDescriptor?
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        Amplify.DataStore.query(Appointment.self, byId: descriptor.id) { res in
            switch res {
            case .success(let appointment):
                if appointment != nil {
                    self.viewData.selectedSheetType = .calendarView
                    self.selectedAppointment.wrappedValue = appointment!
                    self.viewData.isSheetPresented = true
                }
            case .failure(let error):
                print("ERROR CALENDAR", error.errorDescription)
            }
        }
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        endEventEditing()
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        beginEditing(event: descriptor, animated: true)
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        
        print("Did Tap at date: \(date)")
    }
    
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
        print("DayView did begin dragging")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        viewData.selectedDate = dayView.state!.selectedDate
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        endEventEditing()
        let event = generateEventNearDate(date)
        create(event: event, animated: true)
        createdEvent = event
    }
    
    private func generateEventNearDate(_ date: Date) -> EventDescriptor {
        let duration = Int(arc4random_uniform(0) + 60)
        let startDate = Calendar.current.date(byAdding: .minute, value: -Int(CGFloat(duration) / 2), to: date)!
        let event = Event(id: "", patientID: nil)
        
        event.startDate = startDate
        event.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: startDate)!
        var info = ["Имя пациента".localized,"Диагноз".localized]
        
        info.append(rangeFormatter.string(from: event.startDate, to: event.endDate))
        event.text = info.reduce("", {$0 + $1 + "\n"})
        event.lineBreakMode = .byTruncatingTail
        event.editedEvent = event
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                event.textColor = .white
                event.backgroundColor = event.color.withAlphaComponent(0.6)
            }
        }
        return event
        
    }
    
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        if event.id.isEmpty {
            viewData.dateStart = event.startDate
            viewData.dateEnd = event.endDate
            self.viewData.selectedSheetType = .createView
            
            guard self.viewData.isSheetPresented == false && event.startDate != event.endDate else {return}
            self.viewData.isSheetPresented = true
            group.enter()
            //            print("GROUP ENTER")
            group.notify(queue: .main) {
                if newModel.appointment == nil{
                    self.endEventEditing()
                    self.viewData.isSheetPresented = false
                    return
                }
                
                self.viewData.isSheetPresented = false
                self.createdEvent = nil
                newModel.appointment = nil
                self.endEventEditing()
                self.reloadData()
            }
            
        } else {
            Amplify.DataStore.query(Appointment.self, byId: event.id) {  res in
                switch res {
                case .success(var app):
                    guard app != nil else {return}
                    let startDate = String(event.startDate.timeIntervalSince1970)
                    let endDate = String(event.endDate.timeIntervalSince1970)
                    if app!.dateStart != startDate || app!.dateEnd != endDate{
                        app!.dateStart = startDate
                        app!.dateEnd = endDate
                        Amplify.DataStore.save(app!) { result in
                            switch result {
                            case .success:
                                break
                            case .failure(let error):
                                return
                            }
                            
                        }
                    }
                    if let _ = event.editedEvent {
                        event.commitEditing()
                    }
                    if let createdEvent = createdEvent {
                        self.createdEvent = nil
                        endEventEditing()
                    }
                    reloadData()
                case .failure(let error):
                    return
                }
            }
            
            
            
        }
        
    }
}

struct CustomController: UIViewControllerRepresentable {
    @Binding var dateStart: Date
    @Binding var dateEnd: Date
    @Binding var generatedEvents: [EventDescriptor]
    @Binding var selectedAppointment: Appointment
    var viewData: CustomDayViewController
    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let dayViewController = CustomCalendarExampleController( dateStart: $dateStart, dateEnd: $dateEnd, selectedAppointment: $selectedAppointment, viewData: viewData)
        return dayViewController
    }
}


struct CalendarKitView: View {
    @AppStorage("createdAppointmentsCount") var createdAppointmentsCount = 0
    @State var dateStart = Date()
    @State var dateEnd = Date()
    @State var generatedEvents = [EventDescriptor]()
    //    @State var selectedDate: Date = Date()
    @StateObject var data = CustomDayViewController()
    @State var isDatePickerPresented = false
    @State var isShown = false
    @State var isTodayShown = false
    @State var isSettingsPresented = false
    
    @State var maxAppointments: Int = -1
    @State private var cancellables: Set<AnyCancellable> = []
    
    @EnvironmentObject var modalManager: ModalManager
    
    @State var remoteConfig = RemoteConfig.remoteConfig()
    var body: some View {
        NavigationView {
            ZStack {
                CustomController(dateStart: $dateStart, dateEnd: $dateEnd, generatedEvents: $generatedEvents,selectedAppointment: $data.selectedAppointment, viewData: data)
                if isTodayShown {
                    VStack {
                        Spacer()
                        HStack{
                            Button(action: {
                                moveDate(Date())
                            }, label: {
                                Text("Сегодня")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(10)
                                
                            })
                            .background(Color("Blue"))
                            .clipShape(Rectangle())
                            .cornerRadius(30)
                            Spacer()
                        }.padding([.bottom, .leading], 15)
                        
                    }
                    .offset(y: isShown ? 0 : 100)
                    .animation(.spring())
                    .onAppear(perform: {
                        isShown = true
                    })
                }
            }
            .onChange(of: data.selectedDate, perform: { (newDate) in
                print("NEWDATE", data.selectedDate)
                if newDate.isToday {
                    isShown = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        isTodayShown = false
                    })
                } else {
                    isTodayShown = true
                }
            })
            .onChange(of: modalManager.selectedDate, perform: { (newDate) in
                data.isSheetPresented = false
                isDatePickerPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    if newDate != data.selectedDate {
                        data.customDayView?.move(to: newDate)
                    }
                })
            })
            .navigationBarTitle("Календарь", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: ProfileSettingsView(), label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    getDatePickerButton()
                        .foregroundColor(.white)
                    
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $data.isSheetPresented, onDismiss: {
            setNavigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        }, content: {
            switch data.selectedSheetType {
            case .calendarView:
                AppointmentCalendarView(appointment: data.selectedAppointment)
                
            case .createView:
                AppointmentCreateView(isAppointmentPresented: $data.isSheetPresented, viewType: .createWithPatient, dateStart: data.dateStart, dateEnd: data.dateEnd, group: group)
                    .allowAutoDismiss(false)
            }
            
        })
        .onAppear {
            Lobster.shared.isStaled = true
            
            Lobster.shared[default: ConfigKeys.maxAppointments] = -1
            
            self.maxAppointments = Lobster.shared[ConfigKeys.maxAppointments]
            remoteConfig.fetchAndActivate { status, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if status != .error {
                        if let firebaseMaxAppointments = remoteConfig[ConfigKeys.free_version_max_appointments.rawValue].stringValue {
                            self.maxAppointments = Int(firebaseMaxAppointments) ?? -1
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder func getDatePickerButton() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            Button(action: {
                modalManager.selectedDate = data.selectedDate
                modalManager.isDatePickerPresented.toggle()
            }, label: {
                Image(systemName: "calendar")
                    .font(.title3)
                
            })
        } else {
            Button(action: {
                isDatePickerPresented = true
            }, label: {
                Image(systemName: "calendar")
                    .font(.title3)
                
            })
            .padding()
            .popover(isPresented: $isDatePickerPresented, content: {
                DatePicker("", selection: $modalManager.selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(minWidth:300, minHeight: 300)
            })
        }
    }
    func dateOnly(date: Date, calendar: Calendar) -> Date {
        let yearComponent = calendar.component(.year, from: date)
        let monthComponent = calendar.component(.month, from: date)
        let dayComponent = calendar.component(.day, from: date)
        let zone = calendar.timeZone
        
        let newComponents = DateComponents(timeZone: zone,
                                           year: yearComponent,
                                           month: monthComponent,
                                           day: dayComponent)
        let returnValue = calendar.date(from: newComponents)
        return returnValue!
    }
    
    func moveDate(_ date: Date) {
        let offsetDate = dateOnly(date: date, calendar: data.customDayView!.calendar)
        data.customDayView!.state?.move(to: offsetDate)
    }
}



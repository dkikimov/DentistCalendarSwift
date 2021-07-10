//
//  ExportEvents.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10.02.2021.
//

import SwiftUI
import Amplify
import SwiftUIX
struct ExportEvents: View {
    @State var startDate = Date().addingTimeInterval(-2628000)
    @State var endDate = Date().addingTimeInterval(2628000)
    @State var isExporting: Bool = false
    @State private var document: ExportDocument?
    var body: some View {
        Form {
            Section {
                DatePicker("Выберите начальную дату", selection: $startDate )
                DatePicker("Выберите конечную дату", selection: $endDate)
                
                Button(action: {
                    generateICS()
                }, label: {
                    Text("Экспортировать")
                })
            }
        }
        
        .navigationBarTitle("Экспорт", displayMode: .large)
//        .navigationBarColor(backgroundColor: .white, tintColor: .systemBlue)
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: .ics,
            defaultFilename: "exportedData"
        ) { _ in

//            if case .success = result {
//                print("SUCCESS")
//                setNavigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
//            } else {
//                print("eRROR")
//            }
        }.onChange(of: isExporting, perform: { (newValue) in
            if newValue == false {
                setNavigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
            } else {
                setNavigationBarColor(backgroundColor: .white, tintColor: .systemBlue)

            }
        })
        .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)

    }
    
    
    
    func generateICS() {
        var eventsArray = [ICSEvent]()
        //        let calendar = Calendar(withComponents: [event])
        var fetchedAppointments = [Appointment]()
        Amplify.DataStore.query(Appointment.self, where: Appointment.keys.dateStart >= strFromDate(date: startDate) && Appointment.keys.dateEnd <= strFromDate(date: endDate)) { res in
            switch res {
            case .success(let appointments):
                fetchedAppointments = appointments
            case .failure(let error):
                print("EXPORT EVENTS ERROR", error.errorDescription)
            }
        }
        for app in fetchedAppointments {
            var event = ICSEvent()
            event.summary = app.title
            event.dtstart = Date(timeIntervalSince1970: TimeInterval(app.dateStart)!)
            event.dtend = Date(timeIntervalSince1970: TimeInterval(app.dateEnd)!)
            
            if app.patientID != nil {
                event.addAttribute(attr: "patientID", String(app.patientID ?? "-1"))
                event.addAttribute(attr: "toothNumber", app.toothNumber ?? "0")
                event.addAttribute(attr: "diagnosis", app.diagnosis ?? "")
                event.addAttribute(attr: "patientData", generatePatientString(patient: findPatientByID(id: app.patientID!)))
            }
            eventsArray.append(event)
            
            //            let timezone = TimeZone.current
            //
            //            let start = DateComponents(from: Date(timeIntervalSince1970: event.dateStart))
            //            //        let start = DateComponents(calendar: Calendar.init(identifier: .gregorian),
            //            //                                   timeZone: timezone,
            //            //                                   year: 2020,
            //            //                                   month: 5,
            //            //                                   day: 9,
            //            //                                   hour: 22,
            //            //                                   minute: 0,
            //            //                                   second: 0)
            //
            //            let end = DateComponents(from: Date(timeIntervalSince1970: event.dateEnd))
            //            let newEvent = VEvent(summary: generateCalendarString(event: event), dtstart: start, dtend: end)
            //            calendar.events.append(newEvent)
        }
        
        //        print("CALENDAR", ICSCalendar(withComponents: eventsArray).toCal())
        self.document = ExportDocument(message: ICSCalendar(withComponents: eventsArray).toCal())
        self.isExporting = true
        //        print("CALENDAR", calendar.icalString())
    }
}
struct ExportEvents_Previews: PreviewProvider {
    static var previews: some View {
        ExportEvents()
    }
}

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
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: .ics,
            defaultFilename: "exportedData"
        ) { res in
            switch res {
            case .success:
                presentSuccessAlert(message: "Записи были успешно экспортированы!")
            case .failure(let err):
                presentErrorAlert(message: err.localizedDescription)
            }
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
        var fetchedAppointments = [Appointment]()
        Amplify.DataStore.query(Appointment.self, where: Appointment.keys.dateStart >= strFromDate(date: startDate) && Appointment.keys.dateEnd <= strFromDate(date: endDate)) { res in
            switch res {
            case .success(let appointments):
                fetchedAppointments = appointments
            case .failure(let error):
                break
            }
        }
        for app in fetchedAppointments {
            var event = ICSEvent()
            event.summary = app.title
            
            event.dtstart = Date(timeIntervalSince1970: Double(app.dateStart)!)
            event.dtend = Date(timeIntervalSince1970: Double(app.dateEnd)!)
            
            if app.patientID != nil {
                event.addAttribute(attr: "patientID", String(app.patientID ?? "-1"))
                event.addAttribute(attr: "toothNumber", app.toothNumber ?? "0")
                event.addAttribute(attr: "diagnosis", app.diagnosis ?? "")
                event.addAttribute(attr: "patientData", generatePatientString(patient: findPatientByID(id: app.patientID!)))
            }
            eventsArray.append(event)
        }
        self.document = ExportDocument(message: ICSCalendar(withComponents: eventsArray).toCal())
        self.isExporting = true
    }
}
struct ExportEvents_Previews: PreviewProvider {
    static var previews: some View {
        ExportEvents()
    }
}

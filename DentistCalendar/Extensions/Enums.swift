//
//  Enums.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.12.2020.
//


public enum CurrentSegmentedState {
    case withPatient
    case nonPatient
}

public enum AppointmentType {
    case create
    case createWithPatient
    case edit
    case editCalendar
    case patientDetailView
}

public enum Tabs{
    case tab1, tab2
}

public enum InternetConnectionType {
    case enabled
    case disabled
}

public enum DestinationTypes: CaseIterable, Identifiable {
    case calendar
    case patients
    case settings
    
    public var id: String {return title}
    
    var title: String {
        switch self {
        case .calendar: return "Календарь".localized
        case .patients: return "Пациенты".localized
        case .settings: return "Настройки".localized
        }
    }
    
    var systemImageName: String {
        switch self {
        case .calendar: return "calendar"
        case .patients: return "person.3.fill"
        case .settings: return "gearshape.fill"
        }
    }
}


public enum ConfigKeys: String {
    case free_version_max_appointments
}

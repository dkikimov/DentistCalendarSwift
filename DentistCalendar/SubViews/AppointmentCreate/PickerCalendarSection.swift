//
//  PickerCalendarSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI

struct PickerCalendarSection: View {
    @Binding var segmentedMode: CurrentSegmentedState
    var body: some View {
        Section(header: Text("Тип календаря")) {
            Picker(selection: $segmentedMode, label: Text("Выберите календарь")) {
                Text("Рабочий").tag(CurrentSegmentedState.withPatient)
                Text("Домашний").tag(CurrentSegmentedState.nonPatient)
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}

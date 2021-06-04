//
//  ServiceList.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 22.12.2020.
//

import SwiftUI

struct ServiceList: View {
    var diagnosisList: [[Substring]]
    var body: some View {
        ForEach(diagnosisList, id: \.self) { service in
            HStack {
                Text(String(service[0]) + ": ").bold() +
                Text(Decimal(string: String(service[1]))!.formatted + String(describing: Locale.current.currencySymbol ?? ""))
            }
        }
    }
}

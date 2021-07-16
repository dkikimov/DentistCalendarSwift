//
//  ServiceList.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 22.12.2020.
//

import SwiftUI

struct ServiceList: View {
    var diagnosisList: [Service]
    var body: some View {
        ForEach(diagnosisList, id: \.self) { service in
            HStack {
                (Text(service.title).bold() + Text(" (x" + service.amount + ")").foregroundColor(.gray) + Text(": ").bold() + Text(service.price.currencyFormatted))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineBreakMode(.byWordWrapping)
            }
        }
    }
}

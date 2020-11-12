//
//  Patient+Extensions.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/6/20.
//

import Foundation

extension Patient: Identifiable {}

extension Appointment: Identifiable {}

extension Appointment: Equatable {
    public static func ==(lhs: Appointment, rhs: Appointment) -> Bool {
    lhs.id == rhs.id
    }
}

extension Appointment: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

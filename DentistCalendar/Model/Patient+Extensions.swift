//
//  Patient+Extensions.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/6/20.
//

import Foundation
import EventKit
extension Patient: Identifiable {}
extension Patient: Equatable {
    public static func ==(lhs: Patient, rhs: Patient) -> Bool {
        lhs.id == rhs.id
    }
}
extension Patient: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
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
extension EKEvent: Identifiable {
}

struct Favor {
    var price: String
    var prePayment: String
}

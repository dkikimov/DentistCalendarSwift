//
//  Color.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/25/20.
//


import SwiftUI
extension UIColor {
    static func hexStringToColor(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return .gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//type Patient @model @auth(rules: [{ allow: owner, operations: [create, read, delete, update], ownerField: "owner" }])
// {
//id: ID!
//fullname: String!
//phone: String!
//owner: String
//}
//
//type Appointment @model @auth(rules: [{ allow: owner, operations: [create, read, delete, update], ownerField: "owner" }]) {
//id: ID!
//title: String!
//patientID: ID
//owner: String
//toothNumber: String
//diagnosis: String
//price: Int
//dateStart: String!
//dateEnd: String!,
//payments: [Payment] @connection(keyName: "byAppointment", fields: ["id"])
//}
//type Payment @model @auth(rules: [{ allow: owner, operations: [create, read, delete, update], ownerField: "owner" }])
//@key(name: "byAppointment", fields: ["appointmentID", "cost", "date"])
//{
//id: ID!
//appointmentID: ID!
//cost: String!
//date: String!
//owner: String
//}

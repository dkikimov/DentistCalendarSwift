//
//  ApiHelper.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/1/20.
//

import SwiftUI

struct ServerMessage: Codable {
    let success : Bool
    let data : DataClass
    let message: [Message]?
}


// MARK: - DataClass
struct DataClass: Codable {
    let accessToken, refreshToken, id, email: String
    let fullname, password: String

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
        case id = "_id"
        case email, fullname, password
    }
}
// MARK: - ErrorArray

// MARK: - Message
struct Message: Codable {
    let msg, param, location: String
}

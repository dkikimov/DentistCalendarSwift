//
//  ApiHelper.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/1/20.
//

import SwiftUI

struct ServerMessage: Codable {
    let success : Bool
    let data : ServerMessageData?
    let message: String?
}


// MARK: - DataClass
struct ServerMessageData: Codable {
    let accessToken, refreshToken, id, email: String
    let fullname, password: String

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
        case id = "_id"
        case email, fullname, password
    }
}

struct User: Codable {
    let success : Bool
    let data : UserData
    
}
struct UserData: Codable {
    let id, email, fullname : String
    enum CodingKeys: String, CodingKey {
        case email, fullname
        case id = "_id"
    }
}
struct UpdateTokens: Codable {
    let success: Bool
    let message: String?
    let data: UpdateTokensData?
}

// MARK: - DataClass
struct UpdateTokensData: Codable {
    let accessToken, refreshToken: String
}

struct AvatarColor: Codable {
    let background, color: String
}

struct Patient: Codable {
    let fullname, id, phone: String
}

struct PatientsList: Codable {
    let success: Bool
    let data: [PatientData]?
    let message: String?
}
struct PatientData: Codable, Hashable {
    let id, fullname, phone, user: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullname, phone, user
    }
}
struct PatientDelete: Codable {
    let success: Bool
    let message: String?
}


//
//  Heplful Functions.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 21.01.2021.
//
import Foundation
import Amplify
let emailRegex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
    "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
    "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
    "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
    "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
    "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
    "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*$"
//(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}

func convertDiagnosisString(str: String, _ onlyTitle: Bool = false, returnEmpty: Bool = true) -> String {
    
    let parsedArray = str.split(separator: ";")
    var res = [String]()
    parsedArray.forEach { (a) in
        let b = a.split(separator: ":")
        if b.count >= 2 {
            res.append(String(b[0]))
        }
    }
    if res.count == 0 {
        if returnEmpty {
            return "Пусто".localized
        } else {
            return ""
        }
    }
    return res.joined(separator: ", ")
}

func checkPassword(a: String, b: String) -> (Bool, String?) {
    guard a == b else {
        return (false, "Пароли не совпадают".localized)
    }
    guard a.count >= 8 && b.count >= 8 else {
        return (false, "Минимальная длина пароля 8 символов".localized)
    }
    
    return (true, nil)
    //        return res
}
func checkEmail(_ email: String) -> (Bool, String?) {
    let status = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    guard status else {
        return (status, "Введите корректный адрес электронной почты".localized)
    }
    return (status, nil)
}


func generatePatientString(patient: Patient?) -> String {
    guard patient != nil else {return ""}
    return "\(patient!.fullname) | \(patient!.phone)"
}

func parsePatientString(patient: String) -> Patient? {
    let a = patient.components(separatedBy: " | ")
    if a.count == 2 {
        return Patient(fullname: a[0], phone: a[1])
    }
    return nil
}
//func parseCalendarString(str: String, dateStart: String, dateEnd: String) -> Appointment {
//    let splitedStr = str.split(separator: " | ")
//    var newApp = Appointment(title: str[0], patientID: str[1], toothNumber: str[2], diagnosis: str[3], price: str[4], dateStart: dateStart, dateEnd: dateEnd)
//    return newApp
//}

func findPatientByID(id: String) -> Patient?{
    var result:Patient?
    Amplify.DataStore.query(Patient.self, byId: id) { res in
        switch res {
        case .success(let patient):
            result = patient
        case .failure(_):
            break;
        }
        
    }
    return result
}

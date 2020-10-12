//
//  User.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/1/20.
//

import SwiftUI

class Api {
    //    let mainUrl = "https://boiling-taiga-93711.herokuapp.com"
    let mainUrl = "http://localhost:5000"
    let userDefaults = UserDefaults.standard
    @AppStorage("isLogged") var status = false

    func login(email : String, password : String, compelition: @escaping(ServerMessageData?, String?) -> ()) {
        guard let url = URL(string: "\(mainUrl)/login") else {return}
        var request = URLRequest(url: url)
        let body: [String: String] = ["email": email, "password": password]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, err)  in
            if let err = err {
                print("Error took place \(err)")
                DispatchQueue.main.async {
                    compelition(nil, err.localizedDescription)
                }
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
                if !finalData.success {
                    DispatchQueue.main.async {
                        compelition(nil, finalData.message)
                    }
                    return
                }
                DispatchQueue.main.async {
                    compelition(finalData.data, nil)
                }
            }
            
        }.resume()
    }
    func register(fullname: String, email: String, password: String, compelition: @escaping(ServerMessageData?, String?) -> ()) {
        guard let url = URL(string: "\(mainUrl)/create") else {return}
        var request = URLRequest(url: url)
        let body: [String: String] = ["fullname": fullname, "email": email, "password": password]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, err)  in
            if let err = err {
                print("Error took place \(err)")
                DispatchQueue.main.async {
                    compelition(nil, err.localizedDescription)
                }
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
                if !finalData.success {
                    DispatchQueue.main.async {
                        compelition(nil, finalData.message!)
                    }
                    return
                }
                DispatchQueue.main.async {
                    compelition(finalData.data, nil)
                }
            }
            
        }.resume()
    }
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "fullname")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "id")
        status = false
    }
    func getMe(compelition: @escaping(UserData?, String?) -> ()) {
        
        if !userDefaults.valueExists(forKey: "accessToken") {
            print("NO KEY")
            DispatchQueue.main.async {
                compelition(nil, "empty")
            }
            status = false
            return
        }
        
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        guard let url = URL(string: "\(mainUrl)/getMe") else {return}
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {
            data, response, err in
            print("psss")
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 401 {
                print("401 error")
                DispatchQueue.main.async {
                    compelition(nil, "Unauthorized")
                }
                return
            }
            if let err = err {
                print("Error took place \(err)")
                DispatchQueue.main.async {
                    compelition(nil, err.localizedDescription)
                }
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    compelition(finalData.data, nil)
                }
            }
        }.resume()
    }
    func updateTokens(compelition: @escaping(UpdateTokensData?, String?) -> ()) {
        if !userDefaults.valueExists(forKey: "refreshToken") {
            print("NO KEY")
            DispatchQueue.main.async {
                compelition(nil, "empty")
            }
            status = false
            return
        }
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        guard let url = URL(string: "\(mainUrl)/refresh-tokens") else {return}
        var request = URLRequest(url: url)
        let body: [String: String] = ["refreshToken": refreshToken!]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {
            data, response, err in
            print("In UPDATETOKENS FUNCTUIN")
            if let err = err {
                print("Error took place \(err)")
                DispatchQueue.main.async {
                    compelition(nil, err.localizedDescription)
                }
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(UpdateTokens.self, from: data)
                UserDefaults.standard.setValue(finalData.data?.accessToken, forKey: "accessToken")
                UserDefaults.standard.setValue(finalData.data?.refreshToken, forKey: "refreshToken")
                DispatchQueue.main.async {
                    compelition(finalData.data, nil)
                }
            }
        }.resume()
    }
    func updateFullname(fullname: String, compelition: @escaping(Bool, String?) -> ()) {
        let accessToken = getToken()
        if accessToken == nil {
            DispatchQueue.main.async {
                compelition(false, "empty")
            }
            status = false
            return
        }
        guard let url = URL(string: "\(mainUrl)/updateFullname") else {return}
        var request = URLRequest(url: url)
        let body: [String: String] = ["fullname": fullname]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) {
            data, response, err in
            if let err = err {
                print("Error took place \(err)")
                DispatchQueue.main.async {
                    compelition(false, err.localizedDescription)
                }
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
                if finalData.success {
                    UserDefaults.standard.set(fullname, forKey: "fullname")
                    DispatchQueue.main.async {
                        compelition(true, nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        compelition(false, finalData.message!)
                    }
                }
            }
        }.resume()
    }
    func updatePassword(currentPassword: String, newPassword: String, compelition: @escaping(Bool, String?) -> ()) {
        let accessToken = getToken()
        if accessToken == nil {
            DispatchQueue.main.async {
                compelition(false, "empty")
            }
            status = false
            return
        }
        guard let url = URL(string: "\(mainUrl)/updatePassword") else {return}
        var request = URLRequest(url: url)
        let body: [String: String] = ["password": newPassword, "currentPassword": currentPassword]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) {
            data, response, err in
            if let err = err {
                print("Error took place \(err)")
                DispatchQueue.main.async {
                    compelition(false, err.localizedDescription)
                }
                self.status = false
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
                if finalData.success {
                    DispatchQueue.main.async {
                        compelition(true, nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        compelition(false, finalData.message!)
                    }
                }
            }
        }.resume()
    }
    func checkAndUpdateUser() -> Bool {
        var isLogged = false
        Api().getMe(){(data, err) in
            if err == "empty" {
                self.status = false
                return
            }
            
            if err != nil {
                Api().updateTokens { (tokens, error) in
                    if error != nil {
                        print(error!)
                        return
                    } else {
                        if tokens?.refreshToken != nil && tokens?.accessToken != nil {
                            UserDefaults.standard.setValue(tokens!.refreshToken, forKey: "refreshToken")
                            UserDefaults.standard.setValue(tokens!.accessToken, forKey: "accessToken")
                            isLogged = true
                            print("YEAH ISLOGGED")
                            return
                        }
                        return
                    }
                    
                }
            } else {
                isLogged = true
                print("YEAH ISLOGGED")
                return
            }
        }
        return isLogged
        
    }
    func fetchPatients(compelition: @escaping(Array<PatientData>?, String?) -> ()) {
        let accessToken = getToken()
        if accessToken == nil {
            status = false
            DispatchQueue.main.async {
                compelition(nil, "empty")
            }
            return
        }
        guard let url = URL(string: "\(mainUrl)/patients") else {return}
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) {
            data, response, err in
            if let err = err {
                print("Error took place \(err)")
                DispatchQueue.main.async {
                    compelition(nil, err.localizedDescription)
                }
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(PatientsList.self, from: data)
                if finalData.success {
                    DispatchQueue.main.async {
                        compelition(finalData.data, nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        compelition(finalData.data, finalData.message!)
                    }
                }
            }
        }.resume()
    }
    func deletePatient(id: String, compelition: @escaping(Bool, String?) -> ()) {
        let accessToken = getToken()
        if accessToken == nil {
            status = false
            DispatchQueue.main.async {
                compelition(false, "empty")
            }
            return
        }
        guard let url = URL(string: "\(mainUrl)/patients/\(id)") else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(String(describing: accessToken!))", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) {
            data, response, err in
            if let err = err {
                print("Error took place \(err)")
                DispatchQueue.main.async {
                    compelition(false, err.localizedDescription)
                }
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(PatientDelete.self, from: data)
                if finalData.success {
                    DispatchQueue.main.async {
                        compelition(true, nil)
                    }
                }
                else if finalData.message != nil {
                    DispatchQueue.main.async {
                        compelition(false, finalData.message!)
                    }
                } else {
                    DispatchQueue.main.async {
                        compelition(false, nil)
                    }
                }
            }
        }.resume()
    }
}


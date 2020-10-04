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
    func getMe(compelition: @escaping(UserData?, String?) -> ()) {
        
        if !userDefaults.valueExists(forKey: "accessToken") {
            print("NO KEY")
            DispatchQueue.main.async {
                compelition(nil, "empty")
            }
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
    func checkAndUpdateUser() -> Bool {
        var isLogged = false
        Api().getMe(){(data, err) in
            if err == "empty" {
                return
            }
            
            if err != nil {
                Api().updateTokens { (tokens, error) in
                    print(tokens!)
                    if error != nil {
                        print(error!)
                        return
                    } else {
                        UserDefaults.standard.setValue(tokens!.refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.setValue(tokens!.accessToken, forKey: "accessToken")
                        isLogged = true
                        print("YEAH ISLOGGED")
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
}


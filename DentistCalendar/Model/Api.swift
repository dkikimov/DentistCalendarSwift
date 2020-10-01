//
//  User.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/1/20.
//

import SwiftUI

class Api {
    let mainUrl = "https://boiling-taiga-93711.herokuapp.com"
    func login(email : String, password : String, compelition: @escaping(DataClass?, String?) -> ()) {
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
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data {
                let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
                if !finalData.success {
                    DispatchQueue.main.async {
                        compelition(nil, finalData.message![0].msg)
                    }
                    return
                }
                DispatchQueue.main.async {
                    compelition(finalData.data, nil)
                }
            }
            
        }.resume()
    }
}

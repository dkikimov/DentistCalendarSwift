//
//  getTokens.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/8/20.
//

import SwiftUI
import JWTDecode
func getToken() -> String? {
    do {
        let token = UserDefaults.standard.string(forKey: "accessToken")
        let token2 = UserDefaults.standard.string(forKey: "refreshToken")
        if token == nil || token2 == nil {
            return nil
        }
        let accessToken = try decode(jwt: token!)
        let refreshToken = try decode(jwt: token2!)
        var res: String? = nil
        if accessToken.expired && !refreshToken.expired {
            Api().updateTokens { (tokens, err) in
                if err != nil {
                    print(err!)
                    return
                }
                res = tokens!.accessToken
            }
        }
        else if !accessToken.expired && !refreshToken.expired {
            res = token
        }
        return res
    } catch  {
        print("error")
        return nil
    }
}

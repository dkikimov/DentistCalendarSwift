//
//  AvatarBlock.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/10/20.
//

import SwiftUI

struct AvatarBlock: View {
    var backgroundColor: UIColor
    var foregroundColor: UIColor
    var finalName: String
    init(fullname: Array<Substring>) {
        let a = getAvatarColor(name: Character(String(fullname[0])[0])).color
        let b = getAvatarColor(name: Character(String(fullname[0])[0])).background
        backgroundColor = UIColor.hexStringToColor(hex: b )
        foregroundColor = UIColor.hexStringToColor(hex: a)
        if fullname.count == 2 {
            finalName = String(fullname[0])[0] + String(fullname[1])[0]
        }
        else {
            finalName = String(fullname[0])[0]
        }
        
    }
    
    var body: some View {
        ZStack {
            Circle().foregroundColor(Color(backgroundColor)).frame(width: 50, height: 50)
            Text(finalName)
                .fontWeight(.bold)
                .foregroundColor(Color(foregroundColor))
                .autocapitalization(.allCharacters)
        }
    }
}

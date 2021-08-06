//
//  AvatarBlock.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/10/20.
//

import SwiftUI
func getAverageCharacterNumber(name: String) -> Int {
    var sum = 0
    for char in name {
        sum += Int(char.unicodeScalarCodePoint())
    }
    return sum / name.length
}
struct AvatarBlock: View {
    var backgroundColor: UIColor
    var foregroundColor: UIColor
    var finalName: String
    init(fullname: String) {
        let color = getAvatarColor(name: getAverageCharacterNumber(name: fullname) % 5)
        
//        let b = getAvatarColor(name: Character(String(fullname[0])[0])).
        backgroundColor = UIColor.hexStringToColor(hex: color.background )
        foregroundColor = UIColor.hexStringToColor(hex: color.color)
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

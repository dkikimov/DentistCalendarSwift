//
//  getAvatarColor.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/10/20.
//

func getAvatarColor(name: Character) -> AvatarColor {
    let charCode = name.unicodeScalarCodePoint()
    
    if (charCode >= 1040 && charCode <= 1047) {
        return AvatarColor(background: "#E9F5FF", color: "#2A86FF")
    }
    else if (charCode >= 1048 && charCode <= 1055) {
        return
            AvatarColor(background: "#F5D6D9", color: "#F38181")
        
    }
    else if (charCode >= 1056 && charCode <= 1063) {
        return
            AvatarColor(background: "#F8ECD5", color: "#F1A32F")
    }
    else if (charCode >= 1064 && charCode <= 1071) {
        return AvatarColor(background: "#DAD5F8", color: "#816CFF")
        
    }
    return AvatarColor(background: "#f38383", color: "#FFF")
}

func convertDiagnosisString(str: String, _ onlyTitle: Bool = false) -> String {
    
    let parsedArray = str.split(separator: ";")
    var res = [String]()
    parsedArray.forEach { (a) in
        let b = a.split(separator: ":")
        if b.count >= 2 {
            res.append(String(b[0]))
        }
    }
    if res.count == 0 {
        return "Пусто"
    }
    return res.joined(separator: ", ")
}

//
//  getAvatarColor.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/10/20.
//

func getAvatarColor(name: Int) -> AvatarColor {
    if name == 0 {
        return AvatarColor(background: "#E9F5FF", color: "#2A86FF")
    }
    else if name == 1 {
        return
            AvatarColor(background: "#F5D6D9", color: "#F38181")
        
    }
    else if (name == 2) {
        return
            AvatarColor(background: "#F8ECD5", color: "#F1A32F")
    }
    else if (name == 3) {
        return AvatarColor(background: "#DAD5F8", color: "#816CFF")
        
    }
    
    return AvatarColor(background: "#d4e4ce", color: "#639150")
}



//
//  ContentView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/21/20.
//

import SwiftUI
struct ContentView: View {
    @AppStorage("isLogged") var status = false
    var body: some View {
        if status {
            CalendarDisplayView(token: "123", selectDate: Date()) { (event) in
                print(event)
            }
        } else {
            LoginView()
        }
        

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

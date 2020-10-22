//
//  ContentView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/21/20.
//

import SwiftUI


//struct BasicView: View {
//    let item: BottomBarItem
//
//    var navigateButton: some View {
//        NavigationLink(destination: destination) {
//            ZStack {
//                Rectangle()
//                    .fill(item.color)
//                    .cornerRadius(8)
//                    .frame(height: 52)
//                    .padding(.horizontal)
//
//                Text("Navigate")
//                    .font(.headline)
//                    .foregroundColor(.white)
//            }
//        }
//    }
//    var body: some View {
//        VStack {
//            Spacer()
//            Spacer()
//        }
//    }
//}




struct ContentView: View {
    @AppStorage("isLogged") var status = false
    var body: some View {
        if status {
            CalendarDayView()
        } else {
            LoginView().transition(.slide)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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

//type Task
//  @model
//  @auth(
//    rules: [
//      { allow: groups, groups: ["Managers"], queries: null, mutations: [create, update, delete] }
//      { allow: groups, groups: ["Employees"], queries: [get, list], mutations: null }
//    ]
//  ) {
//  id: ID!
//  title: String!
//  description: String
//  status: String
//}
//type PrivateNote @model @auth(rules: [{ allow: owner }]) {
//  id: ID!
//  content: String!
//}


struct ContentView: View {
    @AppStorage("firstStart") var isWalktroughShowing = true
    @EnvironmentObject var sessionManager: SessionManager
    var calendar = Calendar(identifier: .gregorian)
    init() {
        calendar.locale = Locale(identifier: Locale.preferredLanguages.first!)
    }
    @ViewBuilder var body: some View {
        ZStack {
            if isWalktroughShowing {
                WalktroughView(isWalkthroughViewShowing: $isWalktroughShowing)
                    .transition(.move(edge: .bottom))
            } else {
                switch sessionManager.authState {
                case .login:
                    LoginView()
                        .environmentObject(sessionManager)
                case .session:
                    CalendarDayView()
                        .environmentObject(sessionManager)
                        .environment(\.locale, Locale.init(identifier: Locale.preferredLanguages[0]))
                        .environment(\.calendar, calendar)
                    Print("Current Locale", Locale.preferredLanguages[0])
                case .confirmCode(username: let username):
                    ConfirmationView(viewType: .signUp, username: username)
                        .environmentObject(sessionManager)
                case .forgotCode(username: let username, newPassword: let newPassword):
                    ConfirmationView(viewType: .forgotPassword, newPassword: newPassword, username: username)
                        .environmentObject(sessionManager)
                case AuthState.confirmSignUp(username: let username, password: let password):
                    ConfirmationView(viewType: .confirmSignUp, newPassword: password, username: username)
                }
            }
        }
    }
    
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

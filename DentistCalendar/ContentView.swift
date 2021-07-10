//
//  ContentView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/21/20.
//

import SwiftUI
import UIKit

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
    @AppStorage("firstStart")  var isOnboardingPresented = true
//    @State var isWalktroughShowing: Bool = true

    @EnvironmentObject var sessionManager: SessionManager
    @State var alertController = UIAlertController(title: "Ошибка", message: "Для продолжения включите доступ к интернету", preferredStyle: .alert)
    var calendar = Calendar(identifier: .gregorian)
    init() {
        calendar.locale = Locale(identifier: Locale.preferredLanguages.first!)
    }
    @ViewBuilder var body: some View {
        ZStack {
            if isOnboardingPresented {
                OnBoardingView(isWalkthroughViewShowing: $isOnboardingPresented)
                    .transition(.move(edge: .bottom))
            } else {
                switch sessionManager.authState {
                case .login:
                    LoginView()
                        .environmentObject(sessionManager)
//                        .transition(.move(edge: .bottom))
                case .session:
                    CalendarDayView()
                        .environmentObject(sessionManager)
                        .environment(\.locale, Locale.init(identifier: Locale.preferredLanguages[0]))
                        .environment(\.calendar, calendar)
//                        .transition(.move(edge: .bottom))
                    Print("Current Locale", Locale.preferredLanguages[0])
                case .confirmCode(username: let username, password: let password):
                    ConfirmationView(viewType: .signUp, password: password, username: username)
                        .environmentObject(sessionManager)
//                        .transition(.move(edge: .bottom))
                case .forgotCode(username: let username, newPassword: let newPassword):
                    ConfirmationView(viewType: .forgotPassword, password: newPassword, username: username)
                        .environmentObject(sessionManager)
//                        .transition(.move(edge: .bottom))
                case AuthState.confirmSignUp(username: let username, password: let password):
                    ConfirmationView(viewType: .confirmSignUp, password: password, username: username)
//                        .transition(.move(edge: .bottom))
                }
            }
        }
//
    }
}


//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

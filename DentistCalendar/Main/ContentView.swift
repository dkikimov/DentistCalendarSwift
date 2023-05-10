//
//  ContentView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/21/20.
//

import SwiftUI
import UIKit
struct ContentView: View {
    @AppStorage("firstStart")  var isOnboardingPresented = true
    
    @EnvironmentObject var sessionManager: SessionManager
    var calendar = Calendar(identifier: .gregorian)
    init() {
        calendar.locale = Locale(identifier: Locale.preferredLanguages.first!)
    }
    @ViewBuilder var body: some View {
        ZStack {
            if isOnboardingPresented {
                OnBoardingView(isWalkthroughViewShowing: $isOnboardingPresented)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        DispatchQueue.main.async {
                            signOutOnStart()
                        }
                    }
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
                case .confirmCode(username: let username, password: let password):
                    ConfirmationView(viewType: .signUp, password: password, username: username)
                        .environmentObject(sessionManager)
                case .forgotCode(username: let username, newPassword: let newPassword):
                    ConfirmationView(viewType: .forgotPassword, password: newPassword, username: username)
                        .environmentObject(sessionManager)
                case AuthState.confirmSignUp(username: let username, password: let password):
                    ConfirmationView(viewType: .confirmSignUp, password: password, username: username)
                }
            }
        }
        
    }
    private func signOutOnStart() {
        sessionManager.signOut(compelition: { res in
            if res != nil {
                signOutOnStart()
            }})
    }
}

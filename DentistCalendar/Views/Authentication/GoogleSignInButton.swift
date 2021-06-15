//
//  GoogleSignInButton.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.04.2021.
//

import SwiftUI

struct GoogleSignInButton: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State var isAlertPresented = false
    @State var error = ""
    @State var navController: UINavigationController?
    var body: some View {
        Button(action: {
            if let navController = navController {
                sessionManager.loginWithGoogleNative(navController: navController)
            }
//            sessionManager.loginWithGoogle { err in
//                if err != nil {
//                    self.error = err!
//                    self.isAlertPresented = true
//                }
//            }
        }) {
            HStack {
                Image("google")
                    .resizable()
                            .aspectRatio(contentMode: .fit)
                    Spacer()
                    Text("Продолжить с Google")
                        .fontWeight(.semibold)
                        .font(.title3)
                    Spacer()
            }
            .frame(minWidth: 0, maxWidth: 420, maxHeight: 25)
            .padding()

            .foregroundColor(Color("Black1"))
            .background(Color("White1"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.13), radius: 8, x: 5, y: 5)
        }
        .alert(isPresented: $isAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(self.error), dismissButton: .cancel())
        })
        .introspectNavigationController { navController in
            self.navController = navController
        }
    }
}
struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GoogleSignInButton()
                
        }
    }
}


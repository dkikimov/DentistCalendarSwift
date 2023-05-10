//
//  ContinueWithAppleButton.swift
//  Dentor
//
//  Created by Даник 💪 on 17.07.2021.
//

import SwiftUI
import AuthenticationServices

struct ContinueWithAppleButton: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.colorScheme) var currentScheme
    var body: some View {
        Button(action: {
            sessionManager.loginWithApple()
        }) {
            HStack(alignment: .center) {
                Image(systemName: "applelogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 6)
                    .padding(.bottom, 3)
                Spacer()
                Text("Продолжить с Apple")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: 420, maxHeight: 25)
        .padding()
        .foregroundColor(Color("White1"))
        .background(Color("Black1"))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .shadow(color: Color.black.opacity(0.13), radius: 8, x: 5, y: 5)
    }
}
struct SignInWithAppleView: View {
    @EnvironmentObject var sessionManager: SessionManager
    var body: some View {
        SignInWithAppleButton(.continue) { req in
            sessionManager.loginWithApple()
        } onCompletion: { _ in }
        .frame(height: 55)
        .frame(minWidth: 0, maxWidth: 420)
        .padding()
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.13), radius: 8, x: 5, y: 5)
    }
}

struct ContinueWithAppleButton_Previews: PreviewProvider {
    static var previews: some View {
        ContinueWithAppleButton()
    }
}


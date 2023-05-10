//
//  ConfirmationView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/4/20.
//

import SwiftUI

enum ConfirmationType {
    case forgotPassword
    case signUp
    case confirmSignUp
}

struct ConfirmationView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var timeRemaining = 45
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var isLoading = false
    @State var error: String = ""
    @State var isAlertPresented = false
    @State var currentlySelectedCell = 0
    
    @ObservedObject var model = PassCodeInputModel(passCodeLength: 6)
    
    var viewType: ConfirmationType
    var password: String?
    let username: String
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer().frame(height:50)
            VStack(spacing: 15) {
                Text("Подтверждение ").font(.title).bold().padding(.bottom, -10)
                Text("Одноразовый код был отправлен вам на почту").font(.body).foregroundColor(.gray)
            }
            
            CodeInputView(inputModel: model)
            Spacer()
                .frame(height: 10)
            if viewType == .confirmSignUp || viewType == .signUp {
                Button(action: {
                    timeRemaining = 45
                        sessionManager.resendSignUpCode(email: username) { err in
                            if let err = err {
                                self.error = err
                                self.isAlertPresented = true
                                timeRemaining = 0

                            }
                        }
                    
                }, label: {
                    if timeRemaining <= 0 {
                        Text("Выслать код заново")
                    } else {
                        Text("Код можно будет отправить повторно через") + Text(" \(timeRemaining) ") + Text("сек.")
                    }
                })
                .font(.footnote, weight: .semibold)
                .onReceive(timer) { _ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }
                .disabled(timeRemaining > 0)
                Spacer()
                    .frame(height: 5)
            }
            ActionButton(buttonLabel: "Подтвердить", isLoading: $isLoading, isDisabled: $model.isNotValid, action: {
                switch viewType {
                case .signUp:
                    sessionManager.confirm(username: username, password: password!, code: model.code) { err in
                        if let err = err {
                            self.error = err
                            self.isAlertPresented = true
                        }
                    }
                case .forgotPassword:
                    guard password != nil else {
                        self.error = "Пустой пароль"
                        self.isAlertPresented = true
                        return
                    }
                    sessionManager.confirmResetPassword(username: username, newPassword: password!, code: model.code, compelition: { err in
                        if let err = err {
                            self.error = err
                            self.isAlertPresented = true
                        }
                    })
                case .confirmSignUp:
                    sessionManager.confirmSignUp(for: username, with: model.code, password: password!) { (err) in
                        if let err = err{
                            self.error = err
                            self.isAlertPresented = true
                        }
                    }
                }
            })
            Spacer()
        }.padding().multilineTextAlignment(.leading)
        .alert(isPresented: $isAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(error), dismissButton: .cancel())
        })
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(viewType: .confirmSignUp, username: "as")
    }
}

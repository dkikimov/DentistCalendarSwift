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
    
    
    @State var isLoading = false
    @State var error: String = ""
    @State var isAlertPresented = false
    @State var currentlySelectedCell = 0
    
    @ObservedObject var model = PassCodeInputModel(passCodeLength: 6)
    
    var viewType: ConfirmationType
    var newPassword: String?
    let username: String
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer().frame(height:50)
            VStack(spacing: 15) {
                Text("Подтверждение ").font(.title).bold().padding(.bottom, -10)
                Text("Одноразовый код был отправлен вам на почту").font(.body).foregroundColor(.gray)
            }
            
//            PassCodeInputField(inputModel: model)
            CodeInputView(inputModel: model)
            
            CustomButton(action: {
                switch viewType {
                case .signUp:
                    sessionManager.confirm(username: username, code: model.code) { err in
                        if let err = err {
                            self.error = err
                            self.isAlertPresented = true
                        }
                    }
                case .forgotPassword:
                    guard newPassword != nil else {
                        self.error = "Пустой пароль"
                        self.isAlertPresented = true
                        return
                    }
                    sessionManager.confirmResetPassword(username: username, newPassword: newPassword!, code: model.code, compelition: { err in
                        if let err = err {
                            self.error = err
                            self.isAlertPresented = true
                        }
                    })
                case .confirmSignUp:
                    sessionManager.confirmSignUp(for: username, with: model.code, password: newPassword!) { (err) in
                        if let err = err{
                            self.error = err
                            self.isAlertPresented = true
                        }
                    }
                }
            }, imageName: "checkmark.square", label: "Подтвердить", color: "Blue", textColor: Color.white, disabled: !model.isValid, isLoading: $isLoading)
            Spacer()
        }.padding().multilineTextAlignment(.leading)
        .alert(isPresented: $isAlertPresented, content: {
            Alert(title: Text("Ошибка"), message: Text(error), dismissButton: .cancel())
        })
    }
}
//
//struct ConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmationView()
//    }
//}

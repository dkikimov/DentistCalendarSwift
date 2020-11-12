//
//  ConfirmationView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 11/4/20.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    
    @State var isLoading = false
    @State var error: String = ""
    @State var isAlertPresented = false
    @State var currentlySelectedCell = 0
    
    @ObservedObject var model = PassCodeInputModel(passCodeLength: 6)
    let username: String
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer().frame(height:50)
            Text("Подтверждение ").font(.title).bold().padding(.bottom, -10)
            Text("Одноразовый код был отправлен вам на почту").font(.body).foregroundColor(.gray)
            
            PassCodeInputField(inputModel: model)
            
            CustomButton(action: {
                sessionManager.confirm(username: username, code: model.passCodeString) { err in
                    if let err = err {
                        self.error = err
                        self.isAlertPresented = true
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

//
//  ProfileSettingsUserDataView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/7/20.
//

import SwiftUI

struct ProfileSettingsUserDataView: View {
    @StateObject var profileData = ProfileSettingsViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager
    var body: some View {
        NavigationView {
            Form {
                SecureField("Текущий пароль", text:$profileData.currentPassword)
                SecureField("Новый пароль", text: $profileData.password)
                SecureField("Повторите новый пароль", text: $profileData.repeatPassword)
//                CustomTextField(label: "Текущий пароль", title: "Пароль", text: $profileData.currentPassword, isSecure: true, keyboardType: .default)
//                    .navigationBarTitle("Изменение пароля", displayMode: .inline)
                VStack(spacing: 15){
                    Button(action: {
                        profileData.updatePassword(mode: mode, sessionManager: sessionManager)
                    }, label: {
                        if profileData.isLoading {
                            ProgressView()
                                .frame(minWidth: 0, maxWidth: 450)
                        }
                        else {
                            Text("Изменить")
                        }
                        
                    }).disabled(profileData.password != profileData.repeatPassword || profileData.password.isEmpty || profileData.repeatPassword.isEmpty || profileData.currentPassword.isEmpty || profileData.password.count < 8 || profileData.repeatPassword.count < 8).animation(.easeInOut)
                    
                }
                if profileData.password.count < 8 || profileData.repeatPassword.count < 8 {
                    Text("Минимальное количество символов - 8").foregroundColor(.red).font(.callout)
                }
                else if profileData.password != profileData.repeatPassword {
                    Text("Пароли не совпадают").foregroundColor(.red).font(.callout)
                }
                
            }
            .navigationBarTitle("Изменить пароль", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                mode.wrappedValue.dismiss()
            }, label: {
                Text("Отменить")
            }))
        }

//            .listStyle(GroupedListStyle())
            
    }
}

struct ProfileSettingsUserDataView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsUserDataView()
    }
}

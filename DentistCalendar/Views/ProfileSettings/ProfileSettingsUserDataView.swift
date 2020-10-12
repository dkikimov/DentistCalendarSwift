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
    var body: some View {
            Form {
                SecureField("Текущий пароль", text:$profileData.currentPassword)
                SecureField("Новый пароль", text: $profileData.password)
                SecureField("Повторите новый пароль", text: $profileData.repeatPassword)
                VStack(spacing: 15){
                    Button(action: {
                        profileData.updatePassword(mode: mode)
                    }, label: {
                        if profileData.isLoading {
                            ProgressView()
                                .frame(minWidth: 0, maxWidth: 450)
                        }
                        else {
                            Text("Изменить")
                        }
                        
                    }).disabled(profileData.password != profileData.repeatPassword || profileData.password.isEmpty || profileData.repeatPassword.isEmpty || profileData.currentPassword == "" || profileData.password.count < 6 || profileData.repeatPassword.count < 6).animation(.easeInOut)
                    
                }
                if profileData.password.count < 6 || profileData.repeatPassword.count < 6 {
                    Text("Минимальное количество символом - 6").foregroundColor(.red)
                }
                else if profileData.password != profileData.repeatPassword {
                    Text("Пароли не совпадают").foregroundColor(.red)
                }
            }.navigationBarTitleDisplayMode(.inline).listStyle(GroupedListStyle())
            
    }
}

struct ProfileSettingsUserDataView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsUserDataView()
    }
}

//
//  ProfileSettingsView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/5/20.
//

import SwiftUI

struct ProfileSettingsView: View {
    @StateObject var profileData = ProfileSettingsViewModel()
    var body: some View {
        Form {
            Section(header: Text("Личные данные")) {
                HStack {
                    Text("Имя").foregroundColor(.gray)
                    Spacer()
                    TextField("Имя", text: $profileData.firstName).multilineTextAlignment(.trailing).onChange(of: profileData.firstName) { newFirstName in
                        print(newFirstName != profileData.realFirstName)
                        print( profileData.secondName != profileData.realSecondName)
                        if newFirstName == profileData.realFirstName && profileData.secondName == profileData.realSecondName || newFirstName.isEmpty || profileData.secondName.isEmpty {
                            profileData.isDisabled = true
                        } else {
                            profileData.isDisabled = false
                        }
                    }
                    
                }
                HStack {
                    Text("Фамилия").foregroundColor(.gray)
                    Spacer()
                    TextField("Фамилия", text: $profileData.secondName).multilineTextAlignment(.trailing).onChange(of: profileData.secondName)  { newSecondName in
                        if profileData.firstName == profileData.realFirstName && newSecondName == profileData.realSecondName  || newSecondName.isEmpty || profileData.secondName.isEmpty {
                            profileData.isDisabled = true
                        }  else {
                            profileData.isDisabled = false
                        }
                    }
                }
                Button(action: {
                    profileData.updateFullname()
                }, label: {
                    if profileData.isLoading {
                        ProgressView().frame(width: UIScreen.main.bounds.width - 20, height: 25)
                            .frame(minWidth: 0, maxWidth: 450)
                    }
                    else {
                        Text("Изменить")
                    }
                }).disabled(profileData.isDisabled).animation(.easeInOut)
            }
                Section {
                    NavigationLink(
                        destination: ProfileSettingsUserDataView(),
                        label: {
                            Text("Изменить пароль")
                        })
                    }
            Section {
                Button(action: {
                    Api().logOut()
                }, label: {
                    Text("Выйти").foregroundColor(.red)
                })
            }
        }.listStyle(GroupedListStyle())
        .labelStyle(TitleOnlyLabelStyle())
        .groupBoxStyle(DefaultGroupBoxStyle())
        .menuStyle(BorderlessButtonMenuStyle())
        .navigationTitle("Настройки")
        .navigationBarTitleDisplayMode(.large)
//        .alert(isPresented: $profileData.isAlertPresented, content: {
//            Alert(title: profileData.alertText == "Имя успешно изменено!" ? "Успех!" : "Ошибка", message: profileData.alertText, dismissButton: .cancel())
//        })
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}

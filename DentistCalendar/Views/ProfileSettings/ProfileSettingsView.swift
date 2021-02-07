//
//  ProfileSettingsView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/5/20.
//

import SwiftUI
import Amplify

struct ProfileSettingsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
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
                Button(action: {
                    profileData.isPasswordPresented = true
                }, label: {
                    Text("Изменить пароль")
                        .foregroundColor(Color("Black1"))
                })
                NavigationLink(destination: EventAddView()) {
                    Text("Импортировать записи")
                }
            }
            Section {
                Button(action: {
                    profileData.isSheetPresented.toggle()
                }, label: {
                    Text("Подписка")
                })
            }
            Section {
                    Button(action: {
                        sessionManager.signOut { (err) in
                            if err != nil {
                                self.profileData.error = err!
                                self.profileData.isAlertPresented = true
                            }
                        }
                    }, label: {
                        Text("Выйти").foregroundColor(.red)
                    })
                    
                    
                
            }
            Button(action: {
                print(UserDefaults.standard.string(forKey: "13123213")!)
            }, label: {
                Text("Crash")
            })
            .sheet(isPresented: $profileData.isPasswordPresented, content: {
                ProfileSettingsUserDataView()
            })
            
            
        }
        .navigationBarTitle("Настройки", displayMode: .large)
        
        .ignoresSafeArea(.keyboard)
        //        .listStyle(GroupedListStyle())
        //        .labelStyle(TitleOnlyLabelStyle())
        //        .groupBoxStyle(DefaultGroupBoxStyle())
        //        .menuStyle(BorderlessButtonMenuStyle())
        .sheet(isPresented: $profileData.isSheetPresented, content: {
            BuySubscriptionView()
        })
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

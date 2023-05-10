//
//  ProfileSettingsView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/5/20.
//

import SwiftUI
import Amplify
import ApphudSDK
struct ProfileSettingsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @AppStorage("loggedWithSocialProvider") var isProviderSocial = false
    @State var isAlertPresented = false
    @StateObject var profileData = ProfileSettingsViewModel()
    var body: some View {
        Form {
            Section(header: Text("Личные данные")) {
                HStack {
                    Text("Имя").foregroundColor(.gray)
                    Spacer()
                    TextField("Имя", text: $profileData.firstName).multilineTextAlignment(.trailing)
                    
                }
                HStack {
                    Text("Фамилия").foregroundColor(.gray)
                    Spacer()
                    TextField("Фамилия", text: $profileData.secondName).multilineTextAlignment(.trailing)
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
                })
                .disabled((profileData.firstName == profileData.realFirstName && profileData.secondName == profileData.realSecondName) || profileData.firstName.isEmpty || profileData.secondName.isEmpty)
                .animation(.easeInOut)
            }
            Section(footer:
                        
                        Text(Apphud.hasActiveSubscription() ? "" : ("Экспортирование записей доступно только для пользователей Dentor Premium.".localized + " ")) + Text("Экспорт данных позволит Вам просматривать ваши записи под другим аккаунтом в Dentor или в другом поддерживаемом приложении (ICS файл).")
            ) {
                if !isProviderSocial {
                    Button(action: {
                        profileData.isPasswordPresented = true
                    }, label: {
                        Text("Изменить пароль")
                            .foregroundColor(Color("Black1"))
                    })
                }
                NavigationLink(destination: ImportEvents()) {
                    Text("Импортировать записи")
                }
                NavigationLink(destination: ExportEvents(), label: {
                    Text("Экспортировать записи")
                })
                .disabled(!Apphud.hasActiveSubscription())
            }
            Section {
                if Apphud.hasActiveSubscription() {
                    if let subscription = Apphud.subscription() {
                        HStack {
                            Text("Дата окончания подписки:")
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            Spacer()
                            Text(stringFromDate(date: subscription.expiresDate, formatString: "d MMMM YYYY"))
                                .foregroundColor(.systemGray)
                        }
                    }
                } else {
                    Button(action: {
                        profileData.isSheetPresented.toggle()
                    }, label: {
                        Text("Подписка")
                    })
                }
                #if DEBUG
                Button(action: {
                    Amplify.DataStore.start { result in
                        switch result {
                        case .success:
                            print("DataStore started")
                        case .failure(let error):
                            print("Error starting DataStore: \(error)")
                        }
                    }
                }, label: {
                    Text("Синхронизировать")
                })
                Button(action: {
                    Amplify.DataStore.clear()
                }, label: {
                    Text("Очистить локальные данные")
                })
                Button {
                    fatalError("Testing")
                } label: {
                    Text("Crash")
                }

                #endif
            }
            Section {
                Button(action: {
                    isAlertPresented = true
                }, label: {
                    Text("Выйти").foregroundColor(.red)
                })
            }
            .sheet(isPresented: $profileData.isPasswordPresented, content: {
                ProfileSettingsUserDataView()
            })
            
        }
        .alert(isPresented: $isAlertPresented, content: {
            Alert(title: Text("Выход из аккаунта"), message: Text("Если вы выйдете из своей учетной записи, все несинхронизированные данные будут удалены."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Выйти"), action: {
                withAnimation {
                    sessionManager.signOut { (err) in
                        if err != nil {
                            self.profileData.error = err!
                            self.profileData.isAlertPresented = true
                        } else {
                            DispatchQueue.main.async {
                                Apphud.logout()
                                isProviderSocial = false
                            }
                        }
                        
                    }
                }
                
            }))
        })
        .navigationBarColor(backgroundColor: UIColor(named: "Blue")!, tintColor: .white)
        .navigationBarTitle("Настройки", displayMode: .large)
        .sheet(isPresented: $profileData.isSheetPresented, content: {
            BuySubscriptionView()
        })
        .transition(.opacity)
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}

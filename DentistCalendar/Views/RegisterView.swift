//
//  RegisterView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/26/20.
//

import SwiftUI

struct RegisterView: View {
    @State var emailAddress:String = ""
    @State var password:String = ""
    @State var repeatPassword:String = ""
    @State var isLoading:Bool = false
    var body: some View {
            VStack(spacing: 15) {
                CustomTextField(label: "Email", title: "example@gmail.com", text: $emailAddress, isSecure: false, keyboardType: .default).padding(.horizontal, 20).padding(.top, 20)
                CustomTextField(label: "Пароль", title: "example123", text: $password, isSecure: true, keyboardType: .default).padding(.horizontal, 20)
                CustomTextField(label: "Подтвердите пароль", title: "example123", text: $repeatPassword, isSecure: true, keyboardType: .default).padding(.horizontal, 20)
                CustomButton(action: {
                    print("tapped")
                }, imageName: "arrowshape.zigzag.forward", label: "Зарегистрироваться", isLoading: self.$isLoading)
                Spacer(minLength: 0).navigationBarTitle(Text("Регистрация"))
            }
            
                
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

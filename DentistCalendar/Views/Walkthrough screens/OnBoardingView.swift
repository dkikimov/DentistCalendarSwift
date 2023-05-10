//
//  OnBoardingView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 22.04.2021.
//

import SwiftUI

struct OnBoardingView: View {
    @Binding var isWalkthroughViewShowing: Bool

    var body: some View {
        VStack {
            Spacer()
            Text("Возможности")
                .fontWeight(.heavy)
                .font(.system(size: 50))


            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .leading, spacing : 25) {
                        NewDetailImage(image: "calendar", imageColor: .blue)
                        NewDetailImage(image: "person.fill", imageColor: .red)
                        NewDetailImage(image: "network", imageColor: .systemIndigo)
                        NewDetailImage(image: "wifi.slash", imageColor: .systemTeal)
                    }
                    .padding()
                    VStack(alignment: .leading, spacing: 11)
                    {
                        NewDetailText( title: "Контролируйте свой график", description: "Создавайте и редактируйте свои записи и записи своих пациентов")
                        NewDetailText(title: "Управляйте пациентами", description: "Смотрите историю всех записей пациента с помощью персональной карточки")
                        NewDetailText( title: "Синхронизируйте данные", description: "Используйте приложение на нескольких устройствах и отслеживайте изменения в реальном времени")
                        NewDetailText(title: "Используйте без интернета", description: "Работает даже без доступа к интернету без ограничений в функционале")
                    }
                    Spacer()
                }

            }

            Spacer()


            ActionButton(buttonLabel: "Далее") {
                withAnimation {
                    self.isWalkthroughViewShowing = false

                }
            }
            .padding(.bottom, 20)
        }
    }
}
//
struct NewDetailText: View {
    var title: String
    var description: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title.localized)
                    .bold()

                Text(description.localized)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(5)
        .frame(maxWidth: 340)
        .frame(minHeight: 100)
    }

}
struct NewDetailImage: View {
    var image: String
    var imageColor: Color
    var body: some View {
        Image(systemName: image)
            .font(.system(size: 50))
            .frame(width: 50)
            .foregroundColor(imageColor)
            .padding()
            .alignmentGuide(.leading)
    }
}
struct OnBoardingView_Previews1: PreviewProvider {
    static var previews: some View {
        OnBoardingView(isWalkthroughViewShowing: .constant(true))
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}

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
                        NewDetailImage(image: "network", imageColor: .indigo)
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
            //                Image(systemName: image)
            //                    .resizable()
            //                    .font(.system(size: 50))
            //                    .frame(width: 50, height: 50)
            //                    .foregroundColor(imageColor)
            //                    .padding()
            //                    .alignmentGuide(.leading)

            VStack(alignment: .leading) {
                Text(title.localized)
                    .font(.title3)
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





//import SwiftUI
//
//struct OnBoardingView: View {
//    @Binding var isWalkthroughViewShowing: Bool
//
//    var body: some View {
//        VStack {
//            Spacer()
//                Text("What's New")
//                    .fontWeight(.heavy)
//                    .font(.system(size: 50))
//                    .frame(width: 300, alignment: .leading)
//
//
//                VStack(alignment: .leading) {
//                    NewDetail(image: "heart.fill", imageColor: .pink, title: "More Personalized", description: "Top Stories picked for you and recommendations from siri.")
//                    NewDetail(image: "paperclip", imageColor: .red, title: "New Spotlight Tab", description: "Discover great stories selected by our editors.")
//                    NewDetail(image: "play.rectangle.fill", imageColor: .blue, title: "Video In Today View", description: "The day's best videos, right in the News widget.")
//            }
//
//            Spacer()
//
//
//            ActionButton(buttonLabel: "Далее") {
//                withAnimation {
//                                        self.isWalkthroughViewShowing = false
//
//                }
//            }
//            .padding(.bottom, 20)
//        }
//    }
//}
//
//struct NewDetail: View {
//    var image: String
//    var imageColor: Color
//    var title: String
//    var description: String
//
//    var body: some View {
//            HStack(alignment: .center) {
//                Image(systemName: image)
//                    .font(.system(size: 50))
//                    .accessibility(hidden: true)
//                    .padding(.trailing, 10)
//                    .foregroundColor(imageColor)
//
//
//                VStack(alignment: .leading) {
//                    Text(title).bold()
//                        .accessibility(addTraits: .isHeader)
//                    Text(description)
//                        .multilineTextAlignment(.leading)
//                }
//                .accessibilityElement(children: .combine)
//            }
//            .frame(height: 100)
//    }
//}
//
//struct OnBoardingView_Previews1: PreviewProvider {
//    static var previews: some View {
//        OnBoardingView(isWalkthroughViewShowing: .constant(true))
//    }
//}

import SwiftUI

public struct RROnboardingKit {
    public struct TitleView: View {
        var isIntroductionView: Bool
        var title: String
        var textSize: CGFloat = 30

        public init(isIntroductionView: Bool, title: String, textSize: CGFloat = 30) {
            self.isIntroductionView = isIntroductionView
            self.title = title
            self.textSize = textSize
        }

        public var body: some View {
            VStack {
                Text(isIntroductionView ? "WELCOME TO" : "WHAT'S NEW IN")
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .modifier(ScaledFont(size: textSize))

                Text(title.uppercased())
                    .fontWeight(.black)
                    .modifier(ScaledFont(size: textSize))
            }
            .accessibilityElement(children: .combine)
            .accessibility(addTraits: .isHeader)
            .padding(.horizontal)
        }
    }

    public struct InformationDetailView: View {
        var header: String
        var description: String
        var imageName: String

        public init(header: String, description: String, imageName: String) {
            self.header = header
            self.description = description
            self.imageName = imageName
        }

        public var body: some View {
            HStack(alignment: .center) {
                Image(systemName: imageName)
                    .font(.system(size: 50))
                    .accessibility(hidden: true)
                    .padding(.trailing, 10)

                VStack(alignment: .leading) {
                    Text(header)
                        .fontWeight(.bold)
                        .font(.body)
                        .foregroundColor(.primary)
                        .accessibility(addTraits: .isHeader)

                    Text(description)
                        .foregroundColor(.secondary)
                        .font(.body)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                }
                .accessibilityElement(children: .combine)
            }
            .padding()
        }
    }
}

struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var size: CGFloat

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.system(size: scaledSize))
    }
}

struct InformationDetailModel: Hashable {
    var header: String
    var description: String
    var imageName: String
}

extension InformationDetailModel {
    static let allInformationDetails = [
        InformationDetailModel(header: "MATCH",
                               description: "Match the gradient by moving the sliders for each left and right colors.",
                               imageName: "slider.horizontal.below.rectangle"),
        InformationDetailModel(header: "PRECISE",
                               description: "More precision with the steppers to get that 100 score.",
                               imageName: "minus.slash.plus"),
        InformationDetailModel(header: "SCORE",
                               description: "A detailed score and comparsion of your gradient and the target gradient with overall score.",
                               imageName: "checkmark.circle"),
        InformationDetailModel(header: "SYNC",
                               description: "Sync the history of your target gradients across all your devices on iCloud.",
                               imageName: "icloud.circle")
    ]
}

struct LolKek:View {
    var body: some View {
        ScrollView {
            RROnboardingKit.TitleView(isIntroductionView: true, title: "Gradient Game", textSize: 30)

            VStack(alignment: .leading) {
                ForEach(InformationDetailModel.allInformationDetails, id: \.self) { detail in
                    RROnboardingKit.InformationDetailView(header: detail.header,
                                                          description: detail.description,
                                                          imageName: detail.imageName)
                }
            }
        }
    }
}

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
                Text("What's New")
                    .fontWeight(.heavy)
                    .font(.system(size: 50))
                    .frame(width: 300, alignment: .leading)
        
                
                VStack(alignment: .leading) {
                    NewDetail(image: "heart.fill", imageColor: .pink, title: "More Personalized", description: "Top Stories picked for you and recommendations from siri.")
                    NewDetail(image: "paperclip", imageColor: .red, title: "New Spotlight Tab", description: "Discover great stories selected by our editors.")
                    NewDetail(image: "play.rectangle.fill", imageColor: .blue, title: "Video In Today View", description: "The day's best videos, right in the News widget.")
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

struct NewDetail: View {
    var image: String
    var imageColor: Color
    var title: String
    var description: String

    var body: some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: image)
                    .font(.system(size: 50))
                    .frame(width: 50)
                    .foregroundColor(imageColor)
                    .padding()

                VStack(alignment: .leading) {
                    Text(title).bold()
                
                    Text(description)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }.frame(width: 340, height: 100)
        }
    }
}

//struct OnBoardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoardingView()
//    }
//}

//
//  TabDetailsView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 24.02.2021.
//

import SwiftUI

struct TabDetailsView: View {
    let imageUrl: String
    let title: String
    let content: String

    var body: some View {
        VStack(spacing: 10) {
            Image(imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(title)
                .font(.largeTitle)
                
                .fontWeight(.heavy)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .frame(width: UIScreen.main.bounds.width - 10)
            

            Text(content)
                .fontWeight(.semibold)
                .frame(width: UIScreen.main.bounds.width - 10)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                
                
            Spacer(minLength: 0)
                .frame(height: 50)
        }
                
        .foregroundColor(.white)
    }
}
//struct PageTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            WalktroughView()
//        }
//        .previewDevice("iPhone 12")
//    }
//}

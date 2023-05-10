//
//  TabDetailsView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 24.02.2021.
//

import SwiftUI

struct TabDetailsView: View {
    @State var imageUrl: String
    @State var title: String
    @State var content: String
    
    var body: some View {
        VStack {
            LoopingPlayer(videoName: imageUrl)
                .hidden(imageUrl.isEmpty)
                .shadow(color: Color.black.opacity(0.13), radius: 8, x: 5, y: 5)
            
            Text(title.localized)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()
                .font(Font.system(.largeTitle, design: .default).weight(.bold))
                .minimumScaleFactor(0.5)
            
            Text(content.localized)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()
                .padding(.top, 5)
            Spacer()
                .frame(height: 50)
                .clipped()
        }
        .foregroundColor(.white)
        
        
    }
}
struct PageTabView_Previews: PreviewProvider {
    static var previews: some View {
        TabDetailsView(imageUrl: "", title: "Удаление записей", content: "Для удаления записей из списков просто проведите влево по строке!")
    }
}

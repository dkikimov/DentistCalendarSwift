//
//  PageTabView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 24.02.2021.
//

import SwiftUI

struct PageTabView: View {
    @Binding var selection: Int
    @Binding var isShown: Bool
    var body: some View {
        TabView(selection: $selection) {
           
            ForEach(tabs.indices, id: \.self) { index in
                TabDetailsView(imageUrl:  tabs[index].image,
                               title: tabs[index].title,
                               content: tabs[index].content)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
}



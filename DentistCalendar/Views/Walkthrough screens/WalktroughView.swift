//
//  WalktroughView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 24.02.2021.
//

import SwiftUI
struct WalktroughView: View {
    @State private var selection = 0
    @Binding var isWalkthroughViewShowing: Bool
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color(hex: "#2474E2").ignoresSafeArea()
            
            VStack {
                HStack(alignment: .bottom) {
                    Spacer()
                    
                    CloseButton(presentationMode: presentationMode, color: .white)
                        .opacity(0.7)
                    
                }
                .padding(.bottom, 5)
                .padding(.top, 12)
                .frame(height: 30)
                
                Spacer()
                PageTabView(selection: $selection, isShown: $isWalkthroughViewShowing)
                ButtonsView(selection: $selection, isShown: $isWalkthroughViewShowing, backgroundColor: Color(hex: "#E7EFFF"), foregroundColor: Color(#colorLiteral(red: 0.1647058824, green: 0.5254901961, blue: 1, alpha: 1)))
                    .frame(maxHeight: 50)
                    .padding(.bottom, 8)
                
            }
            
        }
        .transition(AnyTransition.move(edge: .bottom))
    }
}

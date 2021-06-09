//
//  ViewExtension.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 01.02.2021.
//

import SwiftUI

public extension View {
    @ViewBuilder func halfModalSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            ZStack {
                self
                HalfModalView(isShown: isPresented, modalHeight: height, content: content)
            }
        } else {
            self
        }
    }
}

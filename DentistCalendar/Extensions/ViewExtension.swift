//
//  ViewExtension.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 01.02.2021.
//

import SwiftUI

public extension View {
    func halfModalSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            HalfModalView(isShown: isPresented, modalHeight: height, content: content)
        }
    }
}

//
//  ForeachExtension.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 02.06.2021.
//

import Foundation
import SwiftUI
extension Binding where
    Value: MutableCollection,
    Value: RangeReplaceableCollection
{
    subscript(
        _ index: Value.Index,
        default defaultValue: Value.Element
    ) -> Binding<Value.Element> {
        Binding<Value.Element> {
            guard index < self.wrappedValue.endIndex else {
                return defaultValue
            }
            return self.wrappedValue[index]
        } set: { newValue in
            
            // It is possible that the index we are updating
            // is beyond the end of our array so we first
            // need to append items to the array to ensure
            // we are within range.
            while index >= self.wrappedValue.endIndex {
                self.wrappedValue.append(defaultValue)
            }
            
            self.wrappedValue[index] = newValue
        }
    }
}

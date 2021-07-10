//
//  KeyboardAwareModifier.swift
//  recipeat
//
//  Created by Christopher Guirguis on 3/16/20.
//  Copyright © 2020 Christopher Guirguis. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//struct KeyboardAwareModifier: ViewModifier {
//    @State private var keyboardHeight: CGFloat = 0
//
//    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
//        Publishers.Merge(
//            NotificationCenter.default
//                .publisher(for: UIResponder.keyboardWillShowNotification)
//                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
//                .map { $0.cgRectValue.height },
//            NotificationCenter.default
//                .publisher(for: UIResponder.keyboardWillHideNotification)
//                .map { _ in CGFloat(0) }
//       ).eraseToAnyPublisher()
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .padding(.bottom, keyboardHeight)
//            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
//    }
//}
//
//extension View {
//    func KeyboardAwarePadding() -> some View {
//        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
//    }
//}

extension String {
    func isValidPhoneNumber() -> Bool {
        let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"
        
        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
}

extension Binding where Value: MutableCollection
{
    subscript(safe index: Value.Index) -> Binding<Value.Element>
    {
        // Get the value of the element when we first create the binding
        // Thus we have a 'placeholder-value' if `get` is called when the index no longer exists
        let safety = wrappedValue[index]
        return Binding<Value.Element>(
            get: {
                guard self.wrappedValue.indices.contains(index)
                else { return safety } //If this index no longer exists, return a dummy value
                return self.wrappedValue[index]
            },
            set: { newValue in
                guard self.wrappedValue.indices.contains(index)
                else { return } //If this index no longer exists, do nothing
                self.wrappedValue[index] = newValue
            })
    }
}


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

//extension String {
//    static let numberFormatter = NumberFormatter()
//    var doubleValue: Double {
//        String.numberFormatter.decimalSeparator = "."
//        if let result =  String.numberFormatter.number(from: self) {
//            print("DOT", result.stringValue)
//            return result.doubleValue
//        } else {
//            String.numberFormatter.decimalSeparator = ","
//            if let result = String.numberFormatter.number(from: self) {
//                print("COMMA", result)
//
//                return result.doubleValue
//            }
//        }
//        return 0
//    }
//}

extension String {
    static let numberFormatter = NumberFormatter()
    var decimalValue: Decimal {
        return Decimal(string: self, locale: Locale.current) ?? Decimal(0)
    }
}


extension Decimal {
    /// Must be used only for displaying value
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
//        formatter.decimalSeparator = "."
        
//        let decimal = Decimal(string: "\(self)".replacingOccurrences(of: ",", with: ".")) ?? Decimal(0)
        return formatter.string(from: self as NSDecimalNumber) ?? formatter.string(from: 0 as NSDecimalNumber)!
        
    }
    /// Get number from string such as currency string
    
}
extension Decimal {
    /// Get string value
    var stringValue: String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
//        formatter.decimalSeparator = "."
//        let decimal = Decimal(string: "\(self)".replacingOccurrences(of: ",", with: ".")) ?? Decimal(0)
        return formatter.string(from: self as NSDecimalNumber) ?? formatter.string(from: 0 as NSDecimalNumber)!
        
    }
    /// Get number from string such as currency string
    
}


extension String {
    var getNumber: Double {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency
        return formatter.number(from: self)?.doubleValue ?? 0
        
    }
}
//extension Decimal {
//    var currencyFormatted: String {
//        let formatter = NumberFormatter()
//        formatter.minimumFractionDigits = 0
//        formatter.maximumFractionDigits = 2
//        formatter.usesGroupingSeparator = false
//        // Avoid not getting a zero on numbers lower than 1
//        // Eg: .5, .67, etc...
//        formatter.numberStyle = .decimal
//
//
//         return formatter.string(from: self as NSNumber) ?? "0"
//
//    }
//}

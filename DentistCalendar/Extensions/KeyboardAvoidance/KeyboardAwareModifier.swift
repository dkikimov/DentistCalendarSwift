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
import StoreKit

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
        let safety = wrappedValue[index]
        return Binding<Value.Element>(
            get: {
                guard self.wrappedValue.indices.contains(index)
                else { return safety }
                return self.wrappedValue[index]
            },
            set: { newValue in
                guard self.wrappedValue.indices.contains(index)
                else { return }
                self.wrappedValue[index] = newValue
            })
    }
}


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

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
        return formatter.string(from: self as NSDecimalNumber) ?? formatter.string(from: 0 as NSDecimalNumber)!
        
    }
    /// Get number from string such as currency string
    
}

extension SKProduct {
    var ownLocalizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}

extension String {
    var getNumber: Double {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency
        return formatter.number(from: self)?.doubleValue ?? 0
        
    }
}

//
//  PhoneNumberTextFieldView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/25/20.
//

import SwiftUI
import PhoneNumberKit

struct PhoneNumberTextFieldView: UIViewRepresentable {
    @Binding var phoneNumber: String
    public let sharedInstance: PhoneNumberKit = PhoneNumberKit.init()

    func makeUIView(context: Context) -> PhoneNumberTextField {
        let textField = PhoneNumberTextField()

        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)

        textField.addTarget(context.coordinator, action: #selector(Coordinator.onTextChange), for: .editingChanged)
        textField.delegate = context.coordinator
        textField.withExamplePlaceholder = true
        textField.withPrefix = true

        textField.maxDigits = phoneNumberMaxLength
        textField.text = phoneNumber
        return textField
    }
    
    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
        view.text = phoneNumber
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(phoneNumber: $phoneNumber)
    }
    
    
    class Coordinator:  NSObject, UITextFieldDelegate {
        @Binding var phoneNumber: String
        
        init(phoneNumber: Binding<String>) {
            _phoneNumber = phoneNumber
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.phoneNumber = textField.text ?? ""
        }
        @objc func onTextChange(textField: UITextField) {
            
            guard let textField = textField as? PhoneNumberTextField else { return assertionFailure("Undefined state") }
            
            self.phoneNumber = textField.text ?? ""
            
        }
        
        
        
    
    }
}

//
//  PhoneNumberTextFieldView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/25/20.
//

import SwiftUI
import PhoneNumberKit


//struct PhoneNumberTextFieldView: UIViewRepresentable {
//
//    @Binding var phoneNumber: String
//    private let textField = PhoneNumberTextField()
//
//    func makeUIView(context: Context) -> PhoneNumberTextField {
//        textField.defaultRegion = Locale.current.regionCode ?? "KZ"
//        textField.withExamplePlaceholder = true
//        textField.maxDigits = 15
//        textField.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
//        return textField
//    }
//
//    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UITextFieldDelegate {
//
//        var control: PhoneNumberTextFieldView
//
//        init(_ control: PhoneNumberTextFieldView) {
//            self.control = control
//        }
//
//        @objc func onTextUpdate(textField: UITextField) {
//            DispatchQueue.main.async {
//                self.control.phoneNumber = textField.text!
//            }
//        }
//
//    }
//
//}


struct PhoneNumberTextFieldView: UIViewRepresentable {
    @Binding var phoneNumber: String
    public let sharedInstance: PhoneNumberKit = PhoneNumberKit.init()
    let textField = PhoneNumberTextField()

    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.addTarget(context.coordinator, action: #selector(Coordinator.onTextChange), for: .editingChanged)
        textField.delegate = context.coordinator
//        textField.defaultRegion = Locale.current.regionCode ?? "KZ"
        textField.withExamplePlaceholder = true
        textField.maxDigits = 15
        textField.text = phoneNumber
//        print("YEP YEP MADE VIEw")
        return textField
    }
    
    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
        view.text = phoneNumber
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator:  NSObject, UITextFieldDelegate {
        var parent: PhoneNumberTextFieldView
        
        init(_ parent: PhoneNumberTextFieldView) {
            self.parent = parent
        }
        
        @objc func onTextChange(textField: UITextField) {
            
            guard let textField = textField as? PhoneNumberTextField else { return assertionFailure("Undefined state") }
//            self.text.wrappedValue = textField.text ?? ""
            
            self.parent.phoneNumber = textField.text ?? ""
            
//            print("SET TEXT", self.parent.$phoneNumber.wrappedValue)
        }
        
        
        
    
    }
}




//struct PhoneNumberTextFieldView: UIViewRepresentable {
//    @Binding var phoneNumber: String
//    private let textField = PhoneNumberTextField()
//
//    func makeUIView(context: Context) -> PhoneNumberTextField {
//        textField.defaultRegion = Locale.current.regionCode ?? "KZ"
//        textField.withExamplePlaceholder = true
//        textField.maxDigits = 12
//
//        return textField
//    }
//
//    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
//        DispatchQueue.main.async {
//          if self.phoneNumber != view.text {
//            self.phoneNumber = view.text ?? ""
//          }
//        }
//        print("SET NUMBER", self.phoneNumber)
//
//
//    }
//
//
//
//}



//struct PhoneNumberTextFieldView: UIViewRepresentable {
//    @Binding var phoneNumber: String
//    func makeCoordinator() -> PhoneNumberTextFieldView.Coordinator {
//        Coordinator(text: self.$phoneNumber)
//    }
//    
//    func makeUIView(context: Context) -> PhoneNumberTextField {
//        let phoneTextField = PhoneNumberTextField()
//        phoneTextField.delegate = context.coordinator
//        phoneTextField.defaultRegion = Locale.current.regionCode ?? "KZ"
//        phoneTextField.withExamplePlaceholder = true
//        phoneTextField.maxDigits = 15
//        return phoneTextField
//    }
//    
//    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
//        DispatchQueue.main.async {
//          if self.phoneNumber != view.text {
//            self.phoneNumber = view.text ?? ""
//          }
//        }
//    }
//    
//    final class Coordinator: NSObject, UITextFieldDelegate {
//            
//            let text: Binding<String>
//            
//            init(text: Binding<String>) {
//                self.text = text
//            }
//            
//            func phoneNumberField(_ phoneNumberField: PhoneNumberTextField, textDidChange searchText: String) {
//                text.wrappedValue = searchText
//            }
//        }
//}

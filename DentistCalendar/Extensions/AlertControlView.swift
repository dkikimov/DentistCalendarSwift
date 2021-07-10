//
//  AlertControlView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 14.11.2020.
//

import SwiftUI

struct AlertTextFieldModel {
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    var autoCapitalizationType: UITextAutocapitalizationType = .sentences
}


struct AlertControlView: UIViewControllerRepresentable {

//    @Binding var textString: String
//    @Binding var priceString: String
    var fields: [AlertTextFieldModel]?
    @Binding var showAlert: Bool
    var action:  () -> Void
    var title: String
    var message: String
    var selectedDiagnosis: Binding<Diagnosis?>? = nil
    // Make sure that, this fuction returns UIViewController, instead of UIAlertController.
    // Because UIAlertController gets presented on UIViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControlView>) -> UIViewController {
        return UIViewController() // Container on which UIAlertContoller presents
    }

     func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControlView>) {

        // Make sure that Alert instance exist after View's body get re-rendered
        guard context.coordinator.alert == nil else { return }

        if self.showAlert {
            let isDiagnosisSelected: Bool = {
                    if selectedDiagnosis?.wrappedValue != nil {
                        return true
                    } else {
                        return false
                    }
                
            }()
            // Create UIAlertController instance that is gonna present on UIViewController
            let alert = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
            context.coordinator.alert = alert
            if fields != nil {
                
            
            for alertModel in fields! {
                alert.addTextField { textField in
                    textField.placeholder = alertModel.placeholder.localized
                    textField.text = alertModel.text.localized            // setting initial value
                    textField.delegate = context.coordinator // using coordinator as delegate
                    textField.autocapitalizationType = alertModel.autoCapitalizationType
                    textField.keyboardType = alertModel.keyboardType
                    
    //                func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //                    // get the current text, or use an empty string if that failed
    //                    let currentText = textField.text ?? ""
    //
    //                    // attempt to read the range they are trying to change, or exit if we can't
    //                    guard let stringRange = Range(range, in: currentText) else { return false }
    //
    //                    // add their new text to the existing text
    //                    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    //
    //                    // make sure the result is under 16 characters
    //                    return updatedText.count <= 100
    //                }

                }
            }}

            // As usual adding actions
            alert.addAction(UIAlertAction(title: "Отменить".localized , style: .cancel) { _ in

                // On dismiss, SiwftUI view's two-way binding variable must be update (setting false) means, remove Alert's View from UI
                alert.dismiss(animated: true) {
                    self.showAlert = false
                    self.selectedDiagnosis?.wrappedValue = nil
                }
            })

            alert.addAction(UIAlertAction(title: isDiagnosisSelected ? "Обновить".localized : "Добавить".localized , style: .default) { _ in
                // On submit action, get texts from TextField & set it on SwiftUI View's two-way binding varaible `textString` so that View receives enter response.
                if fields != nil {
                    for i in 0...fields!.count-1 {
                        self.fields![i].text = alert.textFields![i].text ?? ""
                    }
                }
//                for textField in alert.textFields! {
//
////                    if textField.placeholder == "Диагноз" {
////                        self.textString = textField.text ?? ""
////                    } else {
////                        self.priceString = textField.text ?? ""
////                    }
//                }
                action()
                alert.dismiss(animated: true) {
                    self.showAlert = false
                }
            })

            // Most important, must be dispatched on Main thread,
            // Curious? then remove `DispatchQueue.main.async` & find out yourself, Dont be lazy
            DispatchQueue.main.async { // must be async !!
                uiViewController.present(alert, animated: true, completion: {
                    self.showAlert = false  // hide holder after alert dismiss
                    context.coordinator.alert = nil
                })

            }
        }
    }

    func makeCoordinator() -> AlertControlView.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        // Holds reference of UIAlertController, so that when `body` of view gets re-rendered so that Alert should not disappear
        var alert: UIAlertController?

        // Holds back reference to SwiftUI's View
        var control: AlertControlView

        init(_ control: AlertControlView) {
            self.control = control
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if textField.placeholder == "Название услуги".localized {
                return updatedText.count <= 99
            } else if textField.placeholder == "Стоимость".localized {
                return updatedText.count <= 15
            }
//            if let text = textField.text as NSString? {
//                self.control.textString = text.replacingCharacters(in: range, with: string)
//            } else {
//                self.control.al = ""
//            }
            return true
        }
    }
}

//
//  AlertControlView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 14.11.2020.
//

//
//  AlertControlView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 14.11.2020.
//

//import SwiftUI
//
//struct AlertControlView: UIViewControllerRepresentable {
//
//    @Binding var textString: String
//    @Binding var priceString: String
//    @Binding var showAlert: Bool
//    var action:  () -> Void
//    var title: String
//    var message: String
//
//    // Make sure that, this fuction returns UIViewController, instead of UIAlertController.
//    // Because UIAlertController gets presented on UIViewController
//    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControlView>) -> UIViewController {
//        return UIViewController() // Container on which UIAlertContoller presents
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControlView>) {
//
//        // Make sure that Alert instance exist after View's body get re-rendered
//        guard context.coordinator.alert == nil else { return }
//
//        if self.showAlert {
//
//            // Create UIAlertController instance that is gonna present on UIViewController
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            context.coordinator.alert = alert
//
//            // Adds UITextField & make sure that coordinator is delegate to UITextField.
//            alert.addTextField { textField in
//                textField.placeholder = "Диагноз"
//                textField.text = self.textString            // setting initial value
//                textField.delegate = context.coordinator // using coordinator as delegate
//                textField.autocapitalizationType = .sentences
////                func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////                    // get the current text, or use an empty string if that failed
////                    let currentText = textField.text ?? ""
////
////                    // attempt to read the range they are trying to change, or exit if we can't
////                    guard let stringRange = Range(range, in: currentText) else { return false }
////
////                    // add their new text to the existing text
////                    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
////
////                    // make sure the result is under 16 characters
////                    return updatedText.count <= 100
////                }
//
//            }
//            alert.addTextField { textField in
//                textField.placeholder = "Цена"
//                textField.text = self.priceString            // setting initial value
//                textField.delegate = context.coordinator    // using coordinator as delegate
//                textField.keyboardType = .decimalPad
////                func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////                    // get the current text, or use an empty string if that failed
////                    let currentText = textField.text ?? ""
////
////                    // attempt to read the range they are trying to change, or exit if we can't
////                    guard let stringRange = Range(range, in: currentText) else { return false }
////
////                    // add their new text to the existing text
////                    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
////
////                    // make sure the result is under 16 characters
////                    return updatedText.count <= 20
////                }
//            }
//            // As usual adding actions
//            alert.addAction(UIAlertAction(title: NSLocalizedString("Отменить", comment: "") , style: .cancel) { _ in
//
//                // On dismiss, SiwftUI view's two-way binding variable must be update (setting false) means, remove Alert's View from UI
//                alert.dismiss(animated: true) {
//                    self.showAlert = false
//                }
//            })
//
//            alert.addAction(UIAlertAction(title: NSLocalizedString("Добавить", comment: ""), style: .default) { _ in
//                // On submit action, get texts from TextField & set it on SwiftUI View's two-way binding varaible `textString` so that View receives enter response.
//                for textField in alert.textFields! {
//                    if textField.placeholder == "Диагноз" {
//                        self.textString = textField.text ?? ""
//                    } else {
//                        self.priceString = textField.text ?? ""
//                    }
//                }
//                action()
//
//                alert.dismiss(animated: true) {
//                    self.showAlert = false
//                }
//            })
//
//            // Most important, must be dispatched on Main thread,
//            // Curious? then remove `DispatchQueue.main.async` & find out yourself, Dont be lazy
//            DispatchQueue.main.async { // must be async !!
//                uiViewController.present(alert, animated: true, completion: {
//                    self.showAlert = false  // hide holder after alert dismiss
//                    context.coordinator.alert = nil
//                })
//
//            }
//        }
//    }
//
//    func makeCoordinator() -> AlertControlView.Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UITextFieldDelegate {
//
//        // Holds reference of UIAlertController, so that when `body` of view gets re-rendered so that Alert should not disappear
//        var alert: UIAlertController?
//
//        // Holds back reference to SwiftUI's View
//        var control: AlertControlView
//
//        init(_ control: AlertControlView) {
//            self.control = control
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            if let text = textField.text as NSString? {
//                self.control.textString = text.replacingCharacters(in: range, with: string)
//            } else {
//                self.control.textString = ""
//            }
//            return true
//        }
//    }
//}

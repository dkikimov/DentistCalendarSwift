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
    var fields: [AlertTextFieldModel]?
    @Binding var showAlert: Bool
    var action:  () -> Void
    var cancelAction: () -> Void = {}
    var title: String
    var message: String
    var selectedDiagnosis: Binding<Diagnosis?>? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControlView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControlView>) {
        
        guard context.coordinator.alert == nil else { return }
        
        if self.showAlert {
            let isDiagnosisSelected: Bool = {
                if selectedDiagnosis?.wrappedValue != nil {
                    return true
                } else {
                    return false
                }
                
            }()
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
                        
                    }
                }}
            
            alert.addAction(UIAlertAction(title: "Отменить".localized , style: .cancel) { _ in
                alert.dismiss(animated: true) {
                    self.showAlert = false
                    cancelAction()
                    for field in fields! {
                        field.text = ""
                    }
                }
            })
            
            alert.addAction(UIAlertAction(title: isDiagnosisSelected ? "Обновить".localized : "Добавить".localized , style: .default) { _ in
                if fields != nil {
                    for i in 0...fields!.count-1 {
                        self.fields![i].text = alert.textFields![i].text ?? ""
                    }
                }
                action()
                alert.dismiss(animated: true) {
                    self.showAlert = false
                }
            })
            
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: {
                    self.showAlert = false
                    context.coordinator.alert = nil
                })
                
            }
        }
    }
    
    func makeCoordinator() -> AlertControlView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        var control: AlertControlView
        
        init(_ control: AlertControlView) {
            self.control = control
        }
        
    }
}

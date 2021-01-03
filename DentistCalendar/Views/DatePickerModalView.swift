////
////  DatePickerModalView.swift
////  DentistCalendar
////
////  Created by Даник 💪 on 15.12.2020.
////
//
//import SwiftUI
//import UIKit
//import SPStorkController
//
//class DatePickerViewController: UIViewController {
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let controller = UIViewController()
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        transitionDelegate.showCloseButton = true
//        transitionDelegate.showIndicator = true
//        controller.transitioningDelegate = transitionDelegate
//        controller.modalPresentationStyle = .automatic
//        controller.modalPresentationCapturesStatusBarAppearance = true
//        self.present(controller, animated: true, completion: nil)
//    }
//}
//
//struct DatePickerModalView: UIViewControllerRepresentable {
//    private var datePicker =  DatePickerViewController()
//
//    func makeUIViewController(context: Context) -> DatePickerViewController {
//        return datePicker
//    }
//
//    func updateUIViewController(_ view: DatePickerViewController, context: Context) {
//        
//    }
//}

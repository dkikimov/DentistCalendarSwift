//
//  Alert.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 07.02.2021.
//
import Foundation
import SPAlert
//import UIKit
//import SwiftUI
func presentSuccessAlert(message: String) {
    let alertView = SPAlertView(title: "Успех!".localized, message: message.localized, preset: .done)
    DispatchQueue.main.async {
        alertView.present(duration: 3, haptic: .success)
    }
}
func presentErrorAlert(message: String) {
    let alertView = SPAlertView(title: "Ошибка!".localized, message: message.localized, preset: .error)
    DispatchQueue.main.async {
        alertView.present(duration: 4, haptic: .error)
    }
}

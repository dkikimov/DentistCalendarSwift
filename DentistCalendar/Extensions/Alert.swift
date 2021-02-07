//
//  Alert.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 07.02.2021.
//

import SPAlert

func presentSuccessAlert(message: String) {
    let alertView = SPAlertView(title: "Успех!".localized, message: message.localized, preset: .done)
    alertView.present(duration: 2, haptic: .success)
}
func presentErrorAlert(message: String) {
    let alertView = SPAlertView(title: "Ошибка!".localized, message: message.localized, preset: .error)
    alertView.present(duration: 3, haptic: .error)
}

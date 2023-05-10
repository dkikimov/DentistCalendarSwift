//
//  BannerAdView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.01.2021.
//

import SwiftUI
import UIKit
import Appodeal

func showBanner(placement: String) {
     guard
        Appodeal.isInitalized(for: .banner),
        Appodeal.canShow(.banner, forPlacement: placement)
    else {
        print("AD NOT READY")
        return
    }
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            Appodeal.showAd(.bannerBottom,
                              forPlacement: placement,
                              rootViewController: topController)
    
}
}

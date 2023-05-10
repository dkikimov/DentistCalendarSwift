//
//  IntersistititalAdView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.01.2021.
//

import UIKit
import Appodeal
import ApphudSDK
func showInterstitial(placement: String) {
    guard !Apphud.hasActiveSubscription() else {
        return
    }
    guard
        Appodeal.isInitalized(for: .interstitial),
        Appodeal.canShow(.interstitial, forPlacement: placement)
    else {
        print("AD NOT READY")
        return
    }
    Appodeal.showAd(.interstitial,
                    forPlacement: placement,
                    rootViewController: nil)
    
}

func showRewardedVideo(placement: String, completion: @escaping (Bool) -> ()) {
    guard !Apphud.hasActiveSubscription() else {
        return
    }
    guard
        Appodeal.isInitalized(for: .rewardedVideo),
        Appodeal.canShow(.rewardedVideo, forPlacement: placement)
    else {
        print("AD NOT READY")
        DispatchQueue.main.async {
            completion(false)
        }
        return
    }
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    if var topController = keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        DispatchQueue.main.async {
            completion(true)
        }
        Appodeal.showAd(.rewardedVideo,
                        forPlacement: placement,
                        rootViewController: topController)
    }
}

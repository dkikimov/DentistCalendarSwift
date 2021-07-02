//
//  IntersistititalAdView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.01.2021.
//

import UIKit
import Appodeal

func showInterstitial(placement: String) {
    
     guard
        Appodeal.isInitalized(for: .interstitial),
        Appodeal.canShow(.interstitial, forPlacement: placement)
    else {
        print("AD NOT READY")
        return
    }
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    //            print("WINDOWS COUNT", UIApplication.shared.windows.filter {$0.isKeyWindow}.count)
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            Appodeal.showAd(.interstitial,
                              forPlacement: placement,
                              rootViewController: topController)
    
}
}

func showRewardedVideo(placement: String) {
    
     guard
        Appodeal.isInitalized(for: .rewardedVideo),
        Appodeal.canShow(.rewardedVideo, forPlacement: placement)
    else {
        print("AD NOT READY")
        return
    }
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    //            print("WINDOWS COUNT", UIApplication.shared.windows.filter {$0.isKeyWindow}.count)
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            Appodeal.showAd(.rewardedVideo,
                              forPlacement: placement,
                              rootViewController: topController)
    
}
}

//final class Interstitial: UIViewController, GADFullScreenContentDelegate{
//    private var interstitial: GADInterstitialAd?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        fetchInterstitial()
//    }
//    func showInterstitial() {
//        if let ad = interstitial {
//            ad.present(fromRootViewController: self)
//        } else {
//            print("Ad wasn't ready")
//        }
//    }
//    /// Tells the delegate that the ad failed to present full screen content.
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("Ad did fail to present full screen content.")
//    }
//    
//    /// Tells the delegate that the ad presented full screen content.
//    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("Ad did present full screen content.")
//    }
//    
//    /// Tells the delegate that the ad dismissed full screen content.
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("Ad did dismiss full screen content.")
//        fetchInterstitial()
//    }
//    
//    func fetchInterstitial() {
//        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//            let request = GADRequest()
//            GADInterstitialAd.load(withAdUnitID: pageAd,
//                                   request: request,
//                                   completionHandler: { [self] ad, error in
//                                    if let error = error {
//                                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                                        return
//                                    }
//                                    interstitial = ad
//                                    interstitial?.fullScreenContentDelegate = self
//                                   }
//            )
//        })
//    }
//    //    var interstitial:GADInterstitial = GADInterstitial(adUnitID: pageAd)
//    //
//    //    override init() {
//    //        super.init()
//    //        LoadInterstitial()
//    //    }
//    //
//    //    func LoadInterstitial(){
//    //        let req = GADRequest()
//    //        self.interstitial.load(req)
//    //        self.interstitial.delegate = self
//    //    }
//    //
//    //    func showAd(){
//    //        if self.interstitial.isReady{
//    //           let root = UIApplication.shared.windows.first?.rootViewController
//    //           self.interstitial.present(fromRootViewController: root!)
//    //        }
//    //       else{
//    //           print("Not Ready")
//    //       }
//    //    }
//    //
//    //    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//    //        self.interstitial = GADInterstitial(adUnitID: pageAd)
//    //        LoadInterstitial()
//    //    }
//    
//}

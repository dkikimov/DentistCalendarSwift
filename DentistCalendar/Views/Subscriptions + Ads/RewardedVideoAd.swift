//
//  RewardedVideoAd.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.01.2021.
//

import SwiftUI
import GoogleMobileAds
import UIKit
    
final class Rewarded: NSObject, GADFullScreenContentDelegate{
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        
    }
    
    
//    var rewardedAd:GADRewardedAd = GADRewardedAd(adUnitID: videoAd)
//    
//    var rewardFunction: (() -> Void)? = nil
//    
//    override init() {
//        super.init()
//        LoadRewarded()
//    }
//    
//    func LoadRewarded(){
//        let req = GADRequest()
//        self.rewardedAd.load(req)
//    }
//    
//    func showAd(rewardFunction: @escaping () -> Void){
//        if self.rewardedAd.isReady{
//            self.rewardFunction = rewardFunction
//            print("WINDOWS", UIApplication.shared.windows)
//            let root = UIApplication.shared.windows.first?.rootViewController
//            self.rewardedAd.present(fromRootViewController: root!, delegate: self)
//        }
//       else{
//           print("Not Ready")
//       }
//    }
//    
//    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
//        if let rf = rewardFunction {
//            rf()
//        }
//    }
//    
//    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
//        self.rewardedAd = GADRewardedAd(adUnitID: videoAd)
//        LoadRewarded()
//    }
}

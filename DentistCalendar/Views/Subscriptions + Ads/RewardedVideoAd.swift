//
//  RewardedVideoAd.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.01.2021.
//

import SwiftUI
import GoogleMobileAds
import UIKit
import Appodeal

class RewardedVideoViewController: UIViewController {
    var placement: String
    var isPresented: Binding<Bool>

    var rewardFunction: (() -> Void)
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Appodeal.setRewardedVideoDelegate(self)
    }
    
    // MARK: Actions
    init(placement: String,  isPresented: Binding<Bool>, rewardFunction: @escaping (() -> Void)) {
        self.placement = placement
        self.isPresented = isPresented
        self.rewardFunction = rewardFunction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }
    
}
struct Rewarded: UIViewControllerRepresentable {
    var placement: String
    @Binding var isPresented: Bool
    var rewardFunction: (() -> Void)
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = RewardedVideoViewController(placement: placement, isPresented: $isPresented, rewardFunction: rewardFunction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.showAd(from: view)
        }
        
        return view
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func showAd(from root: UIViewController) {
        guard
            Appodeal.isInitalized(for: .rewardedVideo),
            Appodeal.canShow(.rewardedVideo, forPlacement: placement)
        else {
            isPresented = false
            rewardFunction()
            return
        }
        Appodeal.showAd(.rewardedVideo,
                        forPlacement: placement,
                        rootViewController: root)
    }
}
extension RewardedVideoViewController: AppodealRewardedVideoDelegate {
    func rewardedVideoDidLoadAdIsPrecache(_ precache: Bool) {}
    func rewardedVideoDidFailToLoadAd() {
        DispatchQueue.main.async {
        self.isPresented.wrappedValue = false
        self.rewardFunction()
        }

    }
    func rewardedVideoDidFailToPresentWithError(_ error: Error) {
        DispatchQueue.main.async {
        self.isPresented.wrappedValue = false
        self.rewardFunction()
        }
    }
    func rewardedVideoDidPresent() {}
    func rewardedVideoWillDismissAndWasFullyWatched(_ wasFullyWatched: Bool) {
        DispatchQueue.main.async {
        self.isPresented.wrappedValue = false
        self.rewardFunction()
        }
    }
    func rewardedVideoDidFinish(_ rewardAmount: float_t, name rewardName: String?) {
        DispatchQueue.main.async {
        self.isPresented.wrappedValue = false
        self.rewardFunction()
        }
//        self.isModalPresented.wrappedValue = false

    }
}


struct FullScreenModifier<Parent: View>: View {
    @Binding var isPresented: Bool
    var rewardFunc: () -> Void
    var placement: String
    var parent: Parent
    
    var body: some View {
        ZStack {
            parent
            
            if isPresented {
//                RewardedAdView(isPresented: $isPresented, adUnitId: adUnitId, rewardFunc: rewardFunc)
                Rewarded(placement: placement, isPresented: $isPresented, rewardFunction: rewardFunc)
//                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
extension View {
    public func presentRewardedAd(isPresented: Binding<Bool>, placement: String, rewardFunc: @escaping (() -> Void)) -> some View {
        FullScreenModifier(isPresented: isPresented, rewardFunc: rewardFunc, placement: placement, parent: self)
    }
    
}
//
//final class RewardedViewController: UIViewController, AppodealRewardedVideoDelegate {
//
//}
//
//
//func showRewarded(placement: String) {
//    guard
//       Appodeal.isInitalized(for: .rewardedVideo),
//       Appodeal.canShow(.rewardedVideo, forPlacement: placement)
//   else {
//       print("AD NOT READY")
//       return
//   }
//       let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//   //            print("WINDOWS COUNT", UIApplication.shared.windows.filter {$0.isKeyWindow}.count)
//       if var topController = keyWindow?.rootViewController {
//           while let presentedViewController = topController.presentedViewController {
//               topController = presentedViewController
//           }
//           Appodeal.showAd(.rewardedVideo,
//                             forPlacement: placement,
//                             rootViewController: topController)
//
//}
//}
//
//final class Rewarded: NSObject, GADFullScreenContentDelegate {
//    
//    var rewardedAd: GADRewardedAd?
//    
//    override init() {
//        super.init()
//        LoadRewarded()
//    }
//    func LoadRewarded() {
//    let req = GADRequest()
//        GADRewardedAd.load(withAdUnitID: videoAd, request: req) { rewardedAd, err in
//            if let err = err {
//                print("Failed to load ad with error: \(err)")
//                return
//            }
//            
//            self.rewardedAd = rewardedAd
//            self.rewardedAd?.fullScreenContentDelegate = self
//        }
//    }
//    
//    func showAd(rewardFunction: @escaping () -> Void) {
//        
//        if let ad = rewardedAd {
//            guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
//            
//            ad.present(fromRootViewController: rootVC) {
//                rewardFunction()
//            }
//        } else {
//            print("Ad not ready")
//        }
//    }
//    
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        LoadRewarded()
//        
//        //Dissmiss VCs from here if needed
//    }
//}
////
//////final class Rewarded: NSObject, GADFullScreenContentDelegate {
//////
//////    var rewardedAd: GADRewardedAd?
//////
//////    var rewardFunction: (() -> Void)? = nil
//////
//////    override init() {
//////        super.init()
//////        LoadRewarded()
//////    }
//////
//////    func LoadRewarded(){
//////        let request = GADRequest()
//////          GADRewardedAd.load(withAdUnitID: videoAd,
//////                                  request: request, completionHandler: { (ad, error) in
//////                                    if let error = error {
//////                                      print("Rewarded ad failed to load with error: \(error.localizedDescription)")
//////                                      return
//////                                    }
//////                                    self.rewardedAd = ad
//////                                    self.rewardedAd?.fullScreenContentDelegate = self
//////                                  }
//////          )
//////    }
//////
//////    func showAd(rewardFunction: @escaping () -> Void){
////////        let root = UIApplication.shared.windows.first?.rootViewController
//////        if let ad = rewardedAd {
//////              ad.present(fromRootViewController: self,
//////                       userDidEarnRewardHandler: {
//////                            let reward = ad.adReward
//////                            rewardFunction()
//////                       }
//////              )
//////          } else {
//////            print("Ad wasn't ready")
//////          }
//////    }
//////
//////    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
//////        if let rf = rewardFunction {
//////            rf()
//////        }
//////    }
//////}
////
////final class Rewarded: UIViewController, GADFullScreenContentDelegate {
////    var rewardedAd: GADRewardedAd?
////    var rewardFunction: (() -> Void)? = nil
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
//////        sendPrivacyRequest()
////        loadRewardedAd()
////    }
////
////    func loadRewardedAd() {
////        let request = GADRequest()
////        GADRewardedAd.load(withAdUnitID: videoAd,
////                           request: request, completionHandler: { (ad, error) in
////                            if let error = error {
////                                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
////                                return
////                            }
////                            self.rewardedAd = ad
////                            self.rewardedAd?.fullScreenContentDelegate = self
////                           }
////        )
////    }
////
////    func sendPrivacyRequest() {
////        if #available(iOS 14.5, *) {
//////            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
////                self.loadRewardedAd()
//////            })
////        } else {
////            self.loadRewardedAd()
////        }
////
////    }
////
////    func showRewardedAd() {
////        if let ad = rewardedAd {
////            ad.present(fromRootViewController: self,
////                       userDidEarnRewardHandler: {
////                        if let rf = self.rewardFunction {
////                            rf()
////                        }
////                       })
////        } else {
////            print("Ad wasn't ready")
////        }
////    }
////        func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
////            sendPrivacyRequest()
////        }
////    //    var rewardedAd:GADRewardedAd = GADRewardedAd(adUnitID: videoAd)
////    //
////    //    var rewardFunction: (() -> Void)? = nil
////    //
////    //    override init() {
////    //        super.init()
////    //        LoadRewarded()
////    //    }
////    //
////    //    func LoadRewarded(){
////    //        let req = GADRequest()
////    //        self.rewardedAd.load(req)
////    //    }
////    //
////    //    func showAd(rewardFunction: @escaping () -> Void){
////    //        if self.rewardedAd.isReady{
////    //            self.rewardFunction = rewardFunction
////    //            print("WINDOWS", UIApplication.shared.windows)
////    //            let root = UIApplication.shared.windows.first?.rootViewController
////    //            self.rewardedAd.present(fromRootViewController: root!, delegate: self)
////    //        }
////    //       else{
////    //           print("Not Ready")
////    //       }
////    //    }
////    //
////    //    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
////    //        if let rf = rewardFunction {
////    //            rf()
////    //        }
////    //    }
////    //
////    //    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
////    //        self.rewardedAd = GADRewardedAd(adUnitID: videoAd)
////    //        LoadRewarded()
////    //    }
////}

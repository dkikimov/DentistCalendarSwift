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
    override func viewDidLoad() {
        super.viewDidLoad()
        Appodeal.setRewardedVideoDelegate(self)
    }
    
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
                Rewarded(placement: placement, isPresented: $isPresented, rewardFunction: rewardFunc)
            }
        }
    }
}
extension View {
    public func presentRewardedAd(isPresented: Binding<Bool>, placement: String, rewardFunc: @escaping (() -> Void)) -> some View {
        FullScreenModifier(isPresented: isPresented, rewardFunc: rewardFunc, placement: placement, parent: self)
    }
    
}

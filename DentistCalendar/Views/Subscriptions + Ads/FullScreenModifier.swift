////
////  FullScreenModifier.swift
////  SwiftUIMobileAds
////
////  Created by Patrick Haertel on 5/23/21.
////
//
//import SwiftUI
//
//struct FullScreenModifier<Parent: View>: View {
//    @Binding var isPresented: Bool
//    @Binding var isModalPresented: Bool
//    @Binding var wasRewardedVideoChecked: Bool
//    @State var adType: AdType
//    
//    enum AdType {
//        case interstitial
//        case rewarded
//    }
//    
//    var rewardFunc: () -> Void
//    var parent: Parent
//    
//    var body: some View {
//        ZStack {
//            parent
//            
//            if isPresented {
//                EmptyView()
//                    .edgesIgnoringSafeArea(.all)
//                
//                if adType == .rewarded {
//                    RewardedAdView(isPresented: $isPresented, isModalPresented: $isModalPresented, wasRewardedVideoChecked: $wasRewardedVideoChecked, adUnitId: videoAd, rewardFunc: rewardFunc)
//                        .edgesIgnoringSafeArea(.all)
//                } else if adType == .interstitial {
//                    InterstitialAdView(isPresented: $isPresented, adUnitId: pageAd)
//                }
//            }
//        }
//        .onAppear {
//            if adType == .rewarded {
//                RewardedAd.shared.loadAd(withAdUnitId: videoAd)
//            } else if adType == .interstitial {
//                InterstitialAd.shared.loadAd(withAdUnitId: pageAd)
//            }
//        }
//    }
//}
//
//extension View {
//    public func presentRewardedAd(isPresented: Binding<Bool>, isModalPresented: Binding<Bool>, wasRewardedVideoChecked: Binding<Bool>, rewardFunc: @escaping (() -> Void)) -> some View {
//        FullScreenModifier(isPresented: isPresented, isModalPresented: isModalPresented, wasRewardedVideoChecked: wasRewardedVideoChecked, adType: .rewarded, rewardFunc: rewardFunc,  parent: self)
//    }
//    
//    public func presentInterstitialAd(isPresented: Binding<Bool>) -> some View {
//        FullScreenModifier(isPresented: isPresented, isModalPresented: .constant(false), wasRewardedVideoChecked: .constant(false), adType: .interstitial, rewardFunc: {}, parent: self)
//    }
//}

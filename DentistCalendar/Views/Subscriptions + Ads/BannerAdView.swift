//
//  BannerAdView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.01.2021.
//

import SwiftUI
import UIKit
import Appodeal


//struct Banner: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> some UIViewController {
//        
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        
//    }
//}

func showBanner(placement: String) {
    
        
     guard
        Appodeal.isInitalized(for: .banner),
        Appodeal.canShow(.banner, forPlacement: placement)
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
            Appodeal.showAd(.bannerBottom,
                              forPlacement: placement,
                              rootViewController: topController)
    
}
}
//class BannerViewController: UIViewController {
//    let bannerView = GADBannerView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        bannerView.adUnitID = bannerAd
//        bannerView.rootViewController = self
//        addBannerToView();
//    }
//    func addBannerToView(){
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        
//        NSLayoutConstraint.activate([
//            //align your banner to the bottom of the safe area
//            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            //Center your banner horizontally
//            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//    func getAdaptiveSize() -> GADAdSize {
//        // Step 1 - Determine the view width to use for the ad width.
//        //in this codelab we use the full safe area width
//        var frame: CGRect
//        // Here safe area is taken into account, hence the view frame is used
//        // after the view has been laid out.
//        if #available(iOS 11.0, *) {
//            frame = view.frame.inset(by: view.safeAreaInsets)
//        } else {
//            frame = view.frame
//        }
//        let viewWidth = frame.size.width
//        
//        // Step 2 - Get Adaptive GADAdSize and set the ad view.
//        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
//        return adSize
//    }
//    
//    func loadAdaptiveBannerAd(){
//        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//            
//            self.bannerView.adSize = self.getAdaptiveSize()
//            self.bannerView.load(GADRequest())
//        })
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        loadAdaptiveBannerAd()
//    }
//}
//
//final class BannerVC: UIViewControllerRepresentable  {
//    func makeUIViewController(context: Context) -> UIViewController {
//        BannerViewController()
//    }
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}

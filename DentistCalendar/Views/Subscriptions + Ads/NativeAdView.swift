//
//  NativeAdView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 04.01.2021.
//

import SwiftUI
import GoogleMobileAds
import UIKit

class ViewController: UIViewController {
    
    /// The view that holds the native ad.
    @IBOutlet var nativeAdPlaceholder: UIView!
    
    /// The height constraint applied to the ad view, where necessary.
    var heightConstraint: NSLayoutConstraint?
    
    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!
    
    /// The native ad view that is being presented.
    var nativeAdView: GADUnifiedNativeAdView!
    
    /// The ad unit ID.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? GADUnifiedNativeAdView
        else {
            assert(false, "Could not load nib file for adView")
            return
        }
        
        setAdView(adView)
        refreshAd(nil)
    }
    
    func setAdView(_ adView: GADUnifiedNativeAdView) {
        // Remove the previous ad view.
        //        nativeAdView = adView
        //        nativeAdPlaceholder = UIView()
        //        nativeAdPlaceholder.addSubview(nativeAdView)
        //        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        // Layout constraints for positioning the native ad view to stretch the entire width and height
        //        // of the nativeAdPlaceholder.
        //        let viewDictionary = ["_nativeAdView": nativeAdView!]
        //        nativeAdPlaceholder.addConstraints(
        //          NSLayoutConstraint.constraints(
        //            withVisualFormat: "H:|[_nativeAdView]|",
        //            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        //        )
        //        nativeAdPlaceholder.addConstraints(
        //          NSLayoutConstraint.constraints(
        //            withVisualFormat: "V:|[_nativeAdView]|",
        //            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        //        )
        nativeAdView = adView
        self.view.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[_nativeAdView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_nativeAdView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
    }
    
    // MARK: - Actions
    
    /// Refreshes the native ad.
    @IBAction func refreshAd(_ sender: AnyObject!) {
        adLoader = GADAdLoader(
            adUnitID: nativeAd, rootViewController: self,
            adTypes: [.unifiedNative], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
}


extension ViewController: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("fail")
    }
    
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        
        // Deactivate the height constraint that was set when the previous video ad loaded.
        heightConstraint?.isActive = false
        
        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
            heightConstraint = NSLayoutConstraint(
                item: mediaView,
                attribute: .height,
                relatedBy: .equal,
                toItem: mediaView,
                attribute: .width,
                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                constant: 0)
            heightConstraint?.isActive = true
        }
        
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        nativeAdView.starRatingView?.isHidden = true
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil
        
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
        
    }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension ViewController: GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}

struct NativeAdViewWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let picker = ViewController()
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

struct NativeAdView: View, Identifiable {
    let id = UUID()
    var body: some View {
        VStack {
            NativeAdViewWrapper()
        }
    }
}
//struct NativeAdView: UIViewRepresentable {
//    func makeUIView(context: Context) -> GADUnifiedNativeAdView{
//        let adView = GADUnifiedNativeAdView()
//
//        adView.id
//    }
//}

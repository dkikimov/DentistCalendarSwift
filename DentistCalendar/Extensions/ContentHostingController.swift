//
//  HostingController.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/26/20.
//


//import UIKit
//import SwiftUI
//
//
//class ContentHostingController: UIHostingController<ContentView> {
//      // 1. We change this variable
//    private var currentStatusBarStyle: UIStatusBarStyle = .default
//      // 2. To change this property of `UIHostingController`
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        currentStatusBarStyle
//    }
//      // 3. A function we can call to change the style programmatically
//    func changeStatusBarStyle(_ style: UIStatusBarStyle) {
//        self.currentStatusBarStyle = style
//          // 4. Required for view to update
//        self.setNeedsStatusBarAppearanceUpdate()
//    }
//}
//
//
//extension UIApplication {
//      // 1. Function that we can call via `UIApplication.setStatusBarStyle(...)`
//    class func setStatusBarStyle(_ style: UIStatusBarStyle) {
//          // Get the root view controller, which we've set to be `ContentHostingController`
//        if let vc = UIApplication.getKeyWindow()?.rootViewController as? ContentHostingController {
//                 // Call the method we've defined
//            vc.changeStatusBarStyle(style)
//        }
//    }
//      // 2. Helper function to get the key window
//    private class func getKeyWindow() -> UIWindow? {
//        return UIApplication.shared.windows.first{ $0.isKeyWindow }
//    }
//}
//
//

import SwiftUI
import Foundation
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

/** Debouncer class to delay functions that only get delay each other until the timer fires  */
public class Debouncer: NSObject {
    
    /** Callback that is getting called when the timer fires */
    var callback: (() -> Void)?
    
    /** Delay Time in ms */
    let delay: TimeInterval
    
    /** Next Date when the Debouncer will fire */
    var fireDate: Date?{
        get{
            return timer?.fireDate
        }
    }
    
    /** Timer to fire the callback event */
    private var timer: Timer?
    
    
    /** Init with delay time as argument */
    init(delay: TimeInterval){
        self.delay = delay
    }
    
    /** Init with delay time and callback argument */
    init(delay: TimeInterval, callback: @escaping (()->Void)){
        self.delay = delay
        self.callback = callback
    }
    
    /** Call debouncer to start the callback after the delayed time. Multiple calls will ignore the older calls and overwrite the firing time */
    func call(){
        // Cancle timer, if already running
        timer?.invalidate()
        // Reset timer to fire next event
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(fireCallback), userInfo: nil, repeats: false)
    }
    
    /** Function to fire the fallback, if it was set */
    @objc private func fireCallback(_ timer: Timer) {
        if callback == nil {
            NSLog("Debouncer timer fired, but callback was not set")
        }
        callback?()
    }
}

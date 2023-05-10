//
//  HostingController.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/26/20.
//

import SwiftUI
import Foundation
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

public class Debouncer: NSObject {
    
    var callback: (() -> Void)?
    
    let delay: TimeInterval
    
    var fireDate: Date?{
        get{
            return timer?.fireDate
        }
    }
    
    private var timer: Timer?
    
    init(delay: TimeInterval){
        self.delay = delay
    }
    
    init(delay: TimeInterval, callback: @escaping (()->Void)){
        self.delay = delay
        self.callback = callback
    }
    
    func call(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(fireCallback), userInfo: nil, repeats: false)
    }
    
    @objc private func fireCallback(_ timer: Timer) {
        if callback == nil {
            NSLog("Debouncer timer fired, but callback was not set")
        }
        callback?()
    }
}


struct MbModalHackView: UIViewControllerRepresentable {
    var dismissable: () -> Bool = { false }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MbModalHackView>) -> UIViewController {
        MbModalViewController(dismissable: self.dismissable)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

extension MbModalHackView {
    private final class MbModalViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
        let dismissable: () -> Bool
        
        init(dismissable: @escaping () -> Bool) {
            self.dismissable = dismissable
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            
            setup()
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            dismissable()
        }
        
        private func setup() {
            guard let rootPresentationViewController = self.rootParent.presentationController, rootPresentationViewController.delegate == nil else { return }
            rootPresentationViewController.delegate = self
        }
    }
}

extension UIViewController {
    fileprivate var rootParent: UIViewController {
        if let parent = self.parent {
            return parent.rootParent
        }
        else {
            return self
        }
    }
}

extension View {
    public func allowAutoDismiss(_ dismissable: @escaping () -> Bool) -> some View {
        self
            .background(MbModalHackView(dismissable: dismissable))
    }
    
    public func allowAutoDismiss(_ dismissable: Bool) -> some View {
        self
            .background(MbModalHackView(dismissable: { dismissable }))
    }
}

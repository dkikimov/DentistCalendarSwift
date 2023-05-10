//
//  NavigationBarColor.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 9/26/20.
//
import SwiftUI
import UIKit
import SwiftUIX

struct NavigationBarColor: ViewModifier {
    
    init(backgroundColor: UIColor, tintColor: UIColor, shadowColor: UIColor?, buttonsColor: UIColor?) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
        let scrollAppearance = coloredAppearance.copy()
        
        if shadowColor != nil {
            scrollAppearance.shadowColor = shadowColor!
        }
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = scrollAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        if buttonsColor != nil {
            UINavigationBar.appearance().tintColor = buttonsColor!
        } else {
            UINavigationBar.appearance().tintColor = tintColor
        }
    }
    
    func body(content: Content) -> some View {
        content
    }
}

func setNavigationBarColor(backgroundColor: UIColor, tintColor: UIColor) {
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithOpaqueBackground()
    
    coloredAppearance.backgroundColor = backgroundColor
    coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = tintColor
}

extension View {
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor, shadowColor: UIColor? = nil, buttonsColor: UIColor? = nil) -> some View {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor, shadowColor: shadowColor, buttonsColor: buttonsColor))
    }
}


extension UserDefaults {
    
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
    
}



struct NavigationConfigurator: UIViewControllerRepresentable {
    
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}


struct ModalView<T: View>: UIViewControllerRepresentable {
    let view: T
    @State var isModal: Bool
    let onDismissalAttempt: (()->())?
    
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: view)
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
        uiViewController.parent?.presentationController?.delegate = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        let modalView: ModalView
        
        init(_ modalView: ModalView) {
            self.modalView = modalView
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            !modalView.isModal
        }
        
        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            modalView.onDismissalAttempt?()
        }
    }
}

extension View {
    func presentation(isModal: Bool, onDismissalAttempt: (()->())? = nil) -> some View {
        ModalView(view: self, isModal: isModal, onDismissalAttempt: onDismissalAttempt)
    }
}

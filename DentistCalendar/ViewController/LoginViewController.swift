//
//  LoginViewController.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 10/18/20.
//

import UIKit

import SwiftUI

class LoginViewController: UIViewController {
    fileprivate let contentViewInHC = UIHostingController(rootView: LoginView())
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHC()
    }
    
    fileprivate func setupHC() {
        addChild(contentViewInHC)
        view.addSubview(contentViewInHC.view)
        contentViewInHC.didMove(toParent: self)
    }
}

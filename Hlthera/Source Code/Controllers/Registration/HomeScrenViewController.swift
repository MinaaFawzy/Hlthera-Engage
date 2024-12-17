//
//  HomeScrenViewController.swift
//  Hlthera
//
//  Created by Fluper on 13/11/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

class HomeScrenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogouttapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        LoginManager().logOut()
        kSharedAppDelegate?.logout()
        //apple
        
        
    }
}

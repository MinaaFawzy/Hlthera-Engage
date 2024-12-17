//
//  WebViewVC.swift
//  Hlthera
//
//  Created by fluper on 15/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import WebKit
class WebViewVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var pageTitleString = "".localize
    var url = "https://www.google.com"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.pageTitle.text = pageTitleString
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction func buttonBackTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}

//
//  TermsAndConditionsVC.swift
//  Hlthera
//
//  Created by Ahmed Hegazy on 17/01/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit
import WebKit


class TermsAndConditionsVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var html = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(html, baseURL: nil)
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
    }

    //MARK: - Actions
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

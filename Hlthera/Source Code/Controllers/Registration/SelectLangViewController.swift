//
//  SelectLangViewController.swift
//  Hlthera
//
//  Created by Akash on 23/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class SelectLangViewController: UIViewController {
    //MARK: - @IBOutlets
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK:- Functions
    
    //MARK:- @IBAction
    @IBAction func btnEnglishTapped(_ sender: UIButton) {
        
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: "WalkthroughViewController") as? WalkthroughViewController else {return}
//        self.navigationController?.pushViewController(vc, animated: true)
        
                    guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else {return}

        
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc2) as? LoginVc2 else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func btnArabicTapped(_ sender: UIButton) {
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: "WalkthroughViewController") as? WalkthroughViewController else {return}
//        self.navigationController?.pushViewController(vc, animated: true)
        
                    guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else {return}

        
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc2) as? LoginVc2 else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
}

//
//  LikeUnlikeVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 06/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class LikeUnlikeVC: UIViewController {

    var yesCallback:(()->())?
    var noCallback:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonYesTapped(_ sender: Any) {
        self.dismiss(animated: true){
            self.yesCallback?()
        }
        
    }
    @IBAction func buttonNoTapped(_ sender: Any) {
        self.dismiss(animated: true){
            self.noCallback?()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SplashScreenViewController.swift
//  Hlthera
//
//  Created by Akash on 27/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import SwiftyGif
import AVKit
import AVFoundation

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var splashContainerView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        playVideo()
        delayAndGoToScreen()
    }
    
    private func playVideo() {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "splash_vide", ofType: "mp4")!))
        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        player.volume = 0
        player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashContainerView.backgroundColor = .clear
        //    do {
        //        let gif = try UIImage(gifName: "splash.gif")
        //        DispatchQueue.main.async {
        //            let imageview = UIImageView(gifImage: gif, loopCount: 1) //Use -1 for infinite loop
        //            imageview.contentMode = .scaleAspectFill
        //            imageview.frame = self.splashContainerView.bounds
        //            self.splashContainerView.addSubview(imageview)
        //        }
        //    } catch {
        //        print(error)
        //    }
        
        
        //      delayAndGoToScreen()
        
    }
    
    private func delayAndGoToScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) {
            
            if kSharedUserDefaults.isAppInstalled(){
                if kSharedUserDefaults.isUserLoggedIn() {
                    kSharedAppDelegate?.moveToLocationPermissionsScreen()
                    
                } else {
                    kSharedAppDelegate?.moveToWalkthrough()
                }
                
            } else {
                guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kSelectLangVc) as? SelectLangViewController else {return}
                self.navigationController?.pushViewController(nextVc, animated: true)
            }
            
        }
    }
    
}

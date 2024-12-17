//
//  AppController.swift
//  HaalloApp
//
//  Created by Varun on 16/09/19.
//  Copyright © 2019 fluper. All rights reserved.
//

import UIKit
import AVFoundation

class AppController: NSObject {
    ///Audio player responsible for playing sound files.
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    ///User's bookmarked sound files.
    var bookmarkedFiles: [String] = []
    
    ///User defaults
    var userDefaults: UserDefaults = UserDefaults.standard
    class func sharedInstance() -> AppController {
        return appControllerSingletonGlobal
    }
}

///Model singleton so that we can refer to this from throughout the app.
let appControllerSingletonGlobal = AppController()

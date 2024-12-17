//
//  VideoPickerHelper.swift
//  Agafos
//
//  Created by Shubham Kaliyar on 12/10/17.
//  Copyright © 2017 Tahir. All rights reserved.
//


var PickerVideoCallBack:PickerVideo = nil
typealias PickerVideo = ((URL? , Data?) -> (Void))?
let videoPickerInstanse = VideoPickerHelper.shared

import UIKit
import MobileCoreServices

class VideoPickerHelper: NSObject {
    
    private override init() {
    }
    static var shared : VideoPickerHelper = VideoPickerHelper()
    var picker = UIImagePickerController()
    
    // MARK:- Action Sheet
    func showActionSheet(withTitle title: String?, withAlertMessage message: String?, withOptions options: [String], handler:@escaping (_ selectedIndex: Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for strAction in options {
            let anyAction =  UIAlertAction(title: strAction, style: .default){ (action) -> Void in
                return handler(options.firstIndex(of: strAction)!)
            }
            alert.addAction(anyAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) -> Void in
            return handler(-1)
        }
        alert.addAction(cancelAction)
        presetImagePicker(pickerVC: alert)
        
    }
    
    // MARK: Public Method
    func showVideoController(_ handler:PickerVideo) {
        self.showActionSheet(withTitle: "Choose Option", withAlertMessage: nil, withOptions: ["Take Video", "Open Gallery"]){ ( _ selectedIndex: Int) in
            switch selectedIndex {
            case OpenMediaType.camera.rawValue:
                self.showCamera()
            case OpenMediaType.photoLibrary.rawValue:
                self.openGallery()
            default:
                break
            }
        }
        
        PickerVideoCallBack = handler
    }
    
    
    // MARK:-  Camera
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            picker.videoMaximumDuration = 40
            picker.mediaTypes = [kUTTypeMovie] as [String]
            presetImagePicker(pickerVC: picker)
        } else {
            showAlertMessage.alert(message: "Camera not available.")
        }
        picker.delegate = self
    }
    
    // MARK:-  Gallery
    
    func openGallery() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie] as [String]
        presetImagePicker(pickerVC: picker)
        picker.delegate = self
    }
    
    // MARK:- Show ViewController
    
    private func presetImagePicker(pickerVC: UIViewController) -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController?.present(pickerVC, animated: true, completion: {
            self.picker.delegate = self
        })
    }
    
    fileprivate func dismissViewController() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Picker Delegate
extension VideoPickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
        print("Shubham Kaliyar")
        
        guard let Url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        print(Url.lastPathComponent)
        let videoData = try? Data.init(contentsOf: Url)
        if  Int.getInt( NSData(contentsOf: Url)?.length) < 10485760 {
            PickerVideoCallBack?(Url , videoData)
            dismissViewController()
        } else {
            showAlertMessage.alert(message: "File to be large.")
            dismissViewController()
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissViewController()
    }
}

class VideoData {
    var thumbnilImage:UIImage?
    var videoUrl:URL?
    var videoData:Data?
    var videoTime:Float64?
    init() {  }
    
}

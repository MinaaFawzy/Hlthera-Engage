//
//  ImagePickerHelper.swift
//  Agafos
//
//  Created by Mohammad Tahir on 12/10/17.
//  Copyright © 2017 Tahir. All rights reserved.
//

// MARK:- Permission in Info Plist
/*
 1- For Camera
 
 Key       :  Privacy - Camera Usage Description
 Value     :  $(PRODUCT_NAME) camera use
 
 2- For Gallery
 Key       :  Privacy - Photo Library Usage Description
 Value     :  $(PRODUCT_NAME) photo use
 
 */

var pickerCallBack:PickerImage = nil
typealias PickerImage = ((UIImage?) -> (Void))?

import UIKit

class ImagePickerHelper: NSObject {
    
    private override init() {
    }
    
    static var shared : ImagePickerHelper = ImagePickerHelper()
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
    
    /**
     
     * Public Method for showing ImagePicker Controlller simply get Image
     * Get Image Object
     */
    
    func showPickerController(_ handler:PickerImage) {
        
        self.showActionSheet(withTitle: "Choose Option", withAlertMessage: nil, withOptions: ["Take Picture", "Open Gallery"]){ ( _ selectedIndex: Int) in
            switch selectedIndex {
            case OpenMediaType.camera.rawValue:
                self.showCamera()
            case OpenMediaType.photoLibrary.rawValue:
                self.openGallery()
            default:
                break
            }
        }
        
        pickerCallBack = handler
    }
    
    
    // MARK:-  Camera
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
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
        presetImagePicker(pickerVC: picker)
        picker.delegate = self
    }
    
    // MARK:- Show ViewController
    
    private func presetImagePicker(pickerVC: UIViewController) -> Void {
       // let appDelegate = UIApplication.shared.delegate as! AppDelegate
         UIApplication.shared.windows.first?.rootViewController?.present(pickerVC, animated: true, completion: {
            self.picker.delegate = self
        })
    }
    
    fileprivate func dismissViewController() -> Void {
      //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
         UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK;- func for imageView in swift
    func SaveImage (imageView :UIImage) {
        UIImageWriteToSavedPhotosAlbum(imageView, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            showAlertMessage.alert(message: "Photos not Saved ")
        } else {
             showAlertMessage.alert(message: "Your altered image has been saved to your photos. ")
        }
    }
}


// MARK: - Picker Delegate
extension ImagePickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
      guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        pickerCallBack?(image)
        dismissViewController()
    }
    
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissViewController()
    }
}



class TextFieldMargin: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

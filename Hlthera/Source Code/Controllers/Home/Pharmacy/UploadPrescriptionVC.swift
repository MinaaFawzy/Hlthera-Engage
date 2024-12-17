//
//  UploadPrescriptionVC.swift
//  Hlthera
//
//  Created by fluper on 27/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class UploadPrescriptionVC: UIViewController {
    
    // @IBOutlet var stackImages: [UIImageView]!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelTotalItems: UILabel!
    @IBOutlet weak var collectionViewDocuments: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageDoc: UIImageView!
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    
    var docs: [Any] = []
    var isPrescribed = false
    var totalPrice = ""
    var totalItems = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.labelTotalItems.text = totalItems
        self.labelTotalPrice.text = totalPrice
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonDocumentsTapped(_ sender: Any) {
        selectDocument(type: 0)
    }
    
    @IBAction func buttonCameraTapped(_ sender: Any) {
        selectDocument(type: 1)
    }
    
    @IBAction func buttonGalleryTapped(_ sender: Any) {
        selectDocument(type: 2)
    }
    
    @IBAction func buttonCheckoutTapped(_ sender: Any) {
        if isPrescribed && docs.isEmpty {
            guard let vc = UIStoryboard(name: "Pharmacy", bundle: nil).instantiateViewController(withIdentifier: PrescriptionAlertVC.getStoryboardID()) as? PrescriptionAlertVC else {
                return
            }
            vc.callbackContinue = { type in
                if type == 0{
                    kSharedAppDelegate?.moveToHomeScreen()
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true, completion: nil)
        } else {
            uploadDocsApi()
        }
    }
    
}
extension UploadPrescriptionVC {
    
    func selectDocument(type: Int) {
        switch type {
        case 0:
            showDocumentPicker()
        case 1:
            CommonUtils.imagePickerCamera(viewController: self)
        case 2:
            CommonUtils.imagePickerGallery(viewController: self)
        default:break
        }
    }
    
}

extension UploadPrescriptionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return docs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocsCVC.identifier, for: indexPath) as! DocsCVC
        if docs[indexPath.row] is URL{
            // cell.imageDocument.image = thumbnailFromPdf(withUrl: docs[indexPath.row] as! URL, pageNumber: 0)
        }
        else{
            cell.imageDocument.image = docs[indexPath.row] as! UIImage
        }
        
        cell.removeCallback = {
            self.docs.remove(at: indexPath.row)
            self.collectionViewDocuments.reloadData()
        }
        constraintCollectionViewHeight.constant = self.collectionViewDocuments.contentSize.height
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionViewDocuments.frame.width/4.25,height:collectionViewDocuments.frame.width/4.25)
    }
    
}

class DocsCVC:UICollectionViewCell {
    
    @IBOutlet weak var imageDocument: UIImageView!
    @IBOutlet weak var buttonRemove: UIButton!
    
    var removeCallback: (()->())?
    
    @IBAction func buttonRemoveTapped(_ sender: UIButton) {
        removeCallback?()
    }
    
}

extension UploadPrescriptionVC: UIDocumentPickerDelegate {
    
    func showDocumentPicker() {
        let types: [String] = self.returnAlldoctType()
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .pageSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func returnAlldoctType() -> [String] {
        return ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key", "public.item", "public.content", "public.audiovisual-content",  "public.audiovisual-content",  "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content"]
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pdfUrl = urls.first else { return  }
        let _ = pdfUrl.startAccessingSecurityScopedResource()
        let data = try! Data.init(contentsOf: pdfUrl)
        print(pdfUrl,data)
        if docs.count < 8{
            
            docs.append(pdfUrl)
        }else{
            CommonUtils.showToast(message: "Max Documents upload limit is reached".localize)
            return
        }
        collectionViewDocuments.reloadData()
        //reportsArray.append(pdfUrl)
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UploadPrescriptionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image:UIImage = info[.originalImage] as! UIImage
        if docs.count < 8 {
            self.docs.append(image)
        } else {
            CommonUtils.showToast(message: "Max Documents upload limit is reached".localize)
            return
        }
        collectionViewDocuments.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
extension UploadPrescriptionVC{
    
    func uploadDocsApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var images:[[String:Any]] = []
        var documents:[[String:Any]] = []
        for doc in docs{
            if doc is UIImage{
                images.append(["imageName": "prescription_doc", "image": doc])
            }
            else if doc is URL {
                documents.append(["documentName":"prescription_doc","document":doc])
            }
        }
        
        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.uploadPrescription, method: .post, arrImages: images, video: [:],document: documents,  parameters: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard self != nil else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["result"])
                    let userInfo = kSharedInstance.getDictionary(data["userinfo"])
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.popUpDescription = "E-prescription has been uploaded successfully".localize
                    vc.callback = {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self?.dismiss(animated: true, completion: {
                                UserData.shared.isReschedule = false
                                kSharedAppDelegate?.moveToHomeScreen()
                            }
                            )
                        })
                    }
                    self?.navigationController?.present(vc, animated: true)
                    
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
        
    }
}
extension UploadPrescriptionVC{
    func thumbnailFromPdf(withUrl url:URL, pageNumber:Int, width: CGFloat = 240) -> UIImage? {
        guard let pdf = CGPDFDocument(url as CFURL),
              let page = pdf.page(at: pageNumber)
        else {
            return nil
        }
        
        var pageRect = page.getBoxRect(.mediaBox)
        let pdfScale = width / pageRect.size.width
        pageRect.size = CGSize(width: pageRect.size.width*pdfScale, height: pageRect.size.height*pdfScale)
        pageRect.origin = .zero
        
        UIGraphicsBeginImageContext(pageRect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        // White BG
        context.setFillColor(UIColor.white.cgColor)
        context.fill(pageRect)
        context.saveGState()
        // Next 3 lines makes the rotations so that the page look in the right direction
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
        
        context.drawPDFPage(page)
        context.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

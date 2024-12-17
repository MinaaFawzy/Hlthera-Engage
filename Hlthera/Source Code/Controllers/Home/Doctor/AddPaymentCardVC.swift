//
//  AddPaymentCardVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class AddPaymentCardVC: UIViewController {
    @IBOutlet weak var textFieldCard: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textFieldExpiryDate: UITextField!
    @IBOutlet weak var textFieldCVV: UITextField!
    
    @IBOutlet weak var labelCardEndsWith: UILabel!
    @IBOutlet weak var imageCardBrand: UIImageView!
    @IBOutlet weak var buttonSaveCard: UIButton!
    
    let datePickerView = UIDatePicker()
    
    var callback:((String,String,String,String)->()) = {_,_,_,_ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
        
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupDatePicker()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupDatePicker(){
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        self.datePickerView.datePickerMode = .date
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = 100
        self.datePickerView.maximumDate = calendar.date(byAdding: dateComponents, to: Date())
        let minDate = Date()
        self.datePickerView.minimumDate = minDate
        self.textFieldExpiryDate.inputView = self.datePickerView
        self.textFieldExpiryDate.inputAccessoryView = self.getToolBar()
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    //MARK: Function for Date Of Birth
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done".localize, style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localize, style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    @objc func doneClick(for:Int) {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        self.textFieldExpiryDate.text = dateFormatter.string(from: self.datePickerView.date)
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSaveCardTapped(_ sender: UIButton) {
        if String.getString(textFieldCard.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Card Number".localize)
            return
        }
        if String.getString(textFieldName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Name".localize)
            return
        }
        if String.getString(textFieldExpiryDate.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Card Number".localize)
            return
        }
        if String.getString(textFieldCVV.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Card Number".localize)
            return
        }
        saveCardApi()
    }
    
}
extension AddPaymentCardVC{
    func saveCardApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.card_number:
                                        String.getString(textFieldCard.text), ApiParameters.card_name:String.getString(textFieldName.text),
                                     ApiParameters.expiry_date:String.getString(textFieldExpiryDate.text),
                                     ApiParameters.cvv:String.getString(textFieldCVV.text)]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.savedCards,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.popUpDescription = "Card Saved Successfully!".localize
                    vc.callback = {
                        
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                self?.dismiss(animated: true, completion: {
                                    self?.navigationController?.popViewController(animated: true)
                                }
                            )
                        })
                    }
                    self?.navigationController?.present(vc, animated: true)
                    
                   
                    
                default:
                    
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    return
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

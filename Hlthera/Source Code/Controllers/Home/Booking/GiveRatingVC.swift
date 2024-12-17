//
//  GiveRatingVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 09/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import Cosmos


class GiveRatingVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var hospitalLogo: UIImageView!
    @IBOutlet var buttonsEmoji: [UIButton]!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var buttonUserName: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var buttonAnonymous: UIButton!
    @IBOutlet var buttonsNavigation: [UIButton]!
    @IBOutlet weak var healerView: UIView!
    @IBOutlet weak var anonymousUserView: UIView!
    @IBOutlet weak var rateAndReviewLabel: UILabel!
    
    @IBOutlet weak var normalUserView: UIView!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var specialityNameLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorProfilePicture: UIImageView!
    
    @IBOutlet weak var hospitalNameStackView: UIStackView!
    @IBOutlet weak var ratingViewD: UIView!
    var doctorRating = "0.0"
    var hospitalRating = "0.0"
    var doctorRatingType = "username"
    var hospitalRatingType = "username"
    var doctorEmoji: Int?
    var hospitalEmoji: Int?
    var doctorText: String = ""
    var hospitalText: String = ""
    
    //var data: BookingDataModel?
    var data: ResultOnGoingSearch?
    var ratingFor: String = "Doctor"
    var hasCameFrom: HasCameFrom?
    var productId = ""
    
    lazy var doctorRatingView: CosmosView = {
        var view = CosmosView()
        view.settings.totalStars = 5
        view.settings.starSize = 17
        view.settings.fillMode = .full
        return view
    }()
    lazy var hospitalRatingView: CosmosView = {
        var view = CosmosView()
        view.settings.totalStars = 5
        view.settings.starSize = 17
        view.settings.fillMode = .full
        return view
    }()
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        lblTitle.font = .corbenRegular(ofSize: 15)
//        buttonUserName.isSelected = true
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setData()
        ratingViewD.addSubview(doctorRatingView)
        ratingViewD.addSubview(hospitalRatingView)
        hospitalRatingView.isHidden = true
        
        doctorRatingView.didTouchCosmos = { numberOfStarsSelected in
            self.doctorRating = String(numberOfStarsSelected)
        }
        hospitalRatingView.didTouchCosmos = { numberOfStarsSelected in
            self.hospitalRating = String(numberOfStarsSelected)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}

// MARK: - Actions
extension GiveRatingVC {
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navigationButtonTapped(_ sender: UIButton) {
        for button in buttonsNavigation {
            if sender == button {
                button.setTitleColor( .white , for: .normal)
                button.backgroundColor = UIColor(named: "5")
            } else {
                button.setTitleColor( UIColor(named: "4") , for: .normal)
                button.backgroundColor = UIColor(named: "10")
            }
            if sender == buttonsNavigation[0] {
                ratingFor = "Doctor"
                setData()
                hospitalRatingView.isHidden = true
                doctorRatingView.isHidden = false
                if doctorRatingType == "username" {
                    normalUser()
                } else {
                    anonymousUser()
                }
                for x in 0 ..< buttonsEmoji.count {
                    if x == doctorEmoji {
                        buttonsEmoji[x].backgroundColor = UIColor(named: "1")
                    } else {
                        buttonsEmoji[x].backgroundColor = .white
                    }
                }
                hospitalText = textView.text
                textView.text = doctorText
            } else {
                ratingFor = "Hospital"
                setData()
                doctorRatingView.isHidden = true
                hospitalRatingView.isHidden = false
                if hospitalRatingType == "username" {
                    normalUser()
                } else {
                    anonymousUser()
                }
                for x in 0 ..< buttonsEmoji.count {
                    if x == hospitalEmoji {
                        buttonsEmoji[x].backgroundColor = UIColor(named: "1")
                    } else {
                        buttonsEmoji[x].backgroundColor = .white
                    }
                }
                doctorText = textView.text
                textView.text = hospitalText
            }
        }
    }
    
    @IBAction private func buttonAnonymouseTapped(_ sender: Any) {
        if ratingFor == "Doctor" {
            anonymousUser()
            doctorRatingType = "anonymous"
        } else {
            anonymousUser()
            hospitalRatingType = "anonymous"
        }
    }
    func anonymousUser() {
        buttonAnonymous.tintColor = UIColor(named: "5")
        buttonAnonymous.setTitleColor(UIColor(named: "5"), for: .normal)
        anonymousUserView.backgroundColor = UIColor().hexStringToUIColor(hex: "#CBE4FA")
        buttonUserName.tintColor = UIColor(named: "4")
        buttonUserName.setTitleColor(UIColor(named: "4"), for: .normal)
        normalUserView.backgroundColor = UIColor(named: "10")
    }
    
    @IBAction private func buttonUsernameTapped(_ sender: Any) {
        if ratingFor == "Doctor" {
            normalUser()
            doctorRatingType = "username"
        } else {
            normalUser()
            hospitalRatingType = "username"
        }
        
    }
    func normalUser() {
        buttonAnonymous.tintColor = UIColor(named: "4")
        buttonAnonymous.setTitleColor(UIColor(named: "4"), for: .normal)
        anonymousUserView.backgroundColor = UIColor(named: "10")
        buttonUserName.tintColor = UIColor(named: "5")
        buttonUserName.setTitleColor(UIColor(named: "5"), for: .normal)
        normalUserView.backgroundColor = UIColor().hexStringToUIColor(hex: "#CBE4FA")
    }
    
    @IBAction private func buttonSubmitTapped(_ sender: Any) {
        if ratingFor == "Doctor" {
            doctorText = textView.text
        } else {
            hospitalText = textView.text
        }
        if doctorRating != "0.0" && hospitalRating != "0.0" && doctorText != "" && hospitalText != ""{
            sendRatingApi(kType: "Doctor")
            sendRatingApi(kType: "hospital")
        } else {
            guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
            vc.popUpDescription = "You have to give rate and comment to Healer and Health center"
            vc.hideImage = true
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.callback = {
                self.dismiss(animated: true)
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    @IBAction func emojiButtonTapped(_ sender: Any) {
        if ratingFor == "Doctor" {
            for x in 0 ..< buttonsEmoji.count {
                if buttonsEmoji[x].isTouchInside {
                    buttonsEmoji[x].backgroundColor = UIColor(named: "1")
                    doctorEmoji = x
                } else {
                    buttonsEmoji[x].backgroundColor = .white
                }
            }
        } else {
            for x in 0 ..< buttonsEmoji.count {
                if buttonsEmoji[x].isTouchInside {
                    buttonsEmoji[x].backgroundColor = UIColor(named: "1")
                    hospitalEmoji = x
                } else {
                    buttonsEmoji[x].backgroundColor = .white
                }
            }
        }
    }
}
//MARK: - Methed
extension GiveRatingVC {
    func setData(){
        if ratingFor == "Doctor" {
//            infoView.frame = CGRectMake(infoView.frame.origin.x, infoView.frame.origin.y, infoView.frame.size.width, 120)
            specialityNameLabel.isHidden = false
            hospitalNameStackView.isHidden = false
            doctorNameLabel.text = data?.doctor?.name?.localize ?? "Unknown doctor name".localize
            specialityNameLabel.text = data?.doctorSpecialities?.specialities?.localize ?? "Unknown Speciality".localize
            hospitalNameLabel.text = data?.hospital?.name.localize ?? "Unknown hospital name".localize
            doctorProfilePicture.sd_setImage(with: .init(string: "\(data?.doctor?.profilePicture ?? "")"), placeholderImage: UIImage(named: "no_data_image"))
            doctorProfilePicture.layer.cornerRadius = 45
            
        } else {
//            infoView.frame = CGRectMake(infoView.frame.origin.x, infoView.frame.origin.y, infoView.frame.size.width, 70)
            doctorNameLabel.text = data?.hospital?.name.localize ?? "Unknown hospital name".localize
            specialityNameLabel.isHidden = true
            hospitalNameStackView.isHidden = true
            doctorProfilePicture.sd_setImage(with: .init(string: "\(data?.hospital?.profilePicture ?? "")"), placeholderImage: UIImage(named: "no_data_image"))
            doctorProfilePicture.layer.cornerRadius = 15

            
        }
    }
}

extension GiveRatingVC {
    func sendRatingApi(kType: String) {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String : Any] = [:]
        if hasCameFrom == .pharmacy {
            params = [
                ApiParameters.rating: hospitalRating,
                ApiParameters.product_id: String.getString(productId),
                ApiParameters.comment: String.getString(textView.text),
                ApiParameters.rating_type: hospitalRatingType
            ]
        } else {
            if kType == "Doctor" {
                params =  [
                    ApiParameters.rating_type: doctorRatingType,
                    ApiParameters.ratings: doctorRating,
                    ApiParameters.doctor_id: String.getString(data?.doctorID),
                    ApiParameters.comments: String.getString(doctorText),
                    ApiParameters.booking_id: String.getString(data?.id ?? 1000),
//                    ApiParameters.kType: String.getString(UserData.shared.hospital_id).isEmpty ? "doctor" : "hospital",
                    ApiParameters.kType : "doctor",
                    ApiParameters.hospital_id: String.getString(data?.hospitalID)
                ]
            }  else {
                params =  [
                    ApiParameters.rating_type: hospitalRatingType,
                    ApiParameters.ratings: hospitalRating,
                    ApiParameters.doctor_id: "",
                    ApiParameters.comments: String.getString(hospitalText),
                    ApiParameters.booking_id: String.getString(data?.id ?? 1000),
                    ApiParameters.kType : "hospital",
                    ApiParameters.hospital_id: String.getString(data?.hospitalID) 
                ]
            }
        }
        //"http://62.210.203.134/hlthera_backend/api/user/add-rating"
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: "add-rating",
                                                   requestMethod: .POST,
                                                   requestParameters: params,
                                                   withProgressHUD: false
        ) { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0 {
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                        vc.popUpDescription = "Rating Submitted Successfully!"
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.callback = {
                            if self?.hasCameFrom == .pharmacy {
                                kSharedAppDelegate?.moveToHomeScreen()
                            } else {
                                guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: LikeUnlikeVC.getStoryboardID()) as? LikeUnlikeVC else { return }
                                vc.yesCallback = {
                                    
                                    guard let vc = UIStoryboard(name: Storyboards.kOrders, bundle: nil).instantiateViewController(withIdentifier: SurveyVC.getStoryboardID()) as? SurveyVC else { return }
                                    vc.data  = self?.data
                                    self?.navigationController?.pushViewController(vc, animated: true)
                                    
                                }
                                vc.noCallback = {
                                    self?.navigationController?.popViewController(animated: true)
                                }
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .overFullScreen
                                self?.navigationController?.present(vc, animated: true)
                            }
                        }
                        self?.navigationController?.present(vc, animated: true)
                    }
                    else{
                        CommonUtils.showToast(message: String.getString(dictResult["message"]))
                    }
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

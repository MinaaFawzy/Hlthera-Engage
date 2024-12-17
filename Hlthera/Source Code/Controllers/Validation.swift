//
//  Validation.swift
//  Hlthera
//
//  Created by Fluper on 28/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LoginVC VALIDATIONS
extension LoginVC {
    func validationField() {
        if String.getString(self.emailTf.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEnterEmailOrMobile)
            return
        } else if (emailTf.text?.isNumber())! {
            showAlertMessage.alert(message: Notifications.kEnterValidMobileNumber)
        } else if emailTf.text?.isEmail() == false {
            showAlertMessage.alert(message: Notifications.kEnterValidEmailId)
        } else if String.getString(self.passwordTf.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kPasswordRange)
            return
        } else if String.getString(self.passwordTf.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kEnterPassword)
            return
        }
        self.view.endEditing(true)
    }
}

// MARK: - SignUp VALIDATIONS
extension SignUpViewController {
    func validationField() {
        if String.getString(self.firstNameTF.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEnterFirstName)
            return
        } else if String.getString(self.mobileNoTF.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEnterMobileNumber)
            return
        } else if !String.getString(self.mobileNoTF.text).isPhoneNumber(){
            showAlertMessage.alert(message: Notifications.kEnterValidMobileNumber)
            return
        } else if String.getString(self.mobileNoTF.text).count < 7 ||  String.getString(self.mobileNoTF.text).count > 13 {
            showAlertMessage.alert(message: Notifications.kEnterValidMobileNumber)
            return
        } else if String.getString(self.emailTF.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEmailId)
            return
        } else if self.emailTF.text?.isEmail() == false {
            showAlertMessage.alert(message: Notifications.kEnterValidEmailId)
            return
        } else if String.getString(self.passwordTF.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEnterPassword)
            return
        } else if String.getString(self.passwordTF.text).count < 8 ||  String.getString(self.passwordTF.text).count > 32 {
            showAlertMessage.alert(message: Notifications.kPasswordRange)
            return
        } else if String.getString(self.confirmPasswordTF.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kReEnterPassword)
            return
        } else if passwordTF.text != confirmPasswordTF.text {
            showAlertMessage.alert(message: Notifications.kPasswordMatch)
            return
        } else if !switchTerms.isOn {
            showAlertMessage.alert(message: Notifications.kAcceptCond)
            return
        }
        self.view.endEditing(true)
        signUpApi()
    }
}

//MARK:- SignUp VALIDATIONS
extension SignUpViewController2 {
    func validationField() {
        if String.getString(self.tfFullName.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEnterFullName)
            return
        } else
//        if String.getString(self.tfFirstName.text).isEmpty{
//            showAlertMessage.alert(message: Notifications.kEnterFirstName)
//            return
//        }
//        else
//        if String.getString(self.tfLastName.text).isEmpty{
//            showAlertMessage.alert(message: Notifications.kEnterLastName)
//            return
//        } else
        if String.getString(self.tfMobileNumber.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEnterMobileNumber)
            return
        } else if !String.getString(self.tfMobileNumber.text).isPhoneNumber() {
            showAlertMessage.alert(message: Notifications.kEnterValidMobileNumber)
            return
        } else if String.getString(self.tfMobileNumber.text).count < 7 ||  String.getString(self.tfMobileNumber.text).count > 13 {
            showAlertMessage.alert(message: Notifications.kEnterValidMobileNumber)
            return
        }
//        else if String.getString(self.tfInsuranceCompany.text).isEmpty{
//            showAlertMessage.alert(message: Notifications.kEnterInsuranceCompany)
//            return
//        }
//        else if String.getString(self.tfInsuranceNumber.text).isEmpty{
//            showAlertMessage.alert(message: Notifications.kEnterInsuranceNo)
//            return
//        }
        else if String.getString(self.tfEmail.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEmailId)
            return
        } else if self.tfEmail.text?.isEmail() == false {
            showAlertMessage.alert(message: Notifications.kEnterValidEmailId)
            return
        } else if String.getString(self.tfPassword.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEnterPassword)
            return
        } else if String.getString(self.tfPassword.text).count < 8 ||  String.getString(self.tfPassword.text).count > 32 {
            showAlertMessage.alert(message: Notifications.kPasswordRange)
            return
        } else if String.getString(self.tfConfPassword.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kReEnterPassword)
            return
        } else if tfPassword.text != tfConfPassword.text {
            showAlertMessage.alert(message: Notifications.kPasswordMatch)
            return
        }
//        else if String.getString(self.tfHowDidHereAboutUs.text).isEmpty{
//            showAlertMessage.alert(message: Notifications.kHowDidHearAboutUs)
//            return
//        }
        else if !self.isTermsAccepted{
            showAlertMessage.alert(message: Notifications.kAcceptCond)
            return
        }
        self.view.endEditing(true)
        signUpApi()
    }
}

//MARK:- ResetPass VALIDATIONS
extension ResetPassViewController{
    func validationField(){
        if String.getString(self.newPassTf.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kEnterPassword)
            return
        }else if newPassTf.text?.count < 8 || newPassTf.text?.count > 16{
            showAlertMessage.alert(message: Notifications.kEnterValidPassword)
            return
        }else if String.getString(self.reEnterPassTf.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kEnterPassword)
            return
        }else if newPassTf.text != reEnterPassTf.text{
            showAlertMessage.alert(message: Notifications.kPasswordMatch)
            return
        }
        self.view.endEditing(true)
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else { return }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.pushViewController(nextVc, animated: true)
    }
}

// MARK: - PersonalDetails VALIDATIONS
extension PersonalDetailsViewController {
    func validationField() {
        if String.getString(self.fullNameTF.text).isEmpty {
            showAlertMessage.alert(message: Notifications.kEnterFullName)
            return
        }else if String.getString(self.emailIDTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kEmailId)
            return
        }else if self.emailIDTF.text?.isEmail() == false {
            showAlertMessage.alert(message: Notifications.kEnterValidEmailId)
            return
        }else if String.getString(self.mobileNoTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kEnterMobileNumber)
            return
        }else if !String.getString(self.mobileNoTF.text).isPhoneNumber(){
            showAlertMessage.alert(message: Notifications.kEnterValidMobileNumber)
            return
        }else if String.getString(self.mobileNoTF.text).count < 7 ||  String.getString(self.mobileNoTF.text).count > 13 {
            showAlertMessage.alert(message: Notifications.kEnterValidMobileNumber)
            return
        }else if String.getString(self.DobTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kDob)
            return
        }else if String.getString(self.NationalityTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kNationality)
            return
        }else if String.getString(self.UAEResidenceTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kUaeResident)
            return
        }else if String.getString(self.insuranceNoTF.text).count > 1 && !String.getString(self.insuranceNoTF.text).isSpecialCharactersExcluded(){
            showAlertMessage.alert(message: Notifications.kEnterValidInsuranceNo)
            return
        }
        else if String.getString(self.expirtDateTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kExpiryDate)
            return
        }else if String.getString(self.maritalTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kMaritalStatus)
            return
        }else if String.getString(self.addressTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kAddress)
            return
        }
        self.view.endEditing(true)
        profileScreenApi()
    }
}
//MARK:- PersonalDetails VALIDATIONS
extension MedicalIDViewController {
    func validationField(){
        
        if String.getString(self.weightTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kWeight)
            return
        }else if String.getString(self.heightTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kHeight)
            return
        }else if String.getString(self.bloodGroupTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kBloodGroup)
            return
        }
        let emergencyContact = EmergencyContactArray.map{$0.text}
        let emergencyContactRelation = EmergencyContactArray.map{$0.textRelation}
        for number in emergencyContact{
            if String.getString(number).isEmpty{
                showAlertMessage.alert(message: "Please Enter Emergency Contact Number")
                return
            }else if !String.getString(number).isPhoneNumber(){
                showAlertMessage.alert(message: "Please Enter Valid Emergency Contact Number")
                return
            }
        }
        for relation in emergencyContactRelation{
            if String.getString(relation).isEmpty{
                showAlertMessage.alert(message: "Please Select Emergency Contact Relation")
                return
            }
        }
        self.view.endEditing(true)
        medicalApi()
    }
}

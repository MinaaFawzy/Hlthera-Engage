//
//  MedicalDetailsViewController.swift
//  Hlthera
//
//  Created by Akash on 04/11/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class MedicalDetailsViewController: UIViewController {
    //MARK:- IBOUTLETS
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblQuesLeft: UILabel!
    @IBOutlet weak var lblQues: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnAddAn: UIButton!
    var totalNumberOfQuestion:Int?
    var AddSymptoms:addSymptomsEnum = .none
    var selectedButton = 0
    var quesArray = ["Are you allergic to anything ?","Are you taking any medicines at the moments?","Have you have an any medications in the past?","Do you have any chronic illnesses?","Have you had any injuries in the past?","Any past Surgeries?"]
    var addSymptoms = ["Add an allergy","Add an Medications","Add an Medications","Add an illnesses","Add an injury","Add an surgery"]
    
    //MARK:- VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
//        setStatusBar(color: #colorLiteral(red: 0.1215686275, green: 0.2470588235, blue: 0.4078431373, alpha: 1))
        self.btnNext.tag = selectedButton
        self.titleChange(check: self.selectedButton)
        self.lblHeader.text = questionsModel[selectedButton].title
        self.lblQuesLeft.text = "\((totalNumberOfQuestion ?? 0) - (selectedButton + 1))" + "Questions Left".localize
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    //MARK:- Functions
    //MARK:- Switch Case for Symptoms                                                                     
    func titleChange(check:Int){
        self.btnNo.tag = check
        self.lblQues.text = self.quesArray[check]
        self.btnAddAn.setTitle(self.addSymptoms[check], for: .normal)
        self.btnAddAn.tag = check
//        switch check {
//        case 0:
//            self.lblQues.text = self.quesArray[check]
//            self.btnAddAn.setTitle(self.addSymptoms[check], for: .normal)
//            self.btnAddAn.tag = check
//        case 1:
//            self.lblQues.text = self.quesArray[check]
//            self.btnAddAn.setTitle(self.addSymptoms[check], for: .normal)
//            self.btnAddAn.tag = check
//        case 2:
//            self.lblQues.text = self.quesArray[check]
//            self.btnAddAn.setTitle(self.addSymptoms[check], for: .normal)
//            self.btnAddAn.tag = check
//        case 3:
//            self.lblQues.text = self.quesArray[check]
//            self.btnAddAn.setTitle(self.addSymptoms[check], for: .normal)
//            self.btnAddAn.tag = check
//        case 4:
//            self.lblQues.text = self.quesArray[check]
//            self.btnAddAn.setTitle(self.addSymptoms[check], for: .normal)
//            self.btnAddAn.tag = check
//        case 5:
//            self.lblQues.text = self.quesArray[check]
//            self.btnAddAn.setTitle(self.addSymptoms[check], for: .normal)
//            self.btnAddAn.tag = check
//        default:
//            return
//        }
    }
    
    //MARK:- IBACTIONS
    @IBAction func btnBackTapped(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MedicalIDViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    @IBAction func btnNextTapped(_ sender: UIButton) {
        sender.tag += 1
        if sender.tag < self.quesArray.count{
            self.btnNo.tag = sender.tag
            self.lblHeader.text = questionsModel[sender.tag].title
            self.lblQuesLeft.text = "\((totalNumberOfQuestion ?? 0) - (sender.tag + 1))" + "Questions Left".localize
        self.titleChange(check: sender.tag)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btnNoTapped(_ sender: UIButton) {
        sender.tag += 1
        if sender.tag < self.quesArray.count{
            self.btnNext.tag = sender.tag
            self.lblHeader.text = questionsModel[sender.tag].title
            self.lblQuesLeft.text = "\((totalNumberOfQuestion ?? 0) - (sender.tag + 1))" + "Questions Left".localize
        self.titleChange(check: sender.tag)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btnAddAnTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.kSearchMedicalInfoVC)as? SearchMedicalInfoViewController else { return }
        nextVc.check = sender.tag
        nextVc.tableData = questionsModel[sender.tag].questionModel
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}

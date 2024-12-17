//
//  LifeStyleDetailsViewController.swift
//  Hlthera
//
//  Created by Akash on 05/11/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class LifeStyleDetailsViewController: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var lblQues: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblQuestionLeft: UILabel!
    //MARK:- VARIABLES
    var selectedButton = 0
    var quesArray = [String]()
    var qnModel:[QuestionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    private func initialSetup(){
        // qnModel = lifeStyle[selectedButton].questionModel.sorted(by: { $0.answer_option > $1.answer_option })
        
        //lifeStyle[selectedButton].questionModel = qnModel
        
//        setStatusBar(color: #colorLiteral(red: 0.1215686275, green: 0.2470588235, blue: 0.4078431373, alpha: 1))
        self.buttonNext.tag = selectedButton
        self.lblHeader.text = lifeStyle[selectedButton].title
        self.lblQuestionLeft.text = "\(lifeStyle.count - (selectedButton + 1))" + "Questions Left".localize
        self.lblQues.text = lifeStyle[selectedButton].question
    }
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonDoneTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveProfileTapped(_ sender: UIButton) {
    }
    @IBAction func buttonNextTapped(_ sender: UIButton) {
        sender.tag += 1
        if sender.tag < lifeStyle.count{
            self.lblHeader.text = lifeStyle[sender.tag].title
            self.lblQuestionLeft.text = "\(lifeStyle.count - (sender.tag + 1))" + "Questions Left".localize
            titleChange(check: sender.tag)
        }
    }
    func titleChange(check:Int){
        self.selectedButton = check
        self.lblQues.text = lifeStyle[check].question
        self.collectionView.reloadData()
    }
    
}
extension LifeStyleDetailsViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lifeStyle[selectedButton].questionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeStyleAnswerCollectionViewCell", for: indexPath) as!
        LifeStyleAnswerCollectionViewCell
        let isselected = lifeStyle[selectedButton].questionModel[indexPath.item].selectDises
        if isselected{
            cell.viewCell.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.4509803922, alpha: 1)
            cell.labelAnswer.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else {
            cell.viewCell.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.8666666667, blue: 0.8745098039, alpha: 1)
            cell.labelAnswer.textColor = #colorLiteral(red: 0.09803921569, green: 0.3098039216, blue: 0.4509803922, alpha: 1)
        }
        cell.labelAnswer.text = lifeStyle[selectedButton].questionModel[indexPath.item].answer_option
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _ = lifeStyle[selectedButton].questionModel.map{$0.selectDises = false}
        lifeStyle[selectedButton].questionModel[indexPath.item].selectDises = true
        
        //        self.buttonNext.tag += 1
        //        if self.buttonNext.tag < lifeStyle.count{
        //            titleChange(check: self.buttonNext.tag)
        //        }else{
        //            DispatchQueue.main.async {
        //                for controller in self.navigationController!.viewControllers as Array {
        //                    if controller.isKind(of: LifeStyleViewController.self) {
        //                        self.navigationController!.popToViewController(controller, animated: true)
        //                        break
        //                    }
        //                }
        //            }
        //        }
        if selectedButton == lifeStyle.count - 1{
            DispatchQueue.main.async {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: LifeStyleViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }else{
            collectionView.reloadData()
        }
        
    }
    
    
}


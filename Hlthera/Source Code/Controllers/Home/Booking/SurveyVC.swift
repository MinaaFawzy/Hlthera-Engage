//
//  SurveyVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 09/02/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class SurveyVC: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var buttonsEmoji: [UIButton]!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageSelectedEmoji: UIImageView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintStackViewHeight: NSLayoutConstraint!
    
    var questions:[SurveyQuestionsModel] = []
    var selectedEmojis:[SurveyQuestionModel] = [SurveyQuestionModel(qnId: "", answer: ""),SurveyQuestionModel(qnId: "", answer: ""),SurveyQuestionModel(qnId: "", answer: ""),SurveyQuestionModel(qnId: "", answer: ""),SurveyQuestionModel(qnId: "", answer: "") ]
    var selectedChecks = ["","","",""]
    var selectedIndex = 0
    
    
//    var data:BookingDataModel?
    var data:ResultOnGoingSearch?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.font = .corbenRegular(ofSize: 15)
        
        getSurveyQuestions()
        self.imageSelectedEmoji.isHidden = true
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        if #available(iOS 14.0, *) {
            self.pageController.preferredIndicatorImage = #imageLiteral(resourceName: "icon_slide")
            self.pageController.isUserInteractionEnabled = false
        } else {
            // Fallback on earlier versions
        }
        configureCells()
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
        
    }
    func configureCells(){
        if selectedIndex<5{
            collectionView.register(UINib(nibName: SurveyQnsCVC.identifier, bundle: nil), forCellWithReuseIdentifier: SurveyQnsCVC.identifier)
            stackView.isHidden = false
            constraintStackViewHeight.constant = 72
        }
        else{
            collectionView.register(UINib(nibName: SurveySubmitCVC.identifier, bundle: nil), forCellWithReuseIdentifier: SurveySubmitCVC.identifier)
            stackView.isHidden = true
            constraintStackViewHeight.constant = 0
        }
        collectionView.reloadData()
    }
    func resetSelectedEmoji(){
        for view in self.view.subviews{
            if view.tag == 99{
                view.removeFromSuperview()
            }
        }
        self.view.addSubview(self.imageSelectedEmoji)
        self.imageSelectedEmoji.isHidden = true
        self.buttonsEmoji.map{
            $0.isHidden = false
        }
    }
    func setSelectedEmoji(at:Int){
        
        self.selectedEmojis[selectedIndex].qnId = questions[selectedIndex].id
        self.selectedEmojis[selectedIndex].answer = String.getString(at)
       resetSelectedEmoji()
        switch at{
        case 0:
            self.imageSelectedEmoji.image = #imageLiteral(resourceName: "very_bad_sm")
        case 1:
            self.imageSelectedEmoji.image = #imageLiteral(resourceName: "bad_sm")
        case 2:
            self.imageSelectedEmoji.image = #imageLiteral(resourceName: "ok")
        case 3:
            self.imageSelectedEmoji.image = #imageLiteral(resourceName: "good")
        case 4:
            self.imageSelectedEmoji.image = #imageLiteral(resourceName: "amazing")
        default:break
        }
        self.imageSelectedEmoji.translatesAutoresizingMaskIntoConstraints = false
        self.imageSelectedEmoji.tag = 99
        self.imageSelectedEmoji.isHidden = false
               
               self.view.addSubview(self.imageSelectedEmoji)

               NSLayoutConstraint.activate([

                
                self.imageSelectedEmoji.centerXAnchor.constraint(equalTo: self.buttonsEmoji[at].centerXAnchor),
                self.imageSelectedEmoji.bottomAnchor.constraint(equalTo: self.buttonsEmoji[at].bottomAnchor,constant: -30),
                   ])
       
        self.buttonsEmoji[at].isHidden = true

    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateUI(scrollView)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateUI(scrollView)
    }
    func updateUI(_ scrollView: UIScrollView) {
        let xPos = scrollView.contentOffset.x
        let index = xPos / scrollView.bounds.width
        pageController.currentPage = Int(index)
        
        if Int(index) == questions.count-1{
            self.buttonSubmit.setTitle("Submit", for: .normal)
        }
        else{
            self.buttonSubmit.setTitle("Next", for: .normal)
            
        }
        
    }
    func updateQuestions(){
        selectedIndex = selectedIndex + 1
        if selectedIndex < questions.count+1 {
            let width = collectionView.frame.width
            collectionView.scrollRectToVisible(CGRect(x: CGFloat(selectedIndex) * width , y: 0, width: width, height: collectionView.frame.height), animated: true)
            buttonSubmit.setTitle(selectedIndex == 5 ? "Submit" : "Next", for: .normal)
            resetSelectedEmoji()
            pageController.currentPage = selectedIndex
            configureCells()
        }
        else{
           print("hello")
        }
    }
    
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        if selectedIndex<5{
            if selectedEmojis[selectedIndex].qnId == "" {
                CommonUtils.showToast(message: "Please Select Emoji")
                return
            }
            else{
                updateQuestions()
            }
        }
        else{
            SurveySubmitApi()
        }
        
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonVeryBadTapped(_ sender: Any) {
        setSelectedEmoji(at: 0)
    }
    @IBAction func buttonSadTapped(_ sender: Any) {
        setSelectedEmoji(at: 1)
    }
    @IBAction func buttonOkayTapped(_ sender: Any) {
        setSelectedEmoji(at: 2)
    }
    @IBAction func buttonGoodTapped(_ sender: Any) {
        setSelectedEmoji(at: 3)
    }
    @IBAction func buttonAmazingTapped(_ sender: Any) {
        setSelectedEmoji(at: 4)
    }
    
    

}
extension SurveyVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedIndex < 5{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyQnsCVC.identifier, for: indexPath) as! SurveyQnsCVC
            cell.labelQnNumber.text = "Question No. \(indexPath.row + 1)"
            cell.labelQn.text = questions[indexPath.row].question
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveySubmitCVC.identifier, for: indexPath) as! SurveySubmitCVC
            cell.callback = { index,status in
                if status{
                    self.selectedChecks[index] = String.getString(index+1)
                }else{
                    self.selectedChecks[index] = ""
                }
                
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
extension SurveyVC{
    
    func SurveySubmitApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [ApiParameters.question_ids:selectedEmojis.map{$0.qnId}.joined(separator: ","),
                                     ApiParameters.ratings:selectedEmojis.map{String.getString(Int.getInt($0.answer)+1)}.joined(separator: ","),
                                     ApiParameters.booking_id:String.getString(data?.id),
                                     ApiParameters.doctor_id:String.getString(data?.doctorID),
                                     ApiParameters.satisfied_id: selectedChecks.filter{!String.getString($0).isEmpty}.joined(separator: ",")]
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.saveUserSurvey,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                        vc.popUpDescription = "Survey Submitted Successfully!"
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.callback = {
                            kSharedAppDelegate?.moveToHomeScreen()
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
    func getSurveyQuestions(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.surveyQuestions,                                                   requestMethod: .POST,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if Int.getInt(dictResult["status"]) == 0{
                        let data = kSharedInstance.getArray(dictResult["result"])
                        self?.questions =  data.map{
                            SurveyQuestionsModel(data:kSharedInstance.getDictionary($0))
                        }
                        self?.pageController.numberOfPages = (self?.questions.count ?? 0) + 1
                        
                        self?.collectionView.reloadData()
                        
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


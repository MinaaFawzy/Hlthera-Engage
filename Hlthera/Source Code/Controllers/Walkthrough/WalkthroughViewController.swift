//
//  WalkthroughViewController.swift
//  Hlthera
//
//  Created by Fluper on 23/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    //MARK:- @IBOutlets
    @IBOutlet weak var btnSkip: UIButton!
   // @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var bottomJoinNow: NSLayoutConstraint!
    @IBOutlet weak var viewWalkthroughButtons: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var customNavigationControllers: [UIView]!
    //MARK:-Variables
    var imagesWalthrough = [
        UIImage(named: "tutorial_screen_1"),
        UIImage(named: "tutorial_screen_2"),
        UIImage(named: "tutorial_screen_3"),
        UIImage(named: "tutorial_screen_4")
    ]
//    var heading = ["Choose Your Doctor", "Widget Notification","Select Your Pharmacy","Choose Your Laboratory"]
//    var subheading = ["Lorem Ipsum is simply dummy text of printing and typesetting industry","Lorem Ipsum is simply dummy text of printing and typesetting industry","Lorem Ipsum is simply dummy text of printing and typesetting industry","Lorem Ipsum is simply dummy text of printing and typesetting industry"]
    var heading = [
        " Welcome to Hlthera Engage!",
        " Unlock Personalised Profiles",
        "Discover Effortless Search",
        " Embrace Convenience"
    ]
    var subheading = [
        "Simplify your healthcare journey with personalised care at your fingertips.",
        "Create your personalised profile, book with top healers anytime, anywhere.",
        "Find the ideal healthcare options that match your preferences.",
        "Take charge of your appointments effortlessly, ensuring convenience and peace of mind"
    ]
    
    //MARK:- View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageController.numberOfPages = self.imagesWalthrough.count
        self.viewWalkthroughButtons.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.viewWalkthroughButtons.layer.cornerRadius = 30
        
//        btnSkip.backgroundColor = UIColor().hexStringToUIColor(hex: "#F2F5F8")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupStatusBar(red: 255, green: 255, blue: 255)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupStatusBar(red: 245, green: 247, blue: 249)
    }
    
    //MARK:- Function
    
    //MARK:- @IBAction
    @IBAction func btnSkipTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else { return }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func btnNextTapped(_ sender: UIButton) {
        print(pageController.currentPage)
//        btnSkip.backgroundColor =  UIColor().hexStringToUIColor(hex: "#D4D5D9")
//
//        if(pageController.currentPage == 2){
//            sender.setTitle("Get Started", for: .normal)
//        }else{
//            sender.setTitle("Next", for: .normal)
//        }
        if pageController.currentPage == 3 {
            guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kSelectLangVc) as? SelectLangViewController else {return}
            self.navigationController?.pushViewController(nextVc, animated: true)
            
            
//            guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else {return}
//            self.navigationController?.pushViewController(nextVc, animated: true)
            
        }else{
            self.collectionView.scrollToItem(at: IndexPath(item: self.pageController.currentPage == 4 ? 4 : self.pageController.currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
            self.pageController.currentPage = +1
        }
    }
    @IBAction func buttonSignInTapped(_ sender: Any) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else { return }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func buttonJoinNowTapped(_ sender: Any) {
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kSignUpVC) as? SignUpViewController else {return}
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kSignUpVc2) as? SignUpViewController2 else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}
extension WalkthroughViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesWalthrough.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.kWalkthroughCVC, for: indexPath) as! WalkthroughCVC
        cell.lblHeading.text = self.heading[indexPath.row]
        cell.lblSubheading.text = self.subheading[indexPath.row]
        cell.imgScreen.image = imagesWalthrough[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.item == 3 {
//            self.btnNext.setTitle("Get Started", for: .normal)
//        }else{
//            self.btnNext.setTitle("Next", for: .normal)
//        }
        for x in 0..<customNavigationControllers.count {
            if x == indexPath.row {
                customNavigationControllers[x].backgroundColor = UIColor(named: "5")
            } else {
                customNavigationControllers[x].backgroundColor = UIColor(named: "8")
            }
        }
        self.pageController.currentPage = indexPath.item
    }
}

//MARK:- CollectionView Cell Class
class WalkthroughCVC:UICollectionViewCell{
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var imgScreen: UIImageView!
    
}

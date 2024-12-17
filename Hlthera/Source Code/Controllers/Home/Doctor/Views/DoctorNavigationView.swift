//
//  DoctorNavigationView.swift
//  Hlthera
//
//  Created by Mina Fawzy on 17/10/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class DoctorNavigationView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - IBOutlets
    @IBOutlet weak var DoctorNavigationCollectionView: UICollectionView!
    
    var navigationTabsNames = [
        "About".localize,
        "Awards and Honours".localize,
        "Core competencies".localize,
        "Education".localize,
        "Experience".localize,
        "Rating & Reviews".localize
    ]
    var selectedTab:Int = 0
    var callbackSelectedItem: ((_ indexPath: IndexPath)->())?
    
    //MARK: - Variables
    func setupCollectionView() {
        DoctorNavigationCollectionView.dataSource = self
        DoctorNavigationCollectionView.delegate = self
        DoctorNavigationCollectionView.registerNib(for: HospitalCategory.self)
    }
    
    //MARK: - collection funcs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationTabsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HospitalCategory", for: indexPath) as? HospitalCategory else { return UICollectionViewCell() }
        cell.categoryNameLabel.text = navigationTabsNames[indexPath.row]
        if indexPath.row == selectedTab {
            cell.activeView.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            cell.categoryNameLabel.textColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            cell.categoryNameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 15)
        } else {
            cell.activeView.backgroundColor = .clear
            cell.categoryNameLabel.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
            cell.categoryNameLabel.font = UIFont(name: "SFProDisplay-Medium", size: 15)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedTab = indexPath.row
//        callbackSelectedItem?(indexPath)
//        collectionView.reloadData()
    }
}
extension DoctorNavigationView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = navigationTabsNames[indexPath.item]
        let labelWidth = calculateLabelWidth(for: item, indexPath: indexPath)
        
        return CGSize(width: labelWidth + 25, height: 50)
    }
    func calculateLabelWidth(for item: String, indexPath: IndexPath) -> CGFloat {
        let label = UILabel()
        label.text = item
        label.font = selectedTab == indexPath.row ? UIFont(name: "SFProDisplay-Bold", size: 15) : UIFont(name: "SFProDisplay-Medium", size: 15)
        label.sizeToFit()
        return label.frame.size.width
    }

}

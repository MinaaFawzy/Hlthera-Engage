//
//  RatingAndReviewVC.swift
//  Hlthera
//
//  Created by Prashant on 29/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class RatingAndReviewVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data:[RatingModel] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        
        globalApis.getRatingsAndReviews(){ data in
            self.data = data
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension RatingAndReviewVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingAndReviewTVC", for: indexPath) as! RatingAndReviewTVC
        cell.selectionStyle = .none
        let obj = data[indexPath.row]
        cell.labelName.text = obj.rating_type == "Anonymous".localize ? "Anonymous".localize : obj.full_name
        
        
        let dateFormatter = DateFormatter()
        //2021-01-19
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
        dateFormatter.dateStyle = .long
        let date = dateFormatter.date(from:String.getString(obj.rating_date_time)) ?? Date()
        
        cell.labelDate.text = dateFormatter.string(from: date)
        
        cell.labelReview.text = obj.comments
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}


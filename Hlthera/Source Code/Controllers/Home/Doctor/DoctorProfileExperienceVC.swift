//
//  DoctorProfileExperienceVC.swift
//  Hlthera
//
//  Created by Prashant on 29/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class DoctorProfileExperienceVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let experience = String.getString(result?.doctor_exp)
        self.data = [experience]
        tableView.tableFooterView = UIView()
        let tap1 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        tableView.addGestureRecognizer(tap1)
        // Do any additional setup after loading the view.
    }
    @objc func handleTap1(_ sender: UISwipeGestureRecognizer) {
        sender.direction = .right
        guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: RatingAndReviewVC.getStoryboardID()) as? RatingAndReviewVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
        // handling code
    }

}

extension DoctorProfileExperienceVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileDatalistingTVC", for: indexPath) as! DoctorProfileDatalistingTVC
       
        cell.labelName.text = data[indexPath.row] + "Years".localize
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

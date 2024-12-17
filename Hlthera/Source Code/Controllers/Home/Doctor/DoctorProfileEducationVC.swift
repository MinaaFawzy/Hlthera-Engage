//
//  DoctorEducationVC.swift
//  Hlthera
//
//  Created by Prashant on 29/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class DoctorProfileEducationVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data:[DoctorQualificationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = result?.doctor_qualifications else {
            return
        }
        self.data = data
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
   

}

extension DoctorProfileEducationVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileDatalistingTVC", for: indexPath) as! DoctorProfileDatalistingTVC
       
        cell.labelName.text = data[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

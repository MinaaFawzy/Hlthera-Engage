//
//  HospitalHealersVC.swift
//  Hlthera
//
//  Created by Bisho Badie on 20/08/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class HospitalHealersVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var doctorTable: UITableView!
    
    var model: HospitalDetailsResult?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorTable.delegate = self
        doctorTable.dataSource = self
        doctorTable.register(UINib(nibName: BookDoctorTVC.identifier, bundle: nil), forCellReuseIdentifier: BookDoctorTVC.identifier)
    }
    
}

//MARK: - table func
extension HospitalHealersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.doctorBasicInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookDoctorTVC", for: indexPath) as! BookDoctorTVC
        let obj = model?.doctorBasicInfo?[indexPath.row]
        cell.labelDoctorName.text = obj?.doctorName
        cell.labelExperience.text = String.getString(obj?.doctorExp ?? "")
        cell.imageDoctor.downlodeImage(serviceurl: String.getString(obj?.doctorProfile), placeHolder: UIImage(named: "placeholder"))
        //            cell.labelPrice.text = String.getString(obj?. ?? "")
        cell.labelRating.text = String.getString(obj?.ratings ?? "")
        return cell
        
    }
    
}


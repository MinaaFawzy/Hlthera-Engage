//
//  HospitalHealersTVC.swift
//  Hlthera
//
//  Created by Mina Fawzy on 08/10/2023.
//  Copyright © 2023 Fluper. All rights reserved.
//

import UIKit

class HospitalHealersTVC: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var doctorSearchBar: UISearchBar!
    @IBOutlet weak var doctorsTable: UITableView!
    @IBOutlet weak var noDataImageView: UIImageView!
    
    var doctorsData: [DoctorBasicInfo]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doctorsTable.delegate = self
        doctorsTable.dataSource = self
        doctorsTable.register(UINib(nibName: BookDoctorTVC.identifier, bundle: nil), forCellReuseIdentifier: BookDoctorTVC.identifier)
        setupSearchBar()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setupSearchBar() {
        let searchView = self.doctorSearchBar
        searchView?.backgroundImage = UIImage()
        let searchField = self.doctorSearchBar.searchTextField
        searchField.backgroundColor = UIColor().hexStringToUIColor(hex: "#F5F7F9")
        searchField.textColor = UIColor().hexStringToUIColor(hex: "#212529")
        searchField.attributedPlaceholder = NSAttributedString(string: searchField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#8794AA")])
        if let leftView = searchField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = UIColor(hexString: "#8794AA")
        }
    }
    
}

extension HospitalHealersTVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if doctorsData?.count == 0 {
            noDataImageView.isHidden = false
        } else {
            noDataImageView.isHidden = true
        }
        return doctorsData?.count ?? 0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "BookDoctorTVC", for: indexPath) as! BookDoctorTVC
        let obj = doctorsData?[indexPath.row]
        cell.labelDoctorName.text = obj?.doctorName
        cell.labelExperience.text = String.getString(obj?.doctorExp ?? "")
        cell.imageDoctor.downlodeImage(serviceurl: String.getString(obj?.doctorProfile), placeHolder: UIImage(named: "placeholder"))
//            cell.labelPrice.text = String.getString(obj?. ?? "")
        cell.labelRating.text = String.getString(obj?.ratings ?? "")
        return cell
    }
    
}

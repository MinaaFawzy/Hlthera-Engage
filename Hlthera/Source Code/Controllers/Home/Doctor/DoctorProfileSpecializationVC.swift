//
//  DoctorProfileSpecializationVC.swift
//  Hlthera
//
//  Created by Prashant on 23/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class DoctorProfileSpecializationVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var viewMore: UIView!
    @IBOutlet weak private var textView: IQTextView!
    
    // MARK: - Stored Properties
    var data: [SpecialitiesModel] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = result?.doctor_specialities else { return }
        self.data = data
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UiTableView Delegate & Data Source
extension DoctorProfileSpecializationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileDatalistingTVC", for: indexPath) as! DoctorProfileDatalistingTVC
        
        cell.labelName.text = data[indexPath.row].full_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

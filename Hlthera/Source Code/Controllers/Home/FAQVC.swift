//
//  FAQVC.swift
//  Hlthera
//
//  Created by Prashant on 15/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class FAQVC: UIViewController {
    
    var array = [0, 0, 0, 0, 0]
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = .corbenRegular(ofSize: 15)
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func showHide(index: Int, value: Bool) {
        array[index] = value ? 1 : 0
        tableView.reloadData()
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTVC", for: indexPath) as! FAQTVC
        if array[indexPath.row] == 1 {
            cell.buttonQn.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
            cell.imageDownArrow.image = UIImage(systemName: "chevron.up")
            cell.imageDownArrow.tintColor = .white
        } else {
            cell.buttonQn.layer.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
            cell.imageDownArrow.image = UIImage(named: "chevron.down")
            cell.imageDownArrow.tintColor = .white
        }
        cell.callbackTap = { [weak self] selection in
            guard let self = self else { return }
            self.showHide(index: indexPath.row, value :selection)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if array[indexPath.row] == 0 {
            return 65
        } else {
            return 155
        }
    }

}

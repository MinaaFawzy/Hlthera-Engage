//
//  SearchMedicalInfoViewController.swift
//  Hlthera
//
//  Created by Akash on 05/11/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class SearchMedicalInfoViewController: UIViewController {
    //MARK:- OUTLETS
    //MARK:- VARIABLES
    var check:Int?
    @IBOutlet var tableView: UITableView!
//    var tableData = [["Aminocaproic Acid","Cladribine","Dasatinib","Dinutuximab","Eltrombopag","Eltrombopag"],["Cilacar c a a tablet 10's Acid","Atm a gel 15gm","Clindac a solution 25ml","Cossome a syrup 100ml","Femcinol a gel 20gm","Cofstop a expectorant 100ml"],["Cilacar c a a tablet 10's Acid","Atm a gel 15gm","Clindac a solution 25ml","Cossome a syrup 100ml","Femcinol a gel 20gm","Cofstop a expectorant 100ml"],["Diabetes","Hypertension","PCOS","Hypothroidism","COPD","Asthma"],["Burns","Spinal Cord injury","Spinal fracture","Skull fracture","Rib fracture","Jaw fracture"],["Heart","Liver","Kidney","Lungs","Brain","Facial/Cosmetic"]]
    var tableData = [QuestionModel]()
    
    //MARK:-VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
//        setStatusBar(color: #colorLiteral(red: 0.1215686275, green: 0.2470588235, blue: 0.4078431373, alpha: 1))
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
   //MARK:-FUNCTION
    
    //MARK:-ACTIONS
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SearchMedicalInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomsTableCell", for: indexPath) as! SymptomsTableCell
        let dictObject = tableData[indexPath.row]
        
        cell.listName.text  = String.getString(dictObject.answer_option)
        
        cell.imgSelect?.image = dictObject.selectDises == true ? #imageLiteral(resourceName: "check_box") : #imageLiteral(resourceName: "uncheck_box")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        questionsModel[check ?? 0].questionModel[indexPath.row].selectDises = !(questionsModel[check ?? 0].questionModel[indexPath.row].selectDises)
        self.tableView.reloadData()
    }
    
    
    //MARK:-ACTIONS
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: MedicalIDViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    
}

//
//  SavedAddressesTVC.swift
//  Hlthera
//
//  Created by fluper on 17/03/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class SavedAddressesTVC: UITableViewCell {
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewMobile: UIView!
    @IBOutlet weak var labelAddress:UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelMobile:UILabel!
    @IBOutlet weak var labelPostCode: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    var deleteCallback:(()->())?
    var editCallback:(()->())?
    var setupShadowDone: Bool = false
    var originalX:CGFloat = 0
    
    //
    //    override  func awakeFromNib() {
    //        super.awakeFromNib()
    //        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView1(_:)))
    //        viewContent.isUserInteractionEnabled = true
    //        viewContent.addGestureRecognizer(panGesture)
    //        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
    //        leftSwipe.direction = .left
    //        //self.addGestureRecognizer(leftSwipe)
    //
    //        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
    //        rightSwipe.direction = .right
    //        //self.addGestureRecognizer(rightSwipe)
    //        originalX = self.viewContent.center.x
    //    }
    //
    //
    //    @objc func dragView1(_ pan:UIPanGestureRecognizer){
    //        let translation = pan.translation(in: contentView)
    //        if pan.state == UIGestureRecognizer.State.began {
    //
    //        } else if pan.state == UIGestureRecognizer.State.changed {
    //              self.setNeedsLayout()
    //            } else {
    //              if abs(pan.velocity(in: self).x) > 50 {
    //                viewContent.center.x = viewContent.center.x + translation.x
    //                print("dd")
    //              } else {
    //                UIView.animate(withDuration: 0.2, animations: {
    //                  self.setNeedsLayout()
    //                  self.layoutIfNeeded()
    //                })
    //              }
    //            }
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //   //     self.view.bringSubview(toFront: viewDrag)
    //
    //       // if viewContent.center.y <= contentView.frame.height{
    //        if viewContent.center.x <= 173{
    //
    //        }
    //
    //        if viewContent.center.x <= -viewContent.frame.width{
    //            deleteCallback?()
    //        }
    //      //  }else{
    //         //   print("\n#",viewContent.center.y)
    //       // }
    ////        sender.setTranslation(CGPoint.zero, in: self.view)
    //        print("\n#!",viewContent.center.x)
    //
    //    }
    //
    //    @IBAction func buttonDeleteTapped(_ sender: Any) {
    //        deleteCallback?()
    //    }
    //    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
    //        btnDelete.isHidden = false
    //        UIView.animate(withDuration: 0.2) {
    //            self.constraintTrailing.constant = 60
    //            self.constraintLeading.constant = -60
    //            self.viewBG.isHidden = false
    //            self.btnDelete.isHidden = false
    //           // self.btnDelete.isUserInteractionEnabled = false
    //            self.layoutIfNeeded()
    //        }
    //    }
    //
    //    @objc func swipeRight(sender: UISwipeGestureRecognizer){
    //        UIView.animate(withDuration: 0.2) {
    //            //self.btnDelete.isUserInteractionEnabled = true
    //            self.constraintTrailing.constant = 2.5
    //            self.constraintLeading.constant = 2.5
    //            self.viewBG.isHidden = true
    //            self.btnDelete.isHidden = true
    //            self.layoutIfNeeded()
    //        }
    //    }
    //    @IBAction func buttonEditTapped(_ sender: Any) {
    //        editCallback?()
    //    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //        let btn = self
        //                     .allSubViews //get all the subviews
        //                     .first(where: {String(describing:type(of: $0)) ==  "UISwipeActionStandardButton"})
        //        if let x = self.subviews.first(where: {String(describing:type(of: $0)) ==  "UISwipeActionStandardButton"}){
        //            print(x)
        //        }
        //        let x = self.subviews.filter{
        //            String(describing:type(of: $0)) == "UITableViewCellEditControl"
        //
        //        }
        //        if x.indices.contains(0){
        //            x[0].subviews.map{
        //                print("##",String(describing:type(of: $0)))
        //            }
        //        }
        let x = self.superview?.subviews.filter{String(describing:Swift.type(of: $0)) == "_UITableViewCellSwipeContainerView"}
        print(x)
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//    self.tableView.subviews.forEach { subview in
//        print("YourTableViewController: \(String(describing: type(of: subview)))")
//        if (String(describing: type(of: subview)) == "UISwipeActionPullView") {
//            if (String(describing: type(of: subview.subviews[0])) == "UISwipeActionStandardButton") {
//                var deleteBtnFrame = subview.subviews[0].frame
//                deleteBtnFrame.origin.y = 12
//                deleteBtnFrame.size.height = 155
//
//
//                // Subview in this case is the whole edit View
//                subview.frame.origin.y =  subview.frame.origin.y + 12
//                subview.frame.size.height = 155
//                subview.subviews[0].frame = deleteBtnFrame
//                subview.backgroundColor = UIColor.yellow
//            }
//        }
//    }
//}

//
//  AppointmentExtendPopUpViewController.swift
//  Consultation
//
//  Created by Mohit Kumar Mohit on 01/02/21.
//

import UIKit

class AppointmentExtendPopUpViewController: UIViewController {

    @IBOutlet weak var imageExpertProfile: UIImageView!
    @IBOutlet weak var imageAppointmentType: UIImageView!
    @IBOutlet weak var labelExpertName: UILabel!
    @IBOutlet weak var labelAppointmentId: UILabel!
    @IBOutlet weak var labelAppointmentTime: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    var communicationList:CommunicationList?
    var appointmentDetails:AppointmentList?
    
    var communicationType:CommunicationType?
    var homeCallBack:(()->())?
    var extendCallBack:(()->())?
    var receiverid  = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    func initialSetup(){
        if communicationType == .chat{
            self.imageExpertProfile.downlodeImage(serviceurl: kImageDownloadURL + String.getString(self.communicationList?.expertImage), placeHolder: #imageLiteral(resourceName: "user_home-1"))
            self.labelExpertName.text = self.communicationList?.expertName
            self.labelAppointmentId.text = self.communicationList?.appointmentID
            self.labelAppointmentTime.text = self.communicationList?.bookingDate
            self.labelDuration.text = "1 Hour"
        }else{
            self.imageExpertProfile.downlodeImage(serviceurl: kImageDownloadURL + String.getString(self.appointmentDetails?.expertImage), placeHolder: #imageLiteral(resourceName: "user_home-1"))
            self.labelExpertName.text = self.appointmentDetails?.expertName
            self.labelAppointmentId.text = self.appointmentDetails?.appointmentId
            self.labelAppointmentTime.text = self.appointmentDetails?.appointmentDate
        }
    }
    
    @IBAction func buttonClose(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.homeCallBack?()
        }
    }
    
    @IBAction func buttonWannaExtendCall(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.extendCallBack?()
        }
    }
    
    @IBAction func buttonHome(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.homeCallBack?()
        }
    }
}

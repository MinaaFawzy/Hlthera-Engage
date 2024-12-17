//
//  PageVIewController.swift
//  Hlthera
//
//  Created by Prashant on 23/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class PageVIewController: UIPageViewController {
    
    // MARK: - Outlets
    weak var mydelegate: pageViewControllerProtocal?
    var hasCameFrom: HasCameFrom?
    var hospitalData: HospitalDetailsResult?
    var hospitalsListData: HospitalDetailModel?
    var doctorData: DoctorDataModel?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        switch hasCameFrom {
        case .doctors:
            CommonUtils.showHudWithNoInteraction(show: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                guard self != nil else { return }
                if let firstViewController = self?.orderedViewControllers.first {
                    if #available(iOS 15.0, *) {
                        let vc = firstViewController as? DoctorProfileAboutVC
                        vc?.selectedDoctor = self?.doctorData
                        vc?.doctorId = self?.doctorData?.result.doctorID ?? 0
                    }
                    self?.setViewControllers([firstViewController],
                                       direction: .forward,
                                       animated: true,
                                       completion: nil)
                }
            })
        case .hospitals:
            CommonUtils.showHudWithNoInteraction(show: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
                guard self != nil else { return }
            })
            if let firstViewController = self.orderedViewControllers.first {
                let vc = firstViewController as? AboutHospitalVC
                vc?.model = self.hospitalData
//                vc?.searching = true
                self.setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
            CommonUtils.showHudWithNoInteraction(show: false)
        case .hospitalProfile:
            if let firstViewController = orderedViewControllers.first {
                            let vc = firstViewController as? HospitalProfileAboutVC
                            vc?.data = hospitalsListData
                            setViewControllers([firstViewController],
                                               direction: .forward,
                                               animated: true,
                                               completion: nil)
                        }
        default: break
        }
        mydelegate?.getSelectedPageIndex(with: 0)
    }
    
    func changeViewController(index: Int, direction: UIPageViewController.NavigationDirection) {
        switch hasCameFrom {
        case .doctors:
            if index == 5 {
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorRatingsVC.getStoryboardID()) as? DoctorRatingsVC else { return }
                //vc.productId = self.product?.id ?? ""
                vc.hasCameFrom = .doctors
                vc.doctorId = doctorData?.result.doctorID ?? 0
                UserData.shared.hospital_id = "0"
                
                self.navigationController?.present(vc, animated: true)
            } else {
                let vc = orderedViewControllers.filter{ $0.view.tag == index }
                switch index {
                case 0:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                case 1:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                case 2:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                case 3:
                    setViewControllers(vc, direction: direction, animated: true, completion: nil)
                default:
                    break
                }
            }
        case .hospitals:
            switch index {
            case 0:
                guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: AboutHospitalVC.getStoryboardID()) as? AboutHospitalVC else { return }
                vc.model = hospitalData
                setViewControllers([vc], direction: direction, animated: true, completion: nil)
            case 1:
                guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: HospitalHealersVC.getStoryboardID()) as? HospitalHealersVC else { return }
                vc.model = hospitalData
                setViewControllers([vc], direction: direction, animated: true, completion: nil)
            case 2:
                guard let vc = UIStoryboard(name: Storyboards.kHospitals, bundle: nil).instantiateViewController(withIdentifier: HospitalInsuranceVC.getStoryboardID()) as? HospitalInsuranceVC else { return }
                vc.model = hospitalData
                setViewControllers([vc], direction: direction, animated: true, completion: nil)
            case 3:
                guard let vc = UIStoryboard(name: Storyboards.kDoctor, bundle: nil).instantiateViewController(withIdentifier: DoctorRatingsVC.getStoryboardID()) as? DoctorRatingsVC else { return }
                vc.hospitalReview = hospitalData?.reviews ?? []
                vc.hasCameFrom = .hospitals
                setViewControllers([vc], direction: direction, animated: true, completion: nil)
            default:
                break
            }
        case .hospitalProfile:
            let vc = orderedViewControllers.filter{ $0.view.tag == index }
            switch index {
            case 0:
                setViewControllers(vc, direction: direction, animated: true, completion: nil)
            default :
                break
            }
        default: break
        }
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        switch hasCameFrom{
        case .doctors:
            return [self.newVC(name: "DoctorProfileAboutVC"),
                    self.newVC(name:"DoctorProfileSpecializationVC"),
                    self.newVC(name: "DoctorProfileEducationVC"),
                    self.newVC(name: "DoctorProfileExperienceVC")
            ]
        case .hospitalProfile:
            return [self.newVC(name: "HospitalProfileAboutVC")]
        default:
            return []
        }
        
    }()
    
    private func newVC(name: String) -> UIViewController {
        switch hasCameFrom{
        case .doctors:
            return UIStoryboard(name: Storyboards.kDoctor, bundle: nil) .
            instantiateViewController(withIdentifier: name)
        case .hospitalProfile:
            return UIStoryboard(name: "Hospitals", bundle: nil) .
            instantiateViewController(withIdentifier: name)
        default: return UIStoryboard(name: Storyboards.kDoctor, bundle: nil) .
            instantiateViewController(withIdentifier: name)
        }
    }
}

extension PageVIewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.mydelegate?.getSelectedPageIndex(with: pageViewController.viewControllers!.first!.view.tag)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            
            
            return nil
            
            
        }
        
        return orderedViewControllers[nextIndex]
    }
}

protocol pageViewControllerProtocal: UIPageViewControllerDelegate {
    func getSelectedPageIndex(with value:Int)
    
}

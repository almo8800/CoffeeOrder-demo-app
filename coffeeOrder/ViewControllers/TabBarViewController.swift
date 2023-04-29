//
//  TabBarViewController.swift
//  coffeeOrder
//
//  Created by Andrei on 20/2/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var userName: String?
    weak var menuToggleDelegate: ContainerViewControllerProtocol?
    var mainVC: MainViewController?
    
    lazy var popupView: PopUpBuyingView = {
        let view = PopUpBuyingView()
        view.backgroundColor = .systemGreen
       // configurePopUpView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        
    }
    
    private func generateTabBar() {
        
        let mainVC = MainViewController()
        self.mainVC = mainVC
       
        let navVCmain = UINavigationController(rootViewController: mainVC)
        let navVCchat = UINavigationController(rootViewController: ChatViewController())
        
        viewControllers = [
            generateVC(viewController: navVCmain, title: "Main", image: UIImage(systemName: "house.fill")),
            generateVC(viewController: navVCchat, title: "Support", image: UIImage(systemName: "person.fill"))
        ]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("delegate on tabbar viewWillLayout is \(String(describing: menuToggleDelegate))")
        mainVC?.menuToggleDelegate = self.menuToggleDelegate
        
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            if #available(iOS 13.0, *) {
                 navigationController?.navigationBar.setNeedsLayout()
            }
    }
}

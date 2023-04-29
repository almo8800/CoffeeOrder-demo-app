//
//  ContainerViewController.swift
//  coffeeOrder
//
//  Created by Andrei on 4/4/23.
//

import UIKit

protocol ContainerViewControllerProtocol: AnyObject {
    func toggleMenu()
    func configureMenuViewController()
}

class ContainerViewController: UIViewController, ContainerViewControllerProtocol {
    
    //var controller: TabBarViewController!
    var controller: UINavigationController!
    var menuVC: UIViewController!
    var menuIsMove = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarVC()
        
    }
    
    func configureTabBarVC() {
        
        let mainVC = MainViewController()
        let navVCmain = UINavigationController(rootViewController: mainVC)
        mainVC.menuToggleDelegate = self
        controller = navVCmain
        
        view.addSubview(controller.view)
        addChild(controller)
        
        
    }
    
    func configureMenuViewController() {
        if menuVC == nil {
            menuVC = MenuViewController()
            view.insertSubview(menuVC.view, at: 0)
            addChild(menuVC)
            print("Добавили mainViewController")
        }
    }
    
    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.controller.view.frame.origin.x = self.controller.view.frame.width - 140
            }) { (finished) in
            }
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.controller.view.frame.origin.x = 0
            }) { (finished) in
            }
        }
    }
    
    func toggleMenu() {
        menuIsMove = !menuIsMove
        print(menuIsMove)
        showMenuViewController(shouldMove: menuIsMove)
    }
    
    deinit {
        print("Контейнер ушел")
    }
    
}



//
//  ContainerViewController.swift
//  coffeeOrder
//
//  Created by Andrei on 4/4/23.
//

import UIKit

protocol SliderContainerViewControllerProtocol: AnyObject {
    func toggleMenu()
    func configureMenuViewController()
}

class SliderContainerViewController: UIViewController, SliderContainerViewControllerProtocol {
    
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
        mainVC.sliderController = self
        controller = navVCmain
        
        view.addSubview(controller.view)
        addChild(controller)
        
        
    }
    
    func configureMenuViewController() {
        guard menuVC == nil else { return }
        
        menuVC = MenuViewController()
        view.insertSubview(menuVC.view, at: 0)
        addChild(menuVC)
        print("Добавили mainViewController")
    }
    
    
    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            animationConfigure(x: self.controller.view.frame.width - 140)
        } else {
            animationConfigure(x: 0)
        }
        func animationConfigure(x: CGFloat) {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.controller.view.frame.origin.x = CGFloat(x)
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



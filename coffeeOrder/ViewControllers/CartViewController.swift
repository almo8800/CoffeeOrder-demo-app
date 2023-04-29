//
//  CartViewController.swift
//  coffeeOrder
//
//  Created by Andrei on 28/4/23.
//

import Foundation

import UIKit

class CartViewController: UIViewController {
    
    let tableView = CartTableView()
    var delegate: DrinkCollectionViewDelegate!
    var popUpView: PopUpBuyingView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.6908783913, green: 0.7477988601, blue: 0.8680613637, alpha: 1)
        view.addSubview(tableView)
        tableView.frame.size.width = view.bounds.width
        tableView.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: view.bounds.height)
        
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartViewCell")
        tableView.rowHeight = 60
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.reloadData()
        print("cart VC will dissapear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        popupTransition()
    }
    
    func popupTransition() {
        
            popUpView = PopUpBuyingView()
            view.addSubview(popUpView)
            popUpView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
      

    }
 
}
    

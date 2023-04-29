//
//  MainViewController.swift
//  coffeeOrder
//
//  Created by Andrei on 20/2/23.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    var user = User.shared
    
    var popUpView: PopUpBuyingView! = nil
    weak var menuToggleDelegate: ContainerViewControllerProtocol?
    private var mainHeaderLabel = UILabel()
    private var drinkCollectionView = DrinkCollectionView()

    
    var halfModalPresentationController: HalfModalPresentationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.75431, green: 0.642834, blue: 0.956512, alpha: 1)
        setupViews()
        
        DrinkService.shared.fetchDrinks { [weak self] result in
            switch result {
            case .success(let drinks):
                self?.drinkCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(popupTransition), name: Notification.Name("NeedCartButton"), object: nil)
        
        view.addSubview(drinkCollectionView)
        drinkCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        drinkCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        drinkCollectionView.topAnchor.constraint(equalTo: mainHeaderLabel.bottomAnchor, constant: 20).isActive = true
        drinkCollectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    
        
        let observer: () -> Void = { [weak self] in
            self?.drinkCollectionView.reloadData()
        }
        Cart.shared.observers.append(observer)
        
    
        
    }
    
    @objc func cartButtonDidTapped() {
        let nextVC = CartViewController()
        nextVC.delegate = drinkCollectionView
        present(nextVC, animated: true)
    }
    
    @objc func popupTransition() {
        
        if popUpView == nil {
            popUpView = PopUpBuyingView()
            view.addSubview(popUpView)
            popUpView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        } else {
            print("поп-ап уже создан")
        }

    }
    
    override func viewWillLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        drinkCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = User.shared.adressName
        let gearButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .done, target: self, action: #selector(didTapGearButton))
        navigationItem.leftBarButtonItem = gearButton
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .done, target: self, action:
                                            #selector(cartButtonDidTapped))
        navigationItem.rightBarButtonItem = cartButton
        
    }
    
    @objc private func didTapGearButton() {
       
        menuToggleDelegate?.configureMenuViewController()
        menuToggleDelegate?.toggleMenu()
    }

    
    private func setupViews() {
        mainHeaderConfigure()
        navigationBarConfigure()
        
    }
        
    private func mainHeaderConfigure() {
        mainHeaderLabel = UILabel(frame: CGRect(x: 20, y: 200, width: 340, height: 40))
        mainHeaderLabel.font = UIFont.boldSystemFont(ofSize: 36)
       
        mainHeaderLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mainHeaderLabel.text = "Выбери напиток"
        
        view.addSubview(mainHeaderLabel)
    }
    

    deinit {
        print("MainViewController was deinited")
    }
    
}






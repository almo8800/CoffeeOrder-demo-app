//
//  MainViewController.swift
//  coffeeOrder
//
//  Created by Andrei on 20/2/23.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    
    var user = User.shared
    
    lazy var popUpView: PopUpBuyingView = {
        let popUpView = PopUpBuyingView()
        view.addSubview(popUpView)
        return popUpView
    }()
    weak var sliderController: SliderContainerViewControllerProtocol?
    private var mainHeaderLabel = UILabel()
    private var drinkCollectionView = DrinkCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: вынести цвета и тд
        view.backgroundColor = .screenBackground
        setupViews()
        
        DrinkService.shared.fetchDrinks { [weak self] result in
            switch result {
            case .success(let drinks):
                self?.drinkCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(popupTransition), name: .needCartButton, object: nil)
        
        view.addSubview(drinkCollectionView)
        drinkCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        drinkCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        drinkCollectionView.topAnchor.constraint(equalTo: mainHeaderLabel.bottomAnchor, constant: 20).isActive = true
        drinkCollectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    
        
        // TODO: перезагружать одну ячейку, а не всю collectionView. Можно передать в observer index/id и по нему определить ячейку для перезагрузки
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
        popUpView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
        let gearButton = UIBarButtonItem(image: .settings, style: .done, target: self, action: #selector(didTapGearButton))
        navigationItem.leftBarButtonItem = gearButton
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .done, target: self, action:
                                            #selector(cartButtonDidTapped))
        navigationItem.rightBarButtonItem = cartButton
        
    }
    
    @objc private func didTapGearButton() {
       // TODO: странно, что 2 функции, может все в одной делать?
        sliderController?.configureMenuViewController()
        sliderController?.toggleMenu()
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






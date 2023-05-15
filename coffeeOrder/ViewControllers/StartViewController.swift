//
//  ViewController.swift
//  coffeeOrder
//
//  Created by Andrei on 19/2/23.
//

import UIKit
import Foundation

class StartViewController: UIViewController {
    
    private var user: User
    private let yellowView = UIView()
    var pageTitleLabel = UILabel()
    let enterButton = UIButton()
    let screenBounds = UIScreen.main.bounds
    var adressButton = UIButton()
    var adressName: String?
    
    init(user: User = .shared) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7543097138, green: 0.6428341269, blue: 0.9565119147, alpha: 1)
        
        view.addSubview(yellowView)
        view.addSubview(pageTitleLabel)
        yellowView.addSubview(enterButton)
        yellowView.addSubview(adressButton)
        
        setupLayout()
        
        let point = CGPoint(x: 80, y: 200)
        let size = CGSize(width: (screenBounds.width/2 + 40), height: 110)
        
        let cornerRadius: CGFloat = 10.0
        yellowView.layer.cornerRadius = cornerRadius
        yellowView.clipsToBounds = false
        
        yellowView.frame = CGRect(origin: point, size: size)
        yellowView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        yellowView.layer.shadowColor = UIColor.black.cgColor
        yellowView.layer.shadowOpacity = 0.3
        yellowView.layer.shadowRadius = 3.0
        yellowView.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        yellowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // TODO: возможно поменять на layer.cornerRadius,
        let cgPath = UIBezierPath(roundedRect: yellowView.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        yellowView.layer.shadowPath = cgPath
    
    }

    func setupLayout() {
        configureButton()
        configureAdressButton()
        configurePageTitleLabel()
    }
    
    func configurePageTitleLabel() {
       
        pageTitleLabel.font = .boldSystemFont(ofSize: 26)
        pageTitleLabel.text = "ВЫБЕРИТЕ АДРЕС"
        pageTitleLabel.frame = CGRect(x: 80, y: 130, width: screenBounds.width/2 + 40, height: 40)

    }
    
    func configureAdressButton() {
        let optionClosure = { [weak self] (action: UIAction) in
            print(action.title)
            self?.adressName = action.title
        }
        
        adressButton.menu = UIMenu(children : [
            UIAction(title : "Обнинск, Маркса 78", state: .on, handler: optionClosure),
            UIAction(title : "Обнинск, ТЦ Плаза", handler: optionClosure),
            UIAction(title : "Калуга, ул. Гарарина 74", handler: optionClosure),
            UIAction(title : "Калуга, ТЦ Каравай", handler: optionClosure)])
        
        adressButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        adressButton.showsMenuAsPrimaryAction = true
        adressButton.changesSelectionAsPrimaryAction = true
        adressButton.translatesAutoresizingMaskIntoConstraints = false
        
        adressButton.centerXAnchor.constraint(equalTo: yellowView.centerXAnchor).isActive = true
        adressButton.topAnchor.constraint(equalTo: yellowView.topAnchor, constant: 10).isActive = true
        self.adressName = adressButton.titleLabel?.text
    }
    
    
    func configureButton() {
        
        enterButton.setTitle("За кофе!", for: .normal)
        enterButton.setTitleColor(.black, for: .normal)
        
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.centerXAnchor.constraint(equalTo: yellowView.centerXAnchor).isActive = true
        enterButton.topAnchor.constraint(equalTo: adressButton.bottomAnchor, constant: 8).isActive = true
        
        enterButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    
        enterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        enterButton.layer.cornerRadius = 10
        enterButton.layer.borderWidth = 1
        enterButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupAddress() {
        User.shared.adressName = self.adressName
    }
    
    @objc private func didTapButton() {
     
        let sceneDelegate = SceneDelegate.shared
        sceneDelegate?.window?.rootViewController = SliderContainerViewController()
        
        setupAddress()
    }
}


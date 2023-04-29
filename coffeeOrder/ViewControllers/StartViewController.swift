//
//  ViewController.swift
//  coffeeOrder
//
//  Created by Andrei on 19/2/23.
//

import UIKit
import Foundation

class StartViewController: UIViewController {
    
    var user = User.shared
    let newView = UIView()
    let enterButton = UIButton()
    let frame = UIScreen.main.bounds // тут мы фрейму присвоили координаты главного экрана
    var adressButton = UIButton() // кнопка выбора страны
    var adressName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7543097138, green: 0.6428341269, blue: 0.9565119147, alpha: 1)
        print(view.backgroundColor)
        view.addSubview(newView)
        newView.addSubview(enterButton)
        newView.addSubview(adressButton)
        
        setupLayout()
        
        let point = CGPoint(x: 100, y: 200)
        let size = CGSize(width: (frame.width/2), height: 100)
        
        let cornerRadius: CGFloat = 10.0
        newView.layer.cornerRadius = cornerRadius
        newView.clipsToBounds = false
        
        newView.frame = CGRect(origin: point, size: size)
        newView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        newView.layer.shadowColor = UIColor.black.cgColor
        newView.layer.shadowOpacity = 0.3
        newView.layer.shadowRadius = 3.0
        newView.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        
        let cgPath = UIBezierPath(roundedRect: newView.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        newView.layer.shadowPath = cgPath
        
    
    }

    func setupLayout() {
        configureButton()
        configureCountryButton()
    }
    
    func configureCountryButton() {
        
        let optionClosure = { [weak self] (action: UIAction) in
            print(action.title)
            self?.adressName = action.title
            self?.sendName()
            
        }
        
        adressButton.menu = UIMenu(children : [
            UIAction(title : "Обнинск, Маркса 78", state: .on, handler: optionClosure),
            UIAction(title : "Обнинск, ТЦ Плаза", handler: optionClosure),
            UIAction(title : "Калуга, ул. Гарарина 74", handler: optionClosure),
            UIAction(title : "Калуга, ТЦ Каравай", handler: optionClosure),
            UIAction(title : "Малоярославец, привокзальная площадь 2", handler: optionClosure)])
        
        adressButton.showsMenuAsPrimaryAction = true
        adressButton.changesSelectionAsPrimaryAction = true
        adressButton.translatesAutoresizingMaskIntoConstraints = false
        adressButton.frame = CGRect(x: 5, y: 5, width: 290, height: 50)
        
    }
    
    
    func configureButton() {
        //newView.addSubview(enterButton)
        enterButton.setTitle("Выбрать адрес", for: .normal)
        enterButton.backgroundColor = .systemPink
        //enterButton.bounds = CGRect(width: 60, height: 30)
        
        
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.leadingAnchor.constraint(equalTo: newView.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        enterButton.topAnchor.constraint(equalTo: adressButton.bottomAnchor, constant: 6).isActive = true
        
        enterButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    func sendName() {
        User.shared.adressName = self.adressName
    }
    
    @objc private func didTapButton() {
        //successAlert()
        //let rootVC = TabBarViewController()
        //let navVC = UINavigationController(rootViewController: rootVC)
       // rootVC.modalPresentationStyle = .fullScreen
       // present(rootVC, animated: true)
       // navigationController?.pushViewController(rootVC, animated: true)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = ContainerViewController()
        
        
    }
}


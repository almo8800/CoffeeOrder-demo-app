//
//  CartTableViewCell.swift
//  coffeeOrder
//
//  Created by Andrei on 22/4/23.
//

import Foundation
import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let reuseId = "CartViewCell"
    var imageLoadOperation: Cancellable?
    
    var drinkImageView = UIImageView()
    var drinkNameLabel = UILabel()
    var drinkQuantityLabel = UILabel()
    
    var plusButton: UIButton = UIButton()
    var minusButton: UIButton = UIButton()
    
    
    @objc func didStepperValueChanged() {
        
    }
    
    func configureCell(with drink: Drink, drinkQuantity: Int, fetchImage: (String?, @escaping ImageComplition) -> Cancellable?) {
        

        drinkNameLabel.text = drink.name
        drinkQuantityLabel.text = String(drinkQuantity)
        backgroundColor = .white
        
        
        imageLoadOperation = fetchImage(drink.imageUrl) { [weak self] image in
            self?.drinkImageView.image = image
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(drinkImageView)
        addSubview(drinkNameLabel)
        
        contentView.addSubview(plusButton)
        contentView.addSubview(drinkQuantityLabel)
        contentView.addSubview(minusButton)
        

        
        drinkImageView.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkNameLabel.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 10).isActive = true
        drinkNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        
        
        
        drinkQuantityLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        drinkQuantityLabel.textAlignment = .center
        drinkQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkQuantityLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        drinkQuantityLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -10).isActive = true
        drinkQuantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.trailingAnchor.constraint(equalTo: drinkQuantityLabel.leadingAnchor, constant: -20).isActive = true
        minusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        
    
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


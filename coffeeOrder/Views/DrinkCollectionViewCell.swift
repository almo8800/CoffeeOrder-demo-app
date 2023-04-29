//
//  CoffeeCell.swift
//  coffeeOrder
//
//  Created by Andrei on 21/2/23.
//

import Foundation
import UIKit

typealias ImageComplition = (UIImage?) -> Void // пусть принимает UIImage?

class DrinkCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "DrinkCollectionViewCell"
    
    var drinkImageView = UIImageView()
    var drinkNameLabel = UILabel()
    var volumeLabel = UILabel()
    var priceButton = UIButton()
    var cartButton = UIButton()
    var imageLoadOperation: Cancellable?
   
    
    let customStepper: RoundStepper = {
        let blueOcean = UIColor(red: 20, green: 80, blue: 95)
        let stepper = RoundStepper(viewData: .init(color: blueOcean, minimum: 0, maximum: 10, stepValue: 1))
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.layer.masksToBounds = true
        stepper.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        stepper.addTarget(self, action: #selector(didStepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
 
    
    @objc private func didStepperValueChanged() {
        print("latest value: \(customStepper.value)")
      }
    
    func configureCell(with drink: Drink, drinkQuantity: Int, fetchImage: (String?, @escaping ImageComplition) -> Cancellable?) {
        
        drinkNameLabel.text = drink.name
        priceButton.setTitle(String(drink.price), for: .normal)
        volumeLabel.text = "\(drink.volume) мл"
       
        let imageComplition: ImageComplition = { [weak self] image in
            self?.drinkImageView.image = image
        }
        imageLoadOperation = fetchImage(drink.imageUrl, imageComplition)

        configureQuantity(drinkQuantity)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8
        self.layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        
        priceButton.layer.cornerRadius = priceButton.frame.height / 2
        customStepper.layer.cornerRadius = customStepper.layer.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadOperation?.cancel()
        imageLoadOperation = nil
        self.drinkImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        
        addSubview(drinkImageView)
        configureImageView()
        addSubview(drinkNameLabel)
        configureDrinkNameLabel()
        contentView.addSubview(priceButton)
        configurePriceButton()
        addSubview(cartButton)
        configureCartButton()
        contentView.addSubview(customStepper)
        configureCustomStepper()
        
    }

  func configureQuantity(_ quantity: Int) {
    customStepper.updateValue(quantity)

    let isEmpty = quantity == 0
    customStepper.isHidden = isEmpty
    priceButton.isHidden = !isEmpty
  }
    
    private func configureCustomStepper() {
        NSLayoutConstraint.activate([
            customStepper.heightAnchor.constraint(equalToConstant: 40),
            customStepper.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8),
            customStepper.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            customStepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
            ])
            customStepper.isHidden = true
        
    
    }
    
    private func configureImageView() {
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        drinkImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2).isActive = true
        drinkImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/1.5).isActive = true
        drinkImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        drinkImageView.contentMode = .scaleAspectFit
    }
    
    private func configureDrinkNameLabel() {
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkNameLabel.frame = CGRect(x: 50, y: 70, width: 120, height: 21)
        drinkNameLabel.font = UIFont(name: "verdana", size: 20.0)
        drinkNameLabel.textColor = .black
       
        
        drinkNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        drinkNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        drinkNameLabel.topAnchor.constraint(equalTo: drinkImageView.bottomAnchor).isActive = true
    }
    
    private func configurePriceButton() {
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        priceButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
       
        priceButton.layer.masksToBounds = true
        
        priceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        priceButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        priceButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        priceButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        
        priceButton.isHidden = false
        priceButton.addTarget(self, action: #selector(didTapPriceButton), for: .touchUpInside)
    }
    
    @objc private func didTapPriceButton() {
        toggleButtons()
    }
    
    func toggleButtons() {
        customStepper.isHidden.toggle()
        if customStepper.isHidden == false { customStepper.counterLabel.text = "1" } // работает, но костыль 
        priceButton.isHidden.toggle()
    }
    
    private func configureCartButton() {
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
}




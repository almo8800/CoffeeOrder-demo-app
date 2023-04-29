//
//  CoffeeCollectionView.swift
//  coffeeOrder
//
//  Created by Andrei on 21/2/23.
//

import UIKit

protocol DrinkCollectionViewDelegate {
    func reloadData()
      
}

class DrinkCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DrinkCollectionViewDelegate {
   
    
    var drinks: [Drink] { DrinkService.shared.drinks }
    
    var loader = ImageLoader()
    
    var cart: Cart? = Cart.shared
    
    var isCartCreated = false
    
    init() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = UIColor(red: 0.75431, green: 0.642834, blue: 0.956512, alpha: 1)
        delegate = self
        dataSource = self
        
        register(DrinkCollectionViewCell.self, forCellWithReuseIdentifier: "DrinkCollectionViewCell")
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        contentInset = UIEdgeInsets(top: 0, left: Constants.leftDistanceToView, bottom: 0, right: Constants.rightDistanceToView)
         
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks.count
    }
    
    // MARK: - попытка image loader в cellForItem
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(
            withReuseIdentifier: "DrinkCollectionViewCell",
            for: indexPath) as! DrinkCollectionViewCell
        
        let drink = drinks[indexPath.row]
        let cartDrink = cart?.drinksInCart.first(where: { cartDrink in
            cartDrink.drink == drink
        })
        let drinkCount = cartDrink?.count ?? 0

        
        let fetchImage: (String?, @escaping ImageComplition) -> Cancellable? = { [weak self] imageUrl, complition in
            guard let imageURL = URL(string: drink.imageUrl) else { return nil }
            let cancellable = self?.loader.loadImage(imageURL) { result in
                do {
                    let image = try result.get()
                    DispatchQueue.main.async {
                        complition(image)
                    }
                } catch {
                    print(error)
                }
            }
            return cancellable
        }
        
        cell.configureCell(with: drink, drinkQuantity: drinkCount, fetchImage: fetchImage)
        cell.priceButton.tag = indexPath.item
        cell.priceButton.addTarget(self, action: #selector(didTapPriceButton(_:)), for: .touchUpInside)
        
        cell.customStepper.buttonTappedHandler = { buttonValue in
            if buttonValue == 1 {
                Cart.shared.addDrinkToCart(drink: drink)
            } else if buttonValue == -1 {
                Cart.shared.removeDrinkFromCart(drink: drink)
                print("Minus button taped")
            }
            // три строчки эти убрать в отдельную функцию. Вызывать её здесь и внутри конфигурации ячейке
            let cartDrink = self.cart?.drinksInCart.first(where: { cartDrink in
                cartDrink.drink == drink
            })
            let drinkQuant = cartDrink?.count ?? 0

            cell.configureQuantity(drinkQuant)
        }
        
        return cell
    }
    
   
    
    @objc private func didTapPriceButton(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        var drink = self.drinks[indexPath.row]
        isCartCreated = true
        print(Cart.shared.drinksInCart)
        Cart.shared.addDrinkToCart(drink: drink)
        print(Cart.shared.drinksInCart)
    }
    
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // reloadItems(at: [indexPath])
    
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionItemWidth, height: frame.height - 20)
    }
    
   
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

}

//MARK: - Networking


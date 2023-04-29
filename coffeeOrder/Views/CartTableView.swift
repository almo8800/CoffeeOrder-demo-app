//
//  CartTableView.swift
//  coffeeOrder
//
//  Created by Andrei on 22/4/23.
//

import Foundation
import UIKit

class CartTableView: UITableView, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    var loader = ImageLoader()
    var cart = Cart.shared
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        
        
        backgroundColor = #colorLiteral(red: 0.9300717711, green: 0.8473020196, blue: 0.5961633921, alpha: 1)
        delegate = self
        dataSource = self
        
        //translatesAutoresizingMaskIntoConstraints = false
        //contentInset = UIEdgeInsets(top: 0, left: Constants.leftDistanceToView, bottom: 0, right: Constants.rightDistanceToView)
         
        //showsHorizontalScrollIndicator = false
        //showsVerticalScrollIndicator = false
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cart.drinksInCart.count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       // cart.drinksInCart.remove(at: indexPath.row)
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        cart.drinksInCart.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        Cart.shared.notifyObservers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartViewCell", for: indexPath) as! CartTableViewCell
        
        let cartDrink = cart.drinksInCart[indexPath.row]
        
        let fetchImage: (String?, @escaping ImageComplition) -> Cancellable? = { [weak self] imageUrl, complition in
            guard let imageURL = URL(string: cartDrink.drink.imageUrl) else { return nil }
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
        
        let drinkQuantity = cartDrink.count
        cell.configureCell(with: cartDrink.drink, drinkQuantity: drinkQuantity, fetchImage: fetchImage)
        cell.plusButton.addTarget(self, action: #selector(stepperButtonTapped(button:)), for: .touchUpInside)
        cell.plusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(stepperButtonTapped(button:)), for: .touchUpInside)
        cell.minusButton.tag = indexPath.row
        
        return cell // пока заглушка чтоб отъебались
    }
    
    @objc func stepperButtonTapped(button: UIButton) {
        let indexPath1 = IndexPath(row:button.tag,section:0)
        let cartDrink = cart.drinksInCart[indexPath1.row].drink
        
        if button.titleLabel?.text == "+" {
            Cart.shared.addDrinkToCart(drink: cartDrink)
        } else {
            Cart.shared.removeDrinkFromCart(drink: cartDrink)
        }
        self.reloadData()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



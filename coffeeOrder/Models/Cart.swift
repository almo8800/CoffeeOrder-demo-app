//
//  Cart.swift
//  coffeeOrder
//
//  Created by Andrei on 9/4/23.
//

import Foundation
import UIKit

protocol cartButtonAppearedDelegate {
    
}

class Cart {
    
    static let shared = Cart()
   
    var observers: [() -> Void] = []
    var finalPrice: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: .finalPriceHasChanged, object: self, userInfo: ["newValue":finalPrice])
        }
    }
    
    
    var espressoDrink = Drink(id: 5555,
                              name: "хардкод-дринк",
                              description: "hot coffee",
                              imageUrl: "https://raw.githubusercontent.com/almo8800/CoffeDemoApi/main/espresso.png",
                              duration: "5 min",
                              volume: "300",
                              price: "115"
    )
    
    var espressoForCart: CartDrink?
    
    var drinksInCart = [CartDrink]() {
        didSet {
            notifyObservers()
            returnFinalPrice()
        }
    }
    
    init() {
        let espressoForCart = CartDrink(drink: espressoDrink)
        
    }
    
    func notifyObservers() {
        for observer in observers {
            observer()
        }
    }
    
    func addDrinkToCart(drink: Drink) {
        let cartDrink = CartDrink(drink: drink)
        
        if let index = drinksInCart.firstIndex(of: cartDrink) {
            print("drink уже есть в массиве по \(index)")
            drinksInCart[index].count += 1
           // notifyObservers()
        } else {
            print("добавили напиток в массив")
            cartDrink.count = 1
            drinksInCart.append(cartDrink)
        }
        returnFinalPrice()
        print(finalPrice)
        NotificationCenter.default.post(name: Notification.Name("NeedCartButton"), object: nil)
        
    }
    
    func removeDrinkFromCart(drink: Drink) {
        let cartDrink = CartDrink(drink: drink)
        if let index = drinksInCart.firstIndex(of: cartDrink) {
            drinksInCart[index].count -= 1
            //notifyObservers()
        } else {
            print("напитка нет в массиве, удалять нечего")
            // тут надо скрыть степпер
        }
        returnFinalPrice()
        print(finalPrice)
    }
    //
    func returnFinalPrice() -> Int {
        var newSumm = 0
        for cartDrink in drinksInCart {
            let summOfDrink = cartDrink.count * Int(cartDrink.drink.price)!
            newSumm += summOfDrink
            finalPrice = newSumm
        }
        return newSumm
    }
    
   
}





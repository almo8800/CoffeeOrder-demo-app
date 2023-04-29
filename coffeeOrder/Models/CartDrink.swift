//
//  DrinkInCart.swift
//  coffeeOrder
//
//  Created by Andrei on 12/4/23.
//

import Foundation

class CartDrink: Codable {
    
    let drink: Drink
    var count: Int = 0
    
    init(drink: Drink) {
        self.drink = drink
    }
    
    
}

extension CartDrink: Equatable {
    static func == (lhs: CartDrink, rhs: CartDrink) -> Bool {
        return lhs.drink == rhs.drink
        
    }
    
}


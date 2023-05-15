//
//  Drink.swift
//  coffeeOrder
//
//  Created by Andrei on 21/2/23.
//

import Foundation
import UIKit

struct Drink: Codable, Equatable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String
    let duration: String
    let volume: String
    let price: String

    var priceValue: Int? {
        Int(price)
    }
}



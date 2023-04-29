//
//  DrinkService.swift
//  coffeeOrder
//
//  Created by Andrei on 1/3/23.
//

import Foundation
import UIKit


class DrinkService {
    
    static var shared = DrinkService()
    
    init() {}
    
    var drinks: [Drink] = []
    
    func fetchDrinks(completion: @escaping(Result<[Drink], NetworkError>) -> Void) {
        NetworkManager.shared.fetch([Drink].self, from: Link.drinksURL.rawValue) { [weak self] result in
            switch result {
            case .success(let drinks):
                self?.drinks = drinks
                print(drinks)
                completion(.success(drinks))
            case .failure(let error):
                print("Alexey" + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}

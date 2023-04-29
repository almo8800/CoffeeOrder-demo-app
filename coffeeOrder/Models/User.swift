//
//  User.swift
//  coffeeOrder
//
//  Created by Andrei on 27/2/23.
//

import Foundation


class User {
    
    static let shared = User()
    
    var adressName: String?
    var userName = "стандартное"
    var userPassword: String?
    
    private init() {}
    
}


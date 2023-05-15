//
//  MenuModel.swift
//  coffeeOrder
//
//  Created by Andrei on 4/4/23.
//

import Foundation
import UIKit

enum MenuModel: Int, CustomStringConvertible {
    
    // TODO: case с маленькой буквы
     case profile
     case chooseAdress
     case history
     case settings
    
    var description: String {
        switch self {
        case .profile: return "Профиль"
        case .chooseAdress: return "Выбрать кофейню"
        case .history: return "Контакты"
        case .settings: return "Настройки"
        }
    }
    
    var image: UIImage {
        switch self {
        case .profile: return UIImage(systemName: "person.circle.fill") ?? UIImage()
        case .chooseAdress: return UIImage(systemName: "location.circle.fill") ?? UIImage()
        case .history: return UIImage(systemName: "book.circle.fill") ?? UIImage()
        case .settings: return UIImage(systemName: "gearshape.fill") ?? UIImage()
    }
    
    }
}
 

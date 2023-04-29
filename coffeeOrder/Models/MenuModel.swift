//
//  MenuModel.swift
//  coffeeOrder
//
//  Created by Andrei on 4/4/23.
//

import Foundation
import UIKit

enum MenuModel: Int, CustomStringConvertible {
    
     case Profile
     case ChooseAdress
     case History
     case Settings
    
    var description: String {
        switch self {
        case .Profile: return "Профиль"
        case .ChooseAdress: return "Выбрать кофейню"
        case .History: return "Контакты"
        case .Settings: return "Настройки"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile: return UIImage(systemName: "person.circle.fill") ?? UIImage()
        case .ChooseAdress: return UIImage(systemName: "location.circle.fill") ?? UIImage()
        case .History: return UIImage(systemName: "book.circle.fill") ?? UIImage()
        case .Settings: return UIImage(systemName: "gearshape.fill") ?? UIImage()
    }
    
    }
}
 

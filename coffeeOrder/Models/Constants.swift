//
//  Constants.swift
//  coffeeOrder
//
//  Created by Andrei on 28/2/23.
//

import Foundation
import UIKit


struct Constants {
    static let leftDistanceToView: CGFloat = 20
    static let rightDistanceToView: CGFloat = 20
    static let collectionMinimumLineSpacing: CGFloat = 10
    static let collectionItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - (Constants.collectionMinimumLineSpacing / 2)) / 2
    static let collectionItemTopBottomOffset: CGFloat = 10
    
}

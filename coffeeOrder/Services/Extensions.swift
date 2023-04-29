//
//  Extensions.swift
//  coffeeOrder
//
//  Created by Andrei on 25/2/23.
//

import Foundation
import UIKit

// сейчас не используется
extension UIImageView {
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    }
}

extension NSNotification.Name {
    static let finalPriceHasChanged = NSNotification.Name("FinalPriceHasChanged")
}

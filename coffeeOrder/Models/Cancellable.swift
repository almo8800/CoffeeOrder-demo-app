//
//  Cancellable.swift
//  coffeeOrder
//
//  Created by Mihail Babaev on 04.04.2023.
//

import Foundation


protocol Cancellable {
    func cancel()
}

struct ImageCancel: Cancellable {
    
    let token: UUID
    weak var imageLoader: ImageLoader?
    
    func cancel() {
        imageLoader?.cancelLoad(token)
    }
}


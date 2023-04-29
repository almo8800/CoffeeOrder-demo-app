//
//  ImageLoader.swift
//  coffeeOrder
//
//  Created by Andrei on 1/4/23.
//

import Foundation
import UIKit

class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable? {
        
        //1
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        //2
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 3
            defer {self.runningRequests.removeValue(forKey: uuid) }
            
            // 4
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            
            //5
            guard let error = error else {
                return }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
            }
        task.resume()
         // 6
        runningRequests[uuid] = task
        return ImageCancel(token: uuid, imageLoader: self)
        }

    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
        
        print("cancel load \(uuid)")
    }

}

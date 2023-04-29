//
//  NetworkManager.swift
//  coffeeOrder
//
//  Created by Andrei on 1/3/23.
//

import Foundation

enum Link: String {
    case oneDrinkImageURL = "https://raw.githubusercontent.com/almo8800/CoffeDemoApi/main/espresso.png"
    case drinksURL = "https://raw.githubusercontent.com/almo8800/CoffeDemoApi/main/coffee.json"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: String?, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from url: String?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch let myError {
                completion(.failure(.decodingError))
                print(myError)
        }
    }.resume()
    
        
        
}
  
}

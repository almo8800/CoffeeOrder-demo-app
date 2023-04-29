//
//  CODE LESSONS.swift
//  coffeeOrder
//
//  Created by Andrei on 28/2/23.
//

import Foundation
import UIKit

class AnyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    let myImage = UIImageView()
    //спросить про нижний способ?
    lazy var imageView: UIImageView = { // ленивая функция, замыкание будет выполнено при обращении
        let imageView = UIImageView()
        return imageView
    }()
    
    enum Link: String {
        case oneDrinkImageURL = "https://raw.githubusercontent.com/almo8800/CoffeDemoApi/main/espresso.png"
        case drinksURL = "https://github.com/almo8800/CoffeDemoApi/blob/main/coffee.json"
    }
    
    private func fetchImage() {
        // 1. возможно ли создать объект с типом url, если нет - то выходим
        guard let url = URL(string: Link.oneDrinkImageURL.rawValue) else { return }
        
        // 2. дальше мы должны создать сессию через нативный API URL Session
        // в комплишне возращает объекты определенных данных: Data(image), ответ сервера, ошибка? - фоновый поток
        URLSession.shared.dataTask(with: url) { [weak self] data, responce, error in
            guard let data = data, let response = responce else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            print(response)
            // 3. имплементируем скачанную дату (картинку) в вьюКартинки
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { // возвращаем загруженную картинку в основной поток, т.к. комплишен auto уходит в фоновый
                self?.myImage.image = image
            }
        }.resume() // нужно вызвать этот код в блоке замыкания резьюмом, сам он не вызывается
    }
    
    
    //MARK: - до этого получали картинку, а теперь будем получать JSON (JavaScriptObjecNotation)
    
    
    private func fetchDrinks() {
        guard let url = URL(string: Link.drinksURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do { // давай попробуем
                let drinks = try JSONDecoder().decode([Drink].self, from: data)
            } catch let error { // если не получится, лови ошибку
                print(error)
            }
        }.resume()
        
        
    }
    
    //MARK: - Ещё раз загрузка картинки
    var imageViewHere: UIImageView!
    
    // это идёт в основном потоке
    private func configureImage(with drink: Drink) {
        guard let url = URL(string: drink.imageUrl) else {return}
        // а тут мы скачиваем объект из сети, надо вынести из основного потока
        DispatchQueue.global().async { [weak self] in // тут ушли в сеть
            guard let imageData = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async { // тут вернулись в основной поток, но внутри ушедшего в сеть
                self?.imageViewHere.image = UIImage(data: imageData) }
        }
    }
}

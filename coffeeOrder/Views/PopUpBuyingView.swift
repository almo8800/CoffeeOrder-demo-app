//
//  PopUpBuyingView.swift
//  coffeeOrder
//
//  Created by Andrei on 19/4/23.
//

import Foundation
import UIKit
//
private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}


class PopUpBuyingView: UIView {
    
    var orderButton = UIButton()
    var yellowLayerView = UIView()
    var finalPriceLabel = UILabel()
    
    private var heightConstraint = NSLayoutConstraint()
    private var topConstant = NSLayoutConstraint()
    private var isBottomSheetUnwrap = false
    private var currentState: State = .closed
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(orderButtonDidTapped(_:)))
        
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(gestureFired(_:)))
        gestureRecognizer.direction = .up
        gestureRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(gestureRecognizer)
        isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(finalPriceLabelUpdate(_:)), name: .finalPriceHasChanged, object: nil)
        
        
    
        
    }
    
    override func didMoveToSuperview() {
        if let superview = superview {
            
            NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0)
            ])
            
            topConstant = self.topAnchor.constraint(equalTo: superview.bottomAnchor, constant: -90)
            topConstant.isActive = true
        }
    }
    
    func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
    
        
//        heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
//        heightConstraint.isActive = true
        
        addSubview(yellowLayerView)
        yellowLayerViewConfigure()
        
        yellowLayerView.addSubview(orderButton)
        orderButtonConfigure()
        yellowLayerView.addSubview(finalPriceLabel)
        finalPriceLabelConfigure()
        
    }
    
    func yellowLayerViewConfigure() {
        yellowLayerView.translatesAutoresizingMaskIntoConstraints = false
        yellowLayerView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        yellowLayerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        yellowLayerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        yellowLayerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        //yellowLayerView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        yellowLayerView.heightAnchor.constraint(equalToConstant: 58).isActive = true
       
        yellowLayerView.layer.cornerRadius = 10
    }

    
    func orderButtonConfigure() {
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderButton.centerXAnchor.constraint(equalTo: yellowLayerView.centerXAnchor).isActive = true
        orderButton.centerYAnchor.constraint(equalTo: yellowLayerView.centerYAnchor).isActive = true
        orderButton.widthAnchor.constraint(equalTo: yellowLayerView.widthAnchor, multiplier: 0.3).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        orderButton.setTitle("заказать", for: .normal)
        orderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        orderButton.setTitleColor(.black, for: .normal)
        orderButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        orderButton.addTarget(self, action: #selector(orderButtonDidTapped(_:)), for: .touchUpInside)
    }
    
    func finalPriceLabelConfigure() {
        finalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        finalPriceLabel.centerYAnchor.constraint(equalTo: yellowLayerView.centerYAnchor).isActive = true
        finalPriceLabel.trailingAnchor.constraint(equalTo: yellowLayerView.trailingAnchor, constant: -10).isActive = true
        finalPriceLabel.widthAnchor.constraint(equalTo: yellowLayerView.widthAnchor, multiplier: 0.2).isActive = true
        finalPriceLabel.textAlignment = .center
        
        var drinksSumm = String(Cart.shared.finalPrice)
        finalPriceLabel.text = "\(drinksSumm) $"
        
    }
    
    @objc func finalPriceLabelUpdate(_ notification: Notification) {
        if let newValue = notification.userInfo?["newValue"] as? Int {
            finalPriceLabel.text = String(newValue)
            print("файналпрайс лейбл из \(finalPriceLabel)")
        }
    }
    
    @objc func orderButtonDidTapped(_ tap: UITapGestureRecognizer) {
        print("нажата кнопка")
        
        let state = currentState.opposite
        switch state {
        case .open:
            self.topConstant.constant = -90
        case .closed:
            self.topConstant.constant = -300
        }
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            self.superview?.layoutIfNeeded()
        }
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            //            switch self.currentState {
            //            case .open:
            //                self.topConstant.constant = -90
            //            case .closed:
            //                self.topConstant.constant = -300
            //            }
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func gestureFired(_ gesture: UISwipeGestureRecognizer) {
        print("функция жеста или кнопки")
        
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension PopUpBuyingView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
}


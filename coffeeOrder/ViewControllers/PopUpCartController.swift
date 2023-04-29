//
//  PopUpCartController.swift
//  coffeeOrder
//
//  Created by Andrei on 19/4/23.
//

import Foundation
import UIKit

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

class HalfModalPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        let halfHeight = containerView.bounds.height / 2
        return CGRect(x: 0, y: containerView.bounds.height - halfHeight, width: containerView.bounds.width, height: halfHeight)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else {
            return
        }
        containerView.addSubview(presentedView)
        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.layer.cornerRadius = 12
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func dismissalTransitionWillBegin() {
        guard let presentedView = presentedView else {
            return
        }
        presentedView.removeFromSuperview()
    }
}

class PopUpBuyingViewController: UIViewController {
    
    private lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        popupView.addGestureRecognizer(tapRecognizer)
        
        view.backgroundColor = .white
    }
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private func layout() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        popupView.frame.size.height = 600
        
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 400)
        bottomConstraint.isActive = true
        popupView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    private var currentState: State = .closed
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    
    @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
            let state = currentState.opposite
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                switch state {
                case .open:
                    self.bottomConstraint.constant = 0
                case .closed:
                    self.bottomConstraint.constant = 440
                }
                self.view.layoutIfNeeded()
            })
            transitionAnimator.addCompletion { position in
                switch position {
                case .start:
                    self.currentState = state.opposite
                case .end:
                    self.currentState = state
                case .current:
                    ()
                }
                switch self.currentState {
                case .open:
                    self.bottomConstraint.constant = 0
                    print(self.view.frame)
                case .closed:
                    self.bottomConstraint.constant = 440
                    print(self.view.frame)
                }
            }
            transitionAnimator.startAnimation()
        }
    
  
    
}

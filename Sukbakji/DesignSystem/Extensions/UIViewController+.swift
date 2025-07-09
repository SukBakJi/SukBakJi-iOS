//
//  UIViewController+.swift
//  Sukbakji
//
//  Created by jaegu park on 11/22/24.
//

import UIKit

extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        let maxWidth: CGFloat = self.view.bounds.width * 0.8
        let maxSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        var expectedSize = toastLabel.sizeThatFits(maxSize)
        expectedSize.width += 24
        expectedSize.height += 16
        
        toastLabel.frame = CGRect(
            x: (self.view.frame.width - expectedSize.width) / 2,
            y: self.view.frame.height - 150,
            width: expectedSize.width,
            height: expectedSize.height
        )
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    func findPresentViewController() -> UIViewController {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let keyWindow = windowScene.windows.first
        assert((keyWindow != nil), "keyWindow is empty")
        
        var presentViewController = keyWindow?.rootViewController
        
        while true {
            while let presentedViewController = presentViewController?.presentedViewController {
                presentViewController = presentedViewController
            }
            if let navigationController = presentViewController as? UINavigationController {
                presentViewController = navigationController.visibleViewController
                continue
            }
            if let tabBarController = presentViewController as? UITabBarController {
                presentViewController = tabBarController.selectedViewController
                continue
            }
            break
        }
        
        guard let presentViewController = presentViewController else {
            return UIViewController()
        }
        
        return presentViewController
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

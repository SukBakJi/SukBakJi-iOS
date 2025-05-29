//
//  UITextView+.swift
//  Sukbakji
//
//  Created by jaegu park on 12/20/24.
//

import UIKit
import ObjectiveC

private var placeholderLabelKey: UInt8 = 0
private var placeholderInsetsKey: UInt8 = 0

extension UITextView {
    
    private struct AssociatedKeys {
        static var underlineView = UnsafeRawPointer(bitPattern: "underlineView".hashValue)!
    }
    
    private var underlineView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.underlineView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.underlineView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var placeholderLabel: UILabel? {
        get { objc_getAssociatedObject(self, &placeholderLabelKey) as? UILabel }
        set { objc_setAssociatedObject(self, &placeholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func configurePlaceholder(_ placeholder: String, placeholderColor: UIColor = .lightGray, insets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)) {
        self.textContainerInset = insets
        self.textContainer.lineFragmentPadding = 0
        
        let label = UILabel()
        label.text = placeholder
        label.textColor = .gray500
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        sendSubviewToBack(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left + self.textContainer.lineFragmentPadding),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.right),
        ])
        
        placeholderLabel = label
        placeholderLabel?.isHidden = !text.isEmpty
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.placeholderLabel?.isHidden = !self.text.isEmpty
            self.placeholderLabel?.textColor = .warning400
            self.textColor = self.text.isEmpty ? placeholderColor : .gray900
        }
    }
    
    func addTFUnderline() {
        if underlineView == nil {
            self.borderStyle = .none
            
            let underline = UIView()
            underline.backgroundColor = .gray300
            self.superview?.addSubview(underline)
            
            underline.snp.makeConstraints { make in
                make.top.equalTo(self.snp.bottom)
                make.leading.equalTo(self.snp.leading)
                make.trailing.equalTo(self.snp.trailing)
                make.height.equalTo(1.5)
            }
            self.underlineView = underline
            
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }
    
    func updateUnderlineColor(to color: UIColor) {
        underlineView?.backgroundColor = color
    }
    
    func errorfix() {
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}

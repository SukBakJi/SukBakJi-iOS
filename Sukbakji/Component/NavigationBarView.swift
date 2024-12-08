//
//  NavigationBarView.swift
//  Sukbakji
//
//  Created by jaegu park on 12/4/24.
//

import UIKit

protocol NavigationBarViewDelegate: AnyObject {
    func didTapBackButton()
}

final class NavigationBarView: UIView {
   
   var backButton = UIButton().then {
      $0.setImage(UIImage(named: "Sukbakji_Back"), for: .normal)
   }
   var titleLabel = UILabel().then {
      $0.textColor = .black
       $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
   }
   
   weak var delegate: NavigationBarViewDelegate?
   
   init(title: String) {
      super.init(frame: .zero)
      titleLabel.text = title
      setUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func setUI() {
      self.backgroundColor = .white
      
      self.addSubview(backButton)
      self.backButton.snp.makeConstraints { make in
         make.leading.equalToSuperview().offset(8)
         make.bottom.equalToSuperview()
         make.width.height.equalTo(48)
      }
      
      self.addSubview(titleLabel)
      self.titleLabel.snp.makeConstraints { make in
          make.centerY.equalTo(backButton)
          make.centerX.equalToSuperview()
         make.height.equalTo(24)
      }
      
      backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
   }
   
   @objc private func backButtonTapped() {
         delegate?.didTapBackButton()
      }
}

extension UIViewController: NavigationBarViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

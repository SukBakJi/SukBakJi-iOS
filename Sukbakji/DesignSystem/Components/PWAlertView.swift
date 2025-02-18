//
//  PWAlertView.swift
//  Sukbakji
//
//  Created by jaegu park on 12/5/24.
//

import UIKit
import Then
import SnapKit

final class PWAlertView: UIView {
    
    var mainView = UIView().then {
       $0.backgroundColor = .white
       $0.layer.cornerRadius = 12
    }
    var titleLabel = UILabel().then {
        $0.text = "비밀번호 변경 불가"
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    var alertLabel = UILabel().then {
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    var okButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.setBackgroundColor(.orange700, for: .normal)
        $0.setTitle("확인했어요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.white, for: .normal)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        alertLabel.text = title
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.25)
        
        self.addSubview(mainView)
        self.mainView.snp.makeConstraints { make in
           make.center.equalToSuperview()
           make.leading.trailing.equalToSuperview().inset(48)
           make.height.equalTo(203)
        }
        
        self.mainView.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        self.mainView.addSubview(alertLabel)
        self.alertLabel.snp.makeConstraints { make in
           make.top.equalTo(titleLabel.snp.bottom).offset(20)
           make.leading.trailing.equalToSuperview().inset(20)
           make.height.equalTo(40)
        }
        
        self.mainView.addSubview(okButton)
        self.okButton.snp.makeConstraints { make in
           make.centerX.equalToSuperview()
           make.top.equalTo(alertLabel.snp.bottom).offset(26)
           make.leading.trailing.equalToSuperview().inset(20)
           make.height.equalTo(48)
        }
        self.okButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func dismissView() {
        NotificationCenter.default.post(name: NSNotification.Name("CannotChangePW"), object: nil, userInfo: nil)
       UIView.animate(withDuration: 0.3, animations: {
          self.alpha = 0
       }) { _ in
          self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
       }
    }
}

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
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(48)
            $0.height.equalTo(203)
        }
        
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        mainView.addSubview(alertLabel)
        alertLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        mainView.addSubview(okButton)
        okButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(alertLabel.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        okButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
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

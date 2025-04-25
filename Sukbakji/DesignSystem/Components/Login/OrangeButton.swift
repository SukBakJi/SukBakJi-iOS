//
//  OrangeButton.swift
//  Sukbakji
//
//  Created by 오현민 on 3/5/25.
//

import UIKit

class OrangeButton: UIButton {

    init(title: String, isEnabled: Bool = true, height: Int = 48) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(isEnabled ? .white : .gray500, for: .normal)
        self.backgroundColor = isEnabled ? .orange700 : .gray200
        
        self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        self.layer.cornerRadius = 8
        
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setButtonState(isEnabled: Bool) {
        // isEnabled 값에 따라 배경색을 다르게 설정
        self.backgroundColor = isEnabled ? .orange700 : .gray200
        self.setTitleColor(isEnabled ? .white : .gray500, for: .normal)
    }
    

}

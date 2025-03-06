//
//  OrangeButton.swift
//  Sukbakji
//
//  Created by 오현민 on 3/5/25.
//

import UIKit

class OrangeButton: UIButton {

    init(title: String, isEnabled: Bool = true) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.gray500, for: .normal)
        self.backgroundColor = isEnabled ? .gray200 : .orange700
        
        self.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        self.layer.cornerRadius = 8
        
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setButtonState(isEnabled: Bool, enabledColor: UIColor, disabledColor: UIColor, enabledTitleColor: UIColor, disabledTitleColor: UIColor) {
        // isEnabled 값에 따라 배경색을 다르게 설정
        self.backgroundColor = isEnabled ? enabledColor : disabledColor
        self.setTitleColor(isEnabled ? enabledTitleColor : disabledTitleColor, for: .normal)
    }
    

}

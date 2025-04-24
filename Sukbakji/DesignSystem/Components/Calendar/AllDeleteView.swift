//
//  AllDeleteView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/16/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class AllDeleteView: UIView {
    
    private let viewModel = CalendarViewModel()
    var univIds: [Int] = []
    
    var mainView = UIView().then {
       $0.backgroundColor = .white
       $0.layer.cornerRadius = 12
    }
    var titleLabel = UILabel().then {
        $0.text = "일정을 모두 삭제할까요?"
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    var contentLabel = UILabel().then {
        $0.text = "선택한 일정을 모두 삭제할까요? 삭제 후 복구되\n지 않습니다"
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    var cancelButton = UIButton().then {
        $0.tintColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
    }
    var okButton = UIButton().then {
        $0.tintColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setTitle("삭제할게요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
    }
    lazy var buttonStackView = UIStackView().then {
        $0.addArrangedSubview(cancelButton)
        $0.addArrangedSubview(okButton)
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    let disposeBag = DisposeBag()
    
    init(univIds: [Int]) {
        super.init(frame: .zero)
        self.univIds = univIds
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
            $0.height.equalTo(21)
        }
        
        mainView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(254)
            $0.height.equalTo(40)
        }
        
        mainView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        okButton.addTarget(self, action: #selector(delete_Tapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func dismissView() {
       UIView.animate(withDuration: 0.3, animations: {
          self.alpha = 0
       }) { _ in
          self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
       }
    }
    
    @objc private func delete_Tapped() {
        viewModel.deleteUnivCalendarAll()
        UIView.animate(withDuration: 0.3, animations: {
           self.alpha = 0
        }) { _ in
           self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
        }
    }
}

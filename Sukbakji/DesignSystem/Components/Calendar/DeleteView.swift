//
//  DeleteView.swift
//  Sukbakji
//
//  Created by jaegu park on 1/7/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class DeleteView: UIView {
    
    private var alarmViewModel = AlarmViewModel()
    private let viewModel = CalendarViewModel()
    private var univDelete: UnivDelete?
    weak var delegateViewController: UIViewController?
    
    var mainView = UIView().then {
       $0.backgroundColor = .white
       $0.layer.cornerRadius = 12
    }
    var titleLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    var contentLabel = UILabel().then {
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
    
    init(title: String, content: String, alarmViewModel: AlarmViewModel, univDelete: UnivDelete) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.contentLabel.text = content
        self.alarmViewModel = alarmViewModel
        self.univDelete = univDelete
        setUI()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
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
            make.height.equalTo(21)
        }
        
        self.mainView.addSubview(contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(254)
            make.height.equalTo(40)
        }
        
        self.mainView.addSubview(buttonStackView)
        self.buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        self.okButton.addTarget(self, action: #selector(delete_Tapped), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func dismissView() {
       UIView.animate(withDuration: 0.3, animations: {
          self.alpha = 0
       }) { _ in
          self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
       }
    }
    
    @objc private func delete_Tapped() {
        if alarmViewModel.selectAlarmItem != nil {
            alarmViewModel.deleteAlarm(alarmId: alarmViewModel.selectAlarmItem?.alarmId)
        } else {
            viewModel.deleteUnivCalendar(memberId: univDelete?.memberId, univId: univDelete?.univId, season: univDelete?.season, method: univDelete?.method)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.delegateViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

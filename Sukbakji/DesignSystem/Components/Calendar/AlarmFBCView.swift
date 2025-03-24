//
//  AlarmFBCView.swift
//  Sukbakji
//
//  Created by jaegu park on 12/13/24.
//

import UIKit
import Then
import SnapKit

final class AlarmFBCView: UIView {
    
    private weak var targetViewController: UIViewController?
    
    var alarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Alarm"), for: .normal)
    }
    var alarmSettingButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_setAlarm"), for: .normal)
    }
    var myAlarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Myalarm"), for: .normal)
    }
    var alarmSettingLabel = UILabel().then {
        $0.text = "알람 설정"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .white
    }
    var myAlarmLabel = UILabel().then {
        $0.text = "내 알람"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .white
    }
    
    
    init(target: UIViewController) {
        super.init(frame: .zero)
        
        self.targetViewController = target
        setUI()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        self.addSubview(alarmButton)
        alarmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(112)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(60)
        }
        self.alarmButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        self.addSubview(alarmSettingButton)
        alarmSettingButton.snp.makeConstraints { make in
            make.bottom.equalTo(alarmButton.snp.top).offset(-10)
            make.centerX.equalTo(alarmButton)
            make.height.width.equalTo(60)
        }
        self.alarmSettingButton.addTarget(self, action: #selector(alarmSetting_Tapped), for: .touchUpInside)
        
        self.addSubview(myAlarmButton)
        myAlarmButton.snp.makeConstraints { make in
            make.bottom.equalTo(alarmSettingButton.snp.top).offset(-10)
            make.centerX.equalTo(alarmButton)
            make.height.width.equalTo(60)
        }
        self.myAlarmButton.addTarget(self, action: #selector(myAlarm_Tapped), for: .touchUpInside)
        
        self.addSubview(alarmSettingLabel)
        alarmSettingLabel.snp.makeConstraints { make in
            make.trailing.equalTo(alarmSettingButton.snp.leading).offset(-10)
            make.centerY.equalTo(alarmSettingButton)
            make.height.equalTo(19)
        }
        
        self.addSubview(myAlarmLabel)
        myAlarmLabel.snp.makeConstraints { make in
            make.trailing.equalTo(myAlarmButton.snp.leading).offset(-10)
            make.centerY.equalTo(myAlarmButton)
            make.height.equalTo(19)
        }
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        // 터치한 위치가 버튼들의 영역 안에 있는지 확인
        let location = gesture.location(in: self)
        if !alarmButton.frame.contains(location) &&
            !alarmSettingButton.frame.contains(location) &&
            !myAlarmButton.frame.contains(location) {
            dismissView()
        }
    }
    
    @objc private func dismissView() {
       UIView.animate(withDuration: 0.3, animations: {
          self.alpha = 0
       }) { _ in
          self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
       }
    }
    
    @objc private func alarmSetting_Tapped() {
       if let target = targetViewController {
           alarmSettingButtonTarget(target: target)
       }
    }
    
    @objc private func myAlarm_Tapped() {
       if let target = targetViewController {
           myAlarmButtonTarget(target: target)
       }
    }
    
    @objc func alarmSettingButtonTarget(target: UIViewController) {
        if let navigationController = target.navigationController {
            let alarmVC = SetAlarmViewController()
            navigationController.pushViewController(alarmVC, animated: true)
        }
    }
    
    @objc func myAlarmButtonTarget(target: UIViewController) {
        if let navigationController = target.navigationController {
            let myAlarmVC = MyAlarmViewController()
            navigationController.pushViewController(myAlarmVC, animated: true)
        }
    }
}

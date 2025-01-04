//
//  EditUnivCalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/4/25.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa
import DropDown

class EditUnivCalendarViewController: UIViewController {
    
    private var univCalendarViewModel = UnivCalendarViewModel()
    
    private let univLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 22)
        $0.textColor = .black
    }
    private let recruitDateLabel = UILabel().then {
        $0.text = "모집시기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .black
    }
    private let recruitFirstButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    private let recruitFirstLabel = UILabel().then {
        $0.text = "2025년 전기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .black
    }
    private let recruitSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    private let recruitSecondLabel = UILabel().then {
        $0.text = "2025년 후기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .black
    }
    private let recruitTypeLabel = UILabel().then {
        $0.text = "모집전형"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .black
    }
    private let recruitTypeTextField = UITextField().then {
        $0.backgroundColor = .gray100
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
    }
    private let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    private let editButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .disabled)
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .disabled)
    }
    
    private let disposeBag = DisposeBag()
    
    private let drop = DropDown()
    private var recruitType: [String] = ["oo"]
    
    init(univCalendarViewModel: UnivCalendarViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.univCalendarViewModel = univCalendarViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDrop()
    }
    
    private func setDrop() {
        initUI()
        setDropdown()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            make.centerX.equalToSuperview()
            make.height.equalTo(26)
        }
        
        self.view.addSubview(recruitDateLabel)
        recruitDateLabel.snp.makeConstraints { make in
            make.top.equalTo(univLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(24)
        }
        recruitDateLabel.addImageAboveLabel(referenceView: univLabel, spacing: 32)
        
        self.view.addSubview(recruitFirstButton)
        recruitFirstButton.snp.makeConstraints { make in
            make.top.equalTo(recruitDateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(22)
            make.height.width.equalTo(24)
        }
        recruitFirstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(recruitFirstLabel)
        recruitFirstLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitFirstButton)
            make.leading.equalTo(recruitFirstButton.snp.trailing).offset(6)
            make.height.equalTo(19)
        }
        
        self.view.addSubview(recruitSecondButton)
        recruitSecondButton.snp.makeConstraints { make in
            make.centerY.equalTo(recruitFirstButton)
            make.leading.equalTo(recruitFirstLabel.snp.trailing).offset(18)
            make.height.width.equalTo(24)
        }
        recruitSecondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(recruitSecondLabel)
        recruitSecondLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitFirstButton)
            make.leading.equalTo(recruitSecondButton.snp.trailing).offset(6)
            make.height.equalTo(19)
        }
        
        self.view.addSubview(recruitTypeLabel)
        recruitTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(recruitFirstButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(24)
        }
        recruitTypeLabel.addImageAboveLabel(referenceView: recruitFirstButton, spacing: 30)
        
        self.view.addSubview(recruitTypeTextField)
        recruitTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(recruitTypeLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        recruitTypeTextField.errorfix()
        recruitTypeTextField.addTFUnderline()
        recruitTypeTextField.setLeftPadding(10)
        recruitTypeTextField.isEnabled = false
        
        self.view.addSubview(dropButton)
        dropButton.snp.makeConstraints { make in
            make.centerY.equalTo(recruitTypeTextField)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(36)
        }
        dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
        
        self.view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(112)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        editButton.isEnabled = false
    }
    
    private func setUnivCalendarData() {
        guard let selectUnivCalendarItem = self.univCalendarViewModel.selectUnivCalendarItem else { return }
        let univName = selectUnivCalendarItem.univId
        let season = selectUnivCalendarItem.season
        let method = selectUnivCalendarItem.method
        
        if univName == 1 {
            univLabel.text = "서울대학교"
        } else if univName == 2 {
            univLabel.text = "연세대학교"
        } else if univName == 3 {
            univLabel.text = "고려대학교"
        } else {
            univLabel.text = "카이스트"
        }
        if season == recruitFirstLabel.text {
            recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            recruitFirstButton.isEnabled = false
        } else {
            recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            recruitSecondButton.isEnabled = false
        }
        recruitTypeTextField.text = method
    }
    
    @objc func firstButtonTapped() {
        recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
                
        recruitFirstButton.isEnabled = false
        recruitSecondButton.isEnabled = true
    }
    
    @objc func secondButtonTapped() {
        recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
                
        recruitFirstButton.isEnabled = true
        recruitSecondButton.isEnabled = false
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 텍스트 필드 내용이 변경될 때 버튼 색깔 업데이트
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
        
    private func updateButtonColor() {
        if (recruitTypeTextField.text?.isEmpty == false) {
            editButton.isEnabled = true
            editButton.setBackgroundColor(UIColor(named: "Coquelicot")!, for:.normal)
            editButton.setTitleColor(.white, for: .normal)
        } else {
            editButton.isEnabled = false
            editButton.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
            editButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        }
    }
    
    private func initUI() {
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor(red: 236/255, green: 73/255, blue: 8/255, alpha: 1.0) // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = .gray50 // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor(red: 253/255, green: 233/255, blue: 230/255, alpha: 1.0) // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        drop.dismissMode = .automatic // 팝업을 닫을 모드 설정
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    private func setDropdown() {
        // dataSource로 ItemList를 연결
        drop.dataSource = recruitType
        drop.cellHeight = 44
        // anchorView를 통해 UI와 연결
        drop.anchorView = self.recruitTypeTextField
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + recruitTypeTextField.bounds.height)
        
        drop.shadowColor = .clear
        
        drop.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            // separatorInset을 조정하여 separator 앞의 간격을 없앱니다.
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            
            guard index != (self.drop.dataSource.count) - 1 else { return }

            // 새로운 separator 추가
            let separator = UIView()
            separator.backgroundColor = UIColor(hexCode: "E1E1E1")
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separator)
                        
            // separator 높이(굵기) 설정
            let separatorHeight: CGFloat = 1.5 // 원하는 굵기 설정
                        
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: separatorHeight)
            ])
        }
        
        // Item 선택 시 처리
        drop.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.recruitTypeTextField.text = "\(item)"
            self?.updateButtonColor()
            self?.recruitTypeTextField.backgroundColor = UIColor(hexCode: "FAFAFA")
            self?.recruitTypeTextField.setPlaceholderColor(UIColor(hexCode: "9F9F9F"))
            self?.recruitTypeTextField.updateUnderlineColor(to: UIColor(hexCode: "E1E1E1"))
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
            self?.recruitTypeTextField.text = ""
            self?.recruitTypeTextField.backgroundColor = UIColor(hexCode: "FFEBEE")
            self?.recruitTypeTextField.setPlaceholderColor(UIColor(hexCode: "FF4A4A"))
            self?.recruitTypeTextField.updateUnderlineColor(to: UIColor(hexCode: "FF4A4A"))
        }
    }
    
    @objc private func drop_Tapped() {
        drop.show()
    }
}

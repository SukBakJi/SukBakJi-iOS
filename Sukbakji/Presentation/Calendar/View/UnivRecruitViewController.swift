//
//  UnivRecruitViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 12/24/24.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa
import DropDown

class UnivRecruitViewController: UIViewController {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    
    private let titleView = UIView()
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Back"), for: .normal)
    }
    private let titleLabel = UILabel().then {
        $0.text = "대학교 선택"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .gray900
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    private let dateSelectView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let dateSelectLabel = UILabel().then {
        $0.text = "성신여자대학교 일정을 선택해 주세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let recruitSelectLabel = UILabel().then {
        $0.text = "해당 학교의 모집 전형을 선택해 주세요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
    }
    private let stepImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Progress2")
    }
    private let recruitView = UIView().then {
        $0.backgroundColor = UIColor.gray50
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    private let recruitImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_RecruitType")
    }
    private let recruitTitleLabel = UILabel().then {
        $0.text = "2025년 전기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    private var recruitLabel = UILabel().then {
        $0.text = "  모집전형을 선택해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = .gray500
    }
    private let recruitDateView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let recruitDateLabel = UILabel().then {
        $0.text = "모집시기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let recruitFirstButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
        $0.isEnabled = false
    }
    private let recruitFirstLabel = UILabel().then {
        $0.text = "2025년 전기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    private let recruitSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    private let recruitSecondLabel = UILabel().then {
        $0.text = "2025년 후기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    private let recruitTypeView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let recruitTypeLabel = UILabel().then {
        $0.text = "모집전형"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let recruitTypeTextField = UITextField().then {
        $0.backgroundColor = .gray100
        $0.placeholder = "모집전형을 선택해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
    }
    private let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    private let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    private let warningTypeLabel = UILabel().then {
        $0.text = "모집전형은 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    private let nextButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
    }
    
    private let disposeBag = DisposeBag()
    
    private let drop = DropDown()
    private var recruitType: [String] = []
    
    private var univName: String?
    private var univId: Int?
    
    init(univName: String, univId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.univName = univName
        self.univId = univId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setDrop()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 숨기기
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setDrop() {
        initUI()
        setDropdown()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
           make.height.equalTo(95)
        }
        
        self.titleView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(48)
        }
        backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
        
        self.titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(dateSelectView)
        dateSelectView.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(130)
        }
        
        self.dateSelectView.addSubview(dateSelectLabel)
        dateSelectLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        dateSelectLabel.text = "\(univName ?? "") 일정을 선택해 주세요"
        let fullText = dateSelectLabel.text ?? ""
        let changeText = univName ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        dateSelectLabel.attributedText = attributedString
        
        self.dateSelectView.addSubview(recruitSelectLabel)
        recruitSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(dateSelectLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        
        self.dateSelectView.addSubview(stepImageView)
        stepImageView.snp.makeConstraints { make in
            make.top.equalTo(recruitSelectLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(20)
        }
        
        self.view.addSubview(recruitView)
        recruitView.snp.makeConstraints { make in
            make.top.equalTo(stepImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }
        
        self.recruitView.addSubview(recruitImageView)
        recruitImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.width.equalTo(20)
        }
        
        self.recruitView.addSubview(recruitTitleLabel)
        recruitTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(recruitImageView.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
        
        self.recruitView.addSubview(recruitLabel)
        recruitLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(recruitTitleLabel.snp.trailing)
            make.height.equalTo(19)
        }
        
        self.view.addSubview(recruitDateView)
        recruitDateView.snp.makeConstraints { make in
            make.top.equalTo(recruitView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(85)
        }
        
        self.recruitDateView.addSubview(recruitDateLabel)
        recruitDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        recruitDateLabel.addImageAboveLabel(referenceView: recruitView, spacing: 20)
        
        self.recruitDateView.addSubview(recruitFirstButton)
        recruitFirstButton.snp.makeConstraints { make in
            make.top.equalTo(recruitDateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(22)
            make.height.width.equalTo(24)
        }
        recruitFirstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        
        self.recruitDateView.addSubview(recruitFirstLabel)
        recruitFirstLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitFirstButton)
            make.leading.equalTo(recruitFirstButton.snp.trailing).offset(6)
           make.height.equalTo(19)
        }
        
        self.recruitDateView.addSubview(recruitSecondButton)
        recruitSecondButton.snp.makeConstraints { make in
            make.centerY.equalTo(recruitFirstButton)
            make.leading.equalTo(recruitFirstLabel.snp.trailing).offset(18)
            make.height.width.equalTo(24)
        }
        recruitSecondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
        
        self.recruitDateView.addSubview(recruitSecondLabel)
        recruitSecondLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitFirstButton)
            make.leading.equalTo(recruitSecondButton.snp.trailing).offset(6)
           make.height.equalTo(19)
        }
        
        self.view.addSubview(recruitTypeView)
        recruitDateView.snp.makeConstraints { make in
            make.top.equalTo(recruitDateView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(115)
        }
        
        self.recruitTypeView.addSubview(recruitTypeLabel)
        recruitTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(recruitFirstButton.snp.bottom).offset(29.5)
            make.leading.equalToSuperview().offset(24)
           make.height.equalTo(21)
        }
        recruitTypeLabel.addImageAboveLabel(referenceView: recruitDateView, spacing: 29.5)
        
        self.recruitTypeView.addSubview(recruitTypeTextField)
        recruitTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(recruitTypeLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        recruitTypeTextField.errorfix()
        recruitTypeTextField.addTFUnderline()
        recruitTypeTextField.setLeftPadding(15)
        recruitTypeTextField.isEnabled = false
        
        self.recruitTypeView.addSubview(dropButton)
        dropButton.snp.makeConstraints { make in
            make.centerY.equalTo(recruitTypeTextField)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(36)
        }
        dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
        
        self.recruitTypeView.addSubview(warningImageView)
        warningImageView.snp.makeConstraints { make in
            make.top.equalTo(recruitTypeTextField.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(28)
            make.height.width.equalTo(12)
        }
        warningImageView.isHidden = true
        
        self.recruitTypeView.addSubview(warningTypeLabel)
        warningTypeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(warningImageView)
            make.leading.equalTo(warningImageView.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        warningTypeLabel.isHidden = true
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(clickNextButton), for: .touchUpInside)
    }
    
    @objc func firstButtonTapped() {
        recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
                
        recruitFirstButton.isEnabled = false
        recruitSecondButton.isEnabled = true
        recruitTitleLabel.text = "2025년 전기"
    }
    
    @objc func secondButtonTapped() {
        recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
                
        recruitFirstButton.isEnabled = true
        recruitSecondButton.isEnabled = false
        recruitTitleLabel.text = "2025년 후기"
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
            nextButton.isEnabled = true
            nextButton.setBackgroundColor(.orange700, for:.normal)
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.setBackgroundColor(.gray200, for: .normal)
            nextButton.setTitleColor(.gray500, for: .normal)
        }
    }
    
    private func initUI() {
        DropDown.appearance().textColor = .gray900 // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = .orange700 // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = .gray50 // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = .orange50 // 선택한 아이템 배경 색상
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
        
        drop.cellConfiguration = { (index, item) in
            return "  \(item)" // 앞에 4칸 공백 추가
        }
        
        drop.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            // separatorInset을 조정하여 separator 앞의 간격을 없앱니다.
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            
            guard index != (self.drop.dataSource.count) - 1 else { return }

            // 새로운 separator 추가
            let separator = UIView()
            separator.backgroundColor = .gray300
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
            self?.warningTypeLabel.isHidden = true
            self?.warningImageView.isHidden = true
            self?.updateButtonColor()
            self?.recruitTypeTextField.backgroundColor = .gray100
            self?.recruitTypeTextField.setPlaceholderColor(.gray500)
            self?.recruitTypeTextField.updateUnderlineColor(to: .gray300)
            self?.recruitLabel.text = "  \(item)"
            self?.recruitLabel.textColor = .orange700
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
            self?.warningTypeLabel.isHidden = false
            self?.warningImageView.isHidden = false
            self?.recruitTypeTextField.backgroundColor = .warning50
            self?.recruitTypeTextField.setPlaceholderColor(.warning400)
            self?.recruitTypeTextField.updateUnderlineColor(to: .warning400)
            self?.recruitLabel.text = "  모집전형을 선택해 주세요"
            self?.recruitLabel.textColor = .gray500
        }
    }
    
    private func setUnivRecruitTypeAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarUnivMethod.path
        
        let params = [
            "univId": univId ?? 0
        ] as [String : Any]
        
        APIService().getWithAccessTokenParameters(of: APIResponse<UnivMethod>.self, url: url, parameters: params, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                let resultData = response.result.methodList
                for i in 0..<resultData.count {
                    self.recruitType.append(resultData[i].method)
                }
                self.setDropdown()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func setUnivAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarUniv.path
        
        let params = [
            "memberId": memberId,
            "univId": univId ?? 0,
            "season": self.recruitTitleLabel,
            "method": self.recruitTypeTextField.text ?? ""
        ] as [String : Any]
        
        APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: params, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                print("대학교 등록이 정상적으로 처리되었습니다")
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    @objc private func drop_Tapped() {
        drop.show()
    }
    
    @objc private func clickXButton() {
        let univStopView = UnivStopView(target: self, num: 3)
        
        self.view.addSubview(univStopView)
        univStopView.alpha = 0
        univStopView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            univStopView.alpha = 1
        }
    }
    
    @objc private func clickNextButton() {
        setUnivAPI()
        if let navigationController = self.navigationController {
            if let targetViewController = navigationController.viewControllers.dropLast(2).last {
                navigationController.popToViewController(targetViewController, animated: true)
            }
        }
    }
}

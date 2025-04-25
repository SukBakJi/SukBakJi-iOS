//
//  AcademicVerificationViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/20/24.
//

import UIKit
import DropDown
import SnapKit

class AcademicVerificationViewController: UIViewController {
    public var preFilledName: String?

    // MARK: - ErrorState
    private var belongLabelTopConstraint: Constraint?
    private var VerificationLabelTopConstraint: Constraint?
    
    private let nameErrorIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ErrorCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let belongErrorIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ErrorCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let nameErrorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    private let belongErrorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    private let nameErrorView = UIView().then {
        $0.isHidden = true
    }
    private let belongErrorView = UIView().then {
        $0.isHidden = true
    }
    
    // MARK: - ImageView
    private let progressBar = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ProgressBar")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let nameDot = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let belongDot = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let VerificationDot = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let arrowView = UIImageView().then {
        $0.image = UIImage(named: "SBJ_down-arrow")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Label
    private let titleLabel = UILabel().then {
        $0.text = "먼저 학력 인증을 진행할게요"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let subtitlelabel = UILabel().then {
        $0.text = "현재 소속을 선택하고 인증으로 넘어가 주세요"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.numberOfLines = 0
    }
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let belongLabel = UILabel().then {
        $0.text = "현재 소속"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let VerificationLabel = UILabel().then {
        $0.text = "학력 인증"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    
    // MARK: - TextField
    private let nameTextField = UITextField().then {
        $0.placeholder = "이름을 입력해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.clearButtonMode = .whileEditing
        
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .none
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.frame.size.width = 342
        $0.frame.size.height = 44
        $0.backgroundColor = .gray50
        $0.textColor = .gray500
        $0.setPlaceholderColor(.gray500)
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
    }
    
    // MARK: - Button
    private let belongSelectButton = UIButton().then {
        $0.setTitle("현재 소속을 선택해 주세요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        $0.backgroundColor = .gray50
        $0.setTitleColor(.gray500, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.frame.size.width = 342
        $0.frame.size.height = 44
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        $0.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
    }
    private let VerificationButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_Verification-off"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(VerificationButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - view
    private let containerView = UIView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpNavigationBar()
        setDropDown()
        setDropDownUI()
        setupViews()
        setupLayout()
        setTextFieldDelegate()
        validateFieldForButtonUpdate()

        if let preFilledName = preFilledName {
            nameTextField.text = preFilledName
            nameTextField.setUnableState()
            validateFieldForButtonUpdate() // 버튼 상태도 갱신
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - setTextField
    private func setTextFieldDelegate() {
        nameTextField.delegate = self
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "회원가입"
    }
    
    // MARK: - DropDown
    private let dropDown = DropDown()
    private let itemList = [" 학사 졸업 또는 재학", " 석사 재학", " 석사 졸업", " 박사 재학", " 박사 졸업", " 석박사 통합 재학"]
    private var NextPage: Int = 0
    @objc func showDropDown() {
        dropDown.show()
    }
    
    private func setDropDownUI() {
        DropDown.appearance().backgroundColor = .gray50
        DropDown.appearance().selectedTextColor = .orange700
        DropDown.appearance().selectionBackgroundColor = .orange50
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14)!
        DropDown.appearance().shadowColor = UIColor.clear
        DropDown.appearance().shadowOffset = CGSize(width: 0, height: 0)
        DropDown.appearance().shadowRadius = 0
        DropDown.appearance().separatorColor = .gray300
    }
    
    private func setDropDown() {
        dropDown.dataSource = itemList
        dropDown.anchorView = belongSelectButton
        dropDown.bottomOffset = CGPointMake(0, belongSelectButton.bounds.height)
        
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            
            switch item {
            case " 학사 졸업 또는 재학":
                self.NextPage = 1
            case " 박사 재학", " 석사 재학", " 석박사 통합 재학":
                self.NextPage = 2
            case " 박사 졸업", " 석사 졸업":
                self.NextPage = 3
            default:
                break
            }
            self.belongSelectButton.setTitle(item, for: .normal)
            self.belongSelectButton.setTitleColor(.black, for: .normal)
            self.VerificationButton.backgroundColor = .gray50
            self.VerificationButton.layer.addBorder([.bottom], color: .gray300, width: 0.5)
            
            self.arrowView.image = UIImage(named: "SBJ_down-arrow")
            
            // 경고 상태 해제
            self.belongErrorView.isHidden = true
            self.belongSelectButton.backgroundColor = .gray50
            self.belongSelectButton.setTitleColor(.gray500, for: .normal)
            self.belongSelectButton.layer.addBorder([.bottom], color: .gray300, width: 0.5)
            self.updateVerificationLabelTopConstraint()
            
            // 입력 값이 모두 유효한지 확인하고 버튼 상태 업데이트
            self.validateFieldForButtonUpdate()
        }
        
        dropDown.willShowAction = {
            self.arrowView.image = UIImage(named: "SBJ_up-arrow")
        }
        dropDown.cancelAction = {
            self.arrowView.image = UIImage(named: "SBJ_down-arrow")
        }
    }
    
    
    // MARK: - Screen transition
    @objc private func VerificationButtonTapped() {
        validateField()
    }
    
    // 데이터 넘겨주기
    private func nextPage(_ userName: String, _ degreeLevel: DegreeLevel) {
        switch NextPage {
        case 1:
            let FirstAcademicVerificationVC = FirstAcademicVerificationViewController()
            FirstAcademicVerificationVC.userName = userName
            FirstAcademicVerificationVC.degreeLevel = degreeLevel
            self.navigationController?.pushViewController(FirstAcademicVerificationVC, animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
        case 2:
            let SecondAcademicVerificationVC = SecondAcademicVerificationViewController()
            SecondAcademicVerificationVC.userName = userName
            SecondAcademicVerificationVC.degreeLevel = degreeLevel
            self.navigationController?.pushViewController(SecondAcademicVerificationVC, animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
        case 3:
            let ThirdAcademicVerificationVC = ThirdAcademicVerificationViewController()
            ThirdAcademicVerificationVC.userName = userName
            ThirdAcademicVerificationVC.degreeLevel = degreeLevel
            self.navigationController?.pushViewController(ThirdAcademicVerificationVC, animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
        default:
            break
        }
    }
    // MARK: - functional
    
    
    //MARK: - validate
    private func validateField() {
        let name = nameTextField.text ?? ""
        let belong = belongSelectButton.currentTitle ?? ""
        var isNameValid = true
        var isBelongValid = true
        var degreeLevel: DegreeLevel?
        
        if name.isEmpty {
            changeStateError(nameTextField)
            nameErrorLabel.text = "이름은 필수 입력입니다"
            isNameValid = false
        } else {
            changeStateBack(nameTextField)
            isNameValid = true
        }
        
        if belong == "현재 소속을 선택해 주세요" {
            belongSelectButton.backgroundColor = .warning50
            belongSelectButton.setTitleColor(.warning400, for: .normal)
            belongSelectButton.layer.addBorder([.bottom], color: .warning400, width: 0.5)
            belongErrorLabel.text = "현재 소속은 필수 입력입니다"
            isBelongValid = false
            
            belongErrorView.isHidden = false
            updateVerificationLabelTopConstraint()
        } else {
            belongErrorView.isHidden = true
            isBelongValid = true
            
            switch belong {
            case " 학사 졸업 또는 재학":
                degreeLevel = .bachelorsStudying
            case " 석사 재학":
                degreeLevel = .mastersStudying
            case " 석사 졸업":
                degreeLevel = .mastersGraduated
            case " 박사 재학":
                degreeLevel = .doctoralStudying
            case " 박사 졸업":
                degreeLevel = .doctoralGraduated
            case " 석박사 통합 재학":
                degreeLevel = .integratedStudying
            default:
                break
            }
            
        }
        
        if isNameValid && isBelongValid {
            print("다음 화면으로 넘어가기")
            nextPage(name, degreeLevel!)
        }
    }
    
    
    private func changeStateError(_ tf: UITextField) {
        tf.backgroundColor = .warning50
        tf.textColor = .warning400
        tf.setPlaceholderColor(.warning400)
        tf.layer.addBorder([.bottom], color: .warning400, width: 0.5)
        
        nameErrorView.isHidden = false
        updateBelongLabelTopConstraint()
    }
    
    private func changeStateBack(_ tf: UITextField) {
        tf.backgroundColor = .gray50
        tf.textColor = .gray500
        tf.setPlaceholderColor(.gray500)
        tf.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        nameErrorView.isHidden = true
        updateBelongLabelTopConstraint()
    }
    
    private func validateFieldForButtonUpdate() {
        let name = nameTextField.text ?? ""
        let belong = belongSelectButton.currentTitle ?? ""
        var isNameValid = false
        var isBelongValid = false
        
        if !name.isEmpty {
            isNameValid = true
            changeStateBack(nameTextField)
        }
        
        if belong != "현재 소속을 선택해 주세요" {
            isBelongValid = true
        }
        if isNameValid && belong != "현재 소속을 선택해 주세요" {
            updateLoginButton(enabled: true)
        } else {
            updateLoginButton(enabled: false)
        }
    }
    
    private func updateLoginButton(enabled: Bool) {
        if enabled {
            VerificationButton.setImage(UIImage(named: "SBJ_Verification-on"), for: .normal)
        } else {
            VerificationButton.setImage(UIImage(named: "SBJ_Verification-off"), for: .normal)
        }
    }
    // MARK: - addView
    func setupViews() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitlelabel)
        
        view.addSubview(containerView)
        view.addSubview(progressBar)
        
        view.addSubview(nameLabel)
        view.addSubview(nameDot)
        view.addSubview(nameTextField)
        view.addSubview(belongLabel)
        view.addSubview(belongDot)
        view.addSubview(belongSelectButton)
        view.addSubview(arrowView)
        
        view.addSubview(VerificationLabel)
        view.addSubview(VerificationDot)
        view.addSubview(VerificationButton)
        
        view.addSubview(nameErrorView)
        nameErrorView.addSubview(nameErrorIcon)
        nameErrorView.addSubview(nameErrorLabel)
        
        view.addSubview(belongErrorView)
        belongErrorView.addSubview(belongErrorIcon)
        belongErrorView.addSubview(belongErrorLabel)
    }
    
    // MARK: - setLayout
    private func updateBelongLabelTopConstraint() {
        belongLabelTopConstraint?.update(offset: nameErrorView.isHidden ? 20 : 36)
    }
    private func updateVerificationLabelTopConstraint() {
        VerificationLabelTopConstraint?.update(offset: belongErrorView.isHidden ? 20 : 36)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(20)
        }
        
        subtitlelabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(containerView.snp.bottom).offset(8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(progressBar.snp.bottom).offset(40)
        }
        
        nameDot.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        belongLabel.snp.makeConstraints { make in
            belongLabelTopConstraint = make.top.equalTo(nameTextField.snp.bottom).offset(20).constraint
            make.leading.equalToSuperview().inset(24)
        }
        
        belongDot.snp.makeConstraints { make in
            make.top.equalTo(belongLabel.snp.top)
            make.leading.equalTo(belongLabel.snp.trailing).offset(4)
        }
        
        belongSelectButton.snp.makeConstraints { make in
            make.top.equalTo(belongLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        arrowView.snp.makeConstraints { make in
            make.centerY.equalTo(belongSelectButton)
            make.trailing.equalTo(belongSelectButton.snp.trailing).offset(-12)
        }
        VerificationLabel.snp.makeConstraints { make in
            VerificationLabelTopConstraint = make.top.equalTo(belongSelectButton.snp.bottom).offset(20).constraint
            make.leading.equalToSuperview().inset(24)
        }
        
        VerificationDot.snp.makeConstraints { make in
            make.top.equalTo(VerificationLabel.snp.top)
            make.leading.equalTo(VerificationLabel.snp.trailing).offset(4)
        }
        
        VerificationButton.snp.makeConstraints { make in
            make.top.equalTo(VerificationLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(92)
        }
        
        //Error
        nameErrorView.snp.makeConstraints { make in
            make.leading.equalTo(nameTextField)
            make.top.equalTo(nameTextField.snp.bottom).offset(4)
            make.height.equalTo(12)
        }
        
        nameErrorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        nameErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameErrorIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        belongErrorView.snp.makeConstraints { make in
            make.leading.equalTo(belongSelectButton)
            make.top.equalTo(belongSelectButton.snp.bottom).offset(4)
            make.height.equalTo(12)
        }
        
        belongErrorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        belongErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(belongErrorIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
}
// MARK: - extension
extension AcademicVerificationViewController: UITextFieldDelegate {
    // 입력 시 파란색
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.addBorder([.bottom], color: .blue400, width: 0.5)
        
    }
    
    // 입력 끝날 시 회색
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        return true
    }
    
    // 텍스트 필드의 내용이 변경될 때 호출
    func textFieldDidChangeSelection(_ textField: UITextField) {
        validateFieldForButtonUpdate()
    }
}

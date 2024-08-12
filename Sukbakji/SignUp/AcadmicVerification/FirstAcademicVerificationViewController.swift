//
//  FirstAcademicVerificationViewController.swift
//  SukBakJi
//
//  Created by 오현민 on 7/24/24.
//

import UIKit
import UniformTypeIdentifiers

// 대학생
class FirstAcademicVerificationViewController: UIViewController {
    
    private var isUpload = false
    private var isConfirm = false
    var userName: String?
    var degreeLevel: DegreeLevel?
    
    // MARK: - imageView
    private let noticeImageView = UIImageView().then {
        $0.image = UIImage(named: "SBJ_notice")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let ImageIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ImageIcon")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: - Label
    private let titleLabel = UILabel().then {
        let fullText = "학사 졸업 또는 재학 중이시군요!"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let rangeText = (fullText as NSString).range(of: "학사 졸업 또는 재학")
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        $0.attributedText = attributedString
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let subtitlelabel = UILabel().then {
        $0.text = "대학생 학력 인증을 진행할게요 🙌"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.numberOfLines = 0
    }
    private let noticeLabel = UILabel().then {
        $0.text = "제출 유의사항"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.numberOfLines = 0
    }
    private let subNoticeLabel = UILabel().then {
        $0.text = "학교에서 공식적으로 발급한 재학증명서를 제출해 주세요!"
        $0.textColor = .gray600
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.numberOfLines = 0
    }
    private let fileNameLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.numberOfLines = 0
    }
    private let fileSizeLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.numberOfLines = 0
    }
    
    // MARK: - button
    private let studentDocument = UIButton().then {
        $0.setTitle("재학증명서", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.orange700, for: .normal)
        $0.backgroundColor = .clear
        $0.frame.size.width = 88
        $0.frame.size.height = 40
        $0.layer.addBorder([.bottom], color: .orange700, width: 3)
        $0.tag = 1
        $0.addTarget(self, action: #selector(changeTabBarView), for: .touchUpInside)
    }
    private let studentID = UIButton().then {
        $0.setTitle("학생증", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setTitleColor(.gray600, for: .normal)
        $0.frame.size.width = 61
        $0.frame.size.height = 40
        $0.tag = 2
        $0.addTarget(self, action: #selector(changeTabBarView), for: .touchUpInside)
    }
    private let graduateDocument = UIButton().then {
        $0.setTitle("졸업증명서", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setTitleColor(.gray600, for: .normal)
        $0.frame.size.width = 88
        $0.frame.size.height = 40
        $0.tag = 3
        $0.addTarget(self, action: #selector(changeTabBarView), for: .touchUpInside)
    }
    private let uploadButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_upload"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    private let nextButton = UIButton().then {
        $0.setTitle("학력 인증하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    private let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.orange700, for: .normal)
        $0.backgroundColor = .clear
    }
    
    // MARK: - view
    private let containerView = UIView()
    private let customTabBarView = UIView().then {
        $0.backgroundColor = .clear
        $0.frame.size.width = UIScreen.main.bounds.size.width
        $0.frame.size.height = 43
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
    }
    private let uploadedFileView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.isHidden = true
    }
    
    // MARK: - 사진/파일 업로드
    private lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "사진 보관함",
                     image: UIImage(systemName: "photo.on.rectangle"),
                     handler: { [weak self] _ in self?.openPhotoLibrary()}), //여기에 동작 넣어야하는듯
            UIAction(title: "사진 찍기",
                     image: UIImage(systemName: "camera"),
                     handler: { [weak self] _ in self?.openCamera()}),
            UIAction(title: "파일 선택",
                     image: UIImage(systemName: "folder"),
                     handler: { [weak self] _ in self?.openFiles()}),
        ]
    }()
    
    private lazy var menu: UIMenu = {
        return UIMenu(title: "", options: [], children: menuItems)
    }()
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func openFiles() {
        var documentPicker: UIDocumentPickerViewController!
        if #available(iOS 14, *) {
            // iOS 14 & later
            let supportedTypes: [UTType] = [UTType.item]
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        }
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
    }
    private func setMenu() {
        uploadButton.menu = menu
        uploadButton.showsMenuAsPrimaryAction = true
        editButton.menu = menu
        editButton.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - 전환셋업
    private func DidUploadSetUp() {
        uploadButton.layer.isHidden = true
        uploadedFileView.layer.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .orange700
    }
    private func notUploadSetUp() {
        uploadButton.layer.isHidden = false
        uploadedFileView.layer.isHidden = true
        nextButton.isEnabled = false
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setMenu()
        setUpNavigationBar()
        setupViews()
        setupLayout()
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "학력인증"
    }
    
    // MARK: - Functional
    
    // MARK: - Screen transition
    @objc private func nextButtonTapped() {
        let UploadCompletedpopUpVC = UploadCompletedPopUpViewController()
        UploadCompletedpopUpVC.modalPresentationStyle = .overFullScreen
        self.present(UploadCompletedpopUpVC, animated: false)
        
        UploadCompletedpopUpVC.onClose = {
            self.isConfirm = true
            let ResearchTopicVC = ResearchTopicViewController()
            ResearchTopicVC.userName = self.userName
            ResearchTopicVC.degreeLevel = self.degreeLevel
            self.navigationController?.pushViewController(ResearchTopicVC, animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
            
        }
        
    }
    
    
    // MARK: - TabBar
    @objc private func changeTabBarView(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if isUpload {
                // 팝업 띄우기
                let popUpVC = PopUpViewController(desc: "페이지를 이탈하면 현재 업로드한 이미지가 사라져요. 그래도 재학증명서 페이지로 이동할까요?", rangeText: "재학증명서")
                popUpVC.modalPresentationStyle = .overFullScreen
                self.present(popUpVC, animated: false)
                
                // 이동할게요 눌렀을 때
                popUpVC.onMove = {
                    self.isUpload = false
                    self.subNoticeLabel.text = "학교에서 공식적으로 발급한 재학증명서를 제출해 주세요!"
                    self.changeTabBar(self.studentDocument)
                    self.notUploadSetUp()
                }
            } else {
                subNoticeLabel.text = "학교에서 공식적으로 발급한 재학증명서를 제출해 주세요!"
                changeTabBar(studentDocument)
            }
            
        case 2:
            if isUpload {
                let popUpVC = PopUpViewController(desc: "페이지를 이탈하면 현재 업로드한 이미지가 사라져요. 그래도 학생증 인증 페이지로 이동할까요?", rangeText: "학생증 인증")
                popUpVC.modalPresentationStyle = .overFullScreen
                self.present(popUpVC, animated: false)
                
                popUpVC.onMove = {
                    self.isUpload = false
                    self.subNoticeLabel.text = "학생증을 스캔 후 첨부하여 인증해 주세요!"
                    self.changeTabBar(self.studentID)
                    self.notUploadSetUp()
                }
            } else {
                subNoticeLabel.text = "학생증을 스캔 후 첨부하여 인증해 주세요!"
                changeTabBar(studentID)
            }
            
        case 3:
            if isUpload {
                let popUpVC = PopUpViewController(desc: "페이지를 이탈하면 현재 업로드한 이미지가 사라져요. 그래도 졸업증명서 페이지로 이동할까요?", rangeText: "졸업증명서")
                popUpVC.modalPresentationStyle = .overFullScreen
                self.present(popUpVC, animated: false)
                
                popUpVC.onMove = {
                    self.isUpload = false
                    self.subNoticeLabel.text = "학교에서 공식적으로 발급한 졸업증명서를 제출해 주세요!"
                    self.changeTabBar(self.graduateDocument)
                    self.notUploadSetUp()
                }
            } else {
                subNoticeLabel.text = "학교에서 공식적으로 발급한 졸업증명서를 제출해 주세요!"
                changeTabBar(graduateDocument)
            }
            
        default:
            break
        }
    }
    
    private func changeTabBar(_ button: UIButton) {
        // 모든 버튼에서 기존의 하이라이트를 제거
        [studentDocument, studentID, graduateDocument].forEach { btn in
            btn.setTitleColor(.gray600, for: .normal)
            btn.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
            btn.layer.addBorder([.bottom], color: .white, width: 3)
            
        }
        
        // 선택된 버튼에 하이라이트 추가
        button.setTitleColor(.orange700, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.layer.addBorder([.bottom], color: .orange700, width: 3)
    }
    
    // MARK: - Functional
    
    // MARK: - addView
    func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitlelabel)
        
        view.addSubview(customTabBarView)
        customTabBarView.addSubview(studentDocument)
        customTabBarView.addSubview(studentID)
        customTabBarView.addSubview(graduateDocument)
        
        view.addSubview(noticeImageView)
        view.addSubview(noticeLabel)
        view.addSubview(subNoticeLabel)
        view.addSubview(uploadButton)
        
        view.addSubview(uploadedFileView)
        uploadedFileView.addSubview(ImageIcon)
        uploadedFileView.addSubview(fileNameLabel)
        uploadedFileView.addSubview(fileSizeLabel)
        uploadedFileView.addSubview(editButton)
        view.addSubview(nextButton)
    }
    
    // MARK: - setLayout
    func setupLayout() {
        let leftPadding = 24
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalToSuperview().inset(20)
        }
        
        subtitlelabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        customTabBarView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        studentDocument.snp.makeConstraints { make in
            make.centerY.equalTo(customTabBarView)
            make.leading.equalTo(customTabBarView.snp.leading).offset(leftPadding)
            make.height.equalTo(40)
            make.width.equalTo(88)
        }
        
        studentID.snp.makeConstraints { make in
            make.centerY.equalTo(customTabBarView)
            make.leading.equalTo(studentDocument.snp.trailing).offset(16)
            make.height.equalTo(40)
            make.width.equalTo(61)
        }
        
        graduateDocument.snp.makeConstraints { make in
            make.centerY.equalTo(customTabBarView)
            make.leading.equalTo(studentID.snp.trailing).offset(16)
            make.height.equalTo(40)
            make.width.equalTo(88)
        }
        
        
        noticeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(customTabBarView.snp.bottom).offset(16)
            make.width.height.equalTo(20)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(noticeImageView)
            make.leading.equalTo(noticeImageView.snp.trailing).offset(8)
        }
        
        subNoticeLabel.snp.makeConstraints { make in
            make.leading.equalTo(noticeImageView)
            make.top.equalTo(noticeImageView.snp.bottom).offset(10)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.leading.equalTo(noticeImageView)
            make.top.equalTo(subNoticeLabel.snp.bottom).offset(20)
            make.width.equalTo(342)
            make.height.equalTo(220)
        }
        
        uploadedFileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leftPadding)
            make.top.equalTo(subNoticeLabel.snp.bottom).offset(20)
            make.height.equalTo(85)
        }
        
        ImageIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(48)
        }
        
        fileNameLabel.snp.makeConstraints { make in
            make.top.equalTo(ImageIcon.snp.top)
            make.leading.equalTo(ImageIcon.snp.trailing).offset(22)
            make.trailing.equalTo(editButton.snp.leading).offset(15)
        }
        
        fileSizeLabel.snp.makeConstraints { make in
            make.top.equalTo(fileNameLabel.snp.bottom).offset(12)
            make.leading.equalTo(fileNameLabel.snp.leading)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(48)
            make.height.equalTo(28)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leftPadding)
            make.top.equalTo(uploadButton.snp.bottom).offset(176)
            make.height.equalTo(48)
        }
    }
}

// MARK: - UIDocumentPickerDelegate Extension
extension FirstAcademicVerificationViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }
            
            defer { url.stopAccessingSecurityScopedResource() }
            
            // Get file name
            let fileName = url.lastPathComponent
            let maxLength = 18
            let truncatedFileName: String
            if fileName.count > maxLength {
                let fileExtension = fileName.split(separator: ".").last ?? ""
                let namePart = fileName.prefix(fileName.count - fileExtension.count - 1)
                let shortenedNamePart = namePart.prefix(maxLength - fileExtension.count - 3) // 공간을 위해 3자를 예약
                truncatedFileName = "\(shortenedNamePart)...\(fileExtension)"
            } else {
                truncatedFileName = fileName
            }
            fileNameLabel.text = truncatedFileName
            print("업로드 파일명: \(truncatedFileName)")
            
            // Get file size
            do {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
                if let fileSize = fileAttributes[FileAttributeKey.size] as? NSNumber {
                    let sizeInBytes = fileSize.intValue
                    let sizeInKB = Double(sizeInBytes) / 1024.0
                    isUpload = true
                    
                    if isUpload {
                        fileSizeLabel.text = String(format: "%.0f KB", sizeInKB)
                        print(String(format: "업로드 파일 크기: %.0f KB", sizeInKB))
                        DidUploadSetUp()
                    }
                    
                    
                    
                }
            } catch {
                print("Error getting file size: \(error)")
            }
            
            
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate Extension
extension FirstAcademicVerificationViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageURL = info[.imageURL] as? URL {
            // 파일명 가져오기
            let fileName = imageURL.lastPathComponent
            let maxLength = 18
            let truncatedFileName: String
            if fileName.count > maxLength {
                let fileExtension = fileName.split(separator: ".").last ?? ""
                let namePart = fileName.prefix(fileName.count - fileExtension.count - 1)
                let shortenedNamePart = namePart.prefix(maxLength - fileExtension.count - 3) // 공간을 위해 3자를 예약
                truncatedFileName = "\(shortenedNamePart)...\(fileExtension)"
            } else {
                truncatedFileName = fileName
            }
            fileNameLabel.text = truncatedFileName
            print("업로드 파일명 : \(truncatedFileName)")
            
            // 파일 크기 가져오기
            do {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: imageURL.path)
                if let fileSize = fileAttributes[FileAttributeKey.size] as? NSNumber {
                    let sizeInBytes = fileSize.intValue
                    let sizeInKB = Double(sizeInBytes) / 1024.0
                    
                    isUpload = true
                    
                    if isUpload {
                        fileSizeLabel.text = (String(format:"%.0f KB", sizeInKB))
                        print(String(format: "업로드 파일 크기: %.0f KB", sizeInKB))
                        DidUploadSetUp()
                    }
                    
                }
            } catch {
                print("Error getting file size: \(error)")
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

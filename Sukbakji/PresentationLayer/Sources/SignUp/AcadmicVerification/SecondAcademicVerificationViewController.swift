//
//  SecondAcademicVerificationViewController.swift
//  SukBakJi
//
//  Created by 오현민 on 7/24/24.
//

import UIKit
import UniformTypeIdentifiers

//대학원생
class SecondAcademicVerificationViewController: UIViewController {
    
    private var isUpload = false
    private var isConfirm = false
    var userName: String?
    var degreeLevel: DegreeLevel?
    private var selectedImage: UIImage?
    private var selectedCertificateType: String = "재학증명서"
    
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
        let fullText = "석사 또는 박사 재학 중이시군요!"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let rangeText = (fullText as NSString).range(of: "석사 또는 박사 재학")
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        $0.attributedText = attributedString
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let subtitlelabel = UILabel().then {
        $0.text = "대학원생 학력 인증을 진행할게요 🙌"
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
        nextButton.backgroundColor = .gray200
        nextButton.setTitleColor(.gray500, for: .normal)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "학력인증"
    }
    
    // MARK: - Functional
    
    // MARK: - Screen transition
    @objc private func nextButtonTapped() {
        openPopUp()
        
        // 이미지 업로드 여부 검사
        guard let imageData = selectedImage?.pngData() else { return }
        
        // 이미지 변환
        let imageBase64 = imageData.base64EncodedString()
        if imageBase64.isEmpty { return }
        
        let requestBody = PostEduImageRequestDTO(
            certificationPicture: imageBase64,
            educationCertificateType: selectedCertificateType
        )
        
        UserDataManager().PostEduImageDataManager(requestBody) { response in
            if let response = response, response.isSuccess == true {
                self.openPopUp()
            } else {
                print("서버 업로드 실패")
            }
        }
    }
    
    // 팝업 띄우기
    private func openPopUp() {
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
            selectedCertificateType = "재학증명서"
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
            selectedCertificateType = "학생증"
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
            
        default:
            break
        }
    }

    private func changeTabBar(_ button: UIButton) {
        // 모든 버튼에서 기존의 하이라이트를 제거
        [studentDocument, studentID].forEach { btn in
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
extension SecondAcademicVerificationViewController: UIDocumentPickerDelegate {
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
extension SecondAcademicVerificationViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // ✅ 이미지 가져오기
        guard let image = info[.originalImage] as? UIImage else {
            print("이미지 없음")
            picker.dismiss(animated: true, completion: nil)
            return
        }

        // ✅ 압축
        let compressionQuality: CGFloat = 0.5
        guard let compressedData = image.jpegData(compressionQuality: compressionQuality) else {
            print("압축 실패")
            picker.dismiss(animated: true, completion: nil)
            return
        }

        // ✅ 파일명 + 저장
        let fileName = UUID().uuidString + ".jpg"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try compressedData.write(to: tempURL)

            // 파일명 표시
            let maxLength = 18
            let fileExtension = "jpg"
            let namePart = fileName.prefix(fileName.count - fileExtension.count - 1)
            let shortened = namePart.prefix(maxLength - fileExtension.count - 3)
            let displayName = fileName.count > maxLength ? "\(shortened)...\(fileExtension)" : fileName
            fileNameLabel.text = displayName
            print("업로드 파일명: \(displayName)")

            // 파일 크기 표시
            let attr = try FileManager.default.attributesOfItem(atPath: tempURL.path)
            if let fileSize = attr[.size] as? NSNumber {
                let sizeKB = Double(fileSize.intValue) / 1024.0
                fileSizeLabel.text = String(format: "%.0f KB", sizeKB)
                print(String(format: "압축 후 파일 크기: %.0f KB", sizeKB))
            }

            // Base64 인코딩 (서버 전송용)
            let base64String = compressedData.base64EncodedString()
            print("Base64 길이: \(base64String.count)")

            self.selectedImage = image // 필요시 저장
            self.DidUploadSetUp()      // UI 상태 변경

        } catch {
            print("이미지 저장 실패: \(error)")
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

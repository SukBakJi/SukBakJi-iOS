//
//  MentoringPostViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/17/24.
//

import UIKit

class MentoringPostViewController: UIViewController, UITextViewDelegate {
    
    private var memberId = UserDefaults.standard.integer(forKey: "memberID")
    
    @IBOutlet weak var titleTV: UITextView!
    @IBOutlet weak var questionTV: UITextView!
    @IBOutlet weak var setButton: UIButton!
       
    @IBOutlet weak var titleWarningSV: UIStackView!
    @IBOutlet weak var questionWarningSV: UIStackView!
    
    var mentorId: Int = 0
    
    private var mentoringData: MentoringPostResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderSetting()
        settingTextView()
        settingButton()
        
        hideKeyboardWhenTappedAround()
        
        titleWarningSV.isHidden = true
        questionWarningSV.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleTV.addTVUnderline()
        questionTV.addTVUnderline()
    }
    
    func settingTextView() {
        titleTV.backgroundColor = UIColor(hexCode: "F5F5F5")
        titleTV.errorfix()
        titleTV.textContainerInset = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
        questionTV.backgroundColor = UIColor(hexCode: "F5F5F5")
        questionTV.errorfix()
        questionTV.textContainerInset = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
    }
    
    func placeholderSetting() {
        titleTV.delegate = self
        titleTV.text = "• 포트폴리오 작성법\n• 대학원 입학 스펙\n• 교수님 솔직 후기\n• 졸업 후 전망"
        titleTV.font = UIFont(name: "Pretendard-Medium", size: 14)
        titleTV.textColor = UIColor(hexCode: "9F9F9F")
        questionTV.delegate = self
        questionTV.text = "• 졸업 후 대기업 취직 많이 하나요?\n• 포트폴리오에 어떤 내용이 들어가야 하나요?\n• 교수님 인품 좋으신가요?"
        questionTV.font = UIFont(name: "Pretendard-Medium", size: 14)
        questionTV.textColor = UIColor(hexCode: "9F9F9F")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hexCode: "9F9F9F") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
        // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleTV.text.isEmpty {
            titleTV.text = "• 포트폴리오 작성법\n• 대학원 입학 스펙\n• 교수님 솔직 후기\n• 졸업 후 전망"
            titleTV.textColor = UIColor(hexCode: "9F9F9F")
        } else if questionTV.text.isEmpty {
            questionTV.text = "• 졸업 후 대기업 취직 많이 하나요?\n• 포트폴리오에 어떤 내용이 들어가야 하나요?\n• 교수님 인품 좋으신가요?"
            questionTV.textColor = UIColor(hexCode: "9F9F9F")
        }
    }
    
    func settingButton() {
        setButton.isEnabled = false
        setButton.layer.masksToBounds = true
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
        setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // 글자 수 확인
        if titleTV.text.count >= 30 && titleTV.text != "• 포트폴리오 작성법\n• 대학원 입학 스펙\n• 교수님 솔직 후기\n• 졸업 후 전망" {
            titleWarningSV.isHidden = true
            titleTV.textColor = UIColor.black
            titleTV.backgroundColor = UIColor(hexCode: "F5F5F5")
            titleTV.addTVUnderline()
        } else if titleTV.text.count < 30 {
            titleWarningSV.isHidden = false
            titleTV.textColor = UIColor(hexCode: "FF4A4A")
            titleTV.backgroundColor = UIColor(hexCode: "FFEBEE")
            titleTV.addTVRedUnderline()
        }
        
        if questionTV.text.count >= 30 && questionTV.text != "• 졸업 후 대기업 취직 많이 하나요?\n• 포트폴리오에 어떤 내용이 들어가야 하나요?\n• 교수님 인품 좋으신가요?" {
            questionWarningSV.isHidden = true
            questionTV.textColor = UIColor.black
            questionTV.backgroundColor = UIColor(hexCode: "F5F5F5")
            questionTV.addTVUnderline()
        } else if questionTV.text.count < 30 {
            questionWarningSV.isHidden = false
            questionTV.textColor = UIColor(hexCode: "FF4A4A")
            questionTV.backgroundColor = UIColor(hexCode: "FFEBEE")
            questionTV.addTVRedUnderline()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
    
    func updateButtonColor() {
        if (titleTV.text.count >= 30) && (questionTV.text.count >= 30) && (titleTV.textColor == UIColor.black) && (questionTV.textColor == UIColor.black) {
            setButton.isEnabled = true
            setButton.backgroundColor = UIColor(named: "Coquelicot")
            setButton.setTitleColor(.white, for: .normal)
            setButton.setTitleColor(.white, for: .selected)
        } else {
            setButton.isEnabled = false
            setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
            setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
            setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .selected)
        }
    }
    
    @IBAction func set_Tapped(_ sender: Any) {
        let parameters = MentoringPostModel(memberId: memberId, mentorId: mentorId, subject: titleTV.text, question: questionTV.text)
        APIMentoringPost.instance.SendingPostMentoring(parameters: parameters) { result in self.mentoringData = result }
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

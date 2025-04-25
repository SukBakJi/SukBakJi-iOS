//
//  MentoringChatViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 9/9/24.
//

import UIKit
import SocketIO

class MentoringChatViewController: UIViewController {
    
    @IBOutlet weak var profLabel: UILabel!
    
    @IBOutlet weak var mentoringChatTV: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var messageTF: UITextField!
    
    var socket: SocketIOClient!
    var manager: SocketManager!
    
    var roomName: String?
    var messages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setupSocket()
        setTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        // 뷰 컨트롤러가 해제될 때 노티피케이션 제거
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // 키보드 높이 가져오기
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardSize.cgRectValue.height
            
            // 키보드가 올라오는 애니메이션과 동기화
            UIView.animate(withDuration: 0.3) {
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // 키보드가 내려가는 애니메이션과 동기화
        UIView.animate(withDuration: 0.3) {
            self.bottomView.transform = .identity // 원래 위치로 복귀
        }
    }
    
    func setTableView() {
        mentoringChatTV.delegate = self
        mentoringChatTV.dataSource = self
    }
    
    func setTextField() {
        messageTF.setLeftPadding(10)
        messageTF.errorfix()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        messageTF.addTFUnderline()
    }
    
    func setupSocket() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
            self.joinRoom()
        }
        
        socket.on("message") { [weak self] data, ack in
            guard let self = self else { return }
            if let message = data[0] as? String {
                self.messages.append(message)
                self.mentoringChatTV.reloadData()
                self.scrollToBottom()
            }
        }
        
        socket.connect()
    }
    
    func joinRoom() {
        guard let roomName = roomName else { return }
        socket.emit("joinRoom", roomName)
    }
    
    func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        mentoringChatTV.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func back_Button(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

extension MentoringChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentoringChat_TableViewCell", for: indexPath)
        
        return cell
    }
}

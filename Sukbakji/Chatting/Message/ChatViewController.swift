//
//  ChatViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 9/9/24.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var kindView: UIView!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    var socket: SocketIOClient!
    var manager: SocketManager!
    
    var roomName: String?
    var messages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        boardView.layer.cornerRadius = 5
        kindView.layer.cornerRadius = 5
        
        setupSocket()
        setTableView()
    }
    
    func setTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
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
                self.chatTableView.reloadData()
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
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chat_TableViewCell", for: indexPath)
        
        return cell
    }
}

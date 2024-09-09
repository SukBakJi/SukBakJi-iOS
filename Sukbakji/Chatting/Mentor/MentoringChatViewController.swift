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
    
    var socket: SocketIOClient!
    var manager: SocketManager!
    
    var roomName: String?
    var messages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setupSocket()
    }
    
    func setTableView() {
        mentoringChatTV.delegate = self
        mentoringChatTV.dataSource = self
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

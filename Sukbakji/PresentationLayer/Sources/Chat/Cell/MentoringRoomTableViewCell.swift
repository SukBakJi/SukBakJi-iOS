//
//  MentoringRoomTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 1/31/25.
//

import UIKit

class MentoringRoomTableViewCell: UITableViewCell {

    static let identifier = String(describing: MentoringRoomTableViewCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
       setUI()
    }
    
    private func setUI() {
    }
}

//
//  MentoringChattingTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 1/31/25.
//

import UIKit

class MentoringChattingTableViewCell: UITableViewCell {

    static let identifier = String(describing: MentoringChattingTableViewCell.self)

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

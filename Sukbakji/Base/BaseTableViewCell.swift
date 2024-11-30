//
//  BaseTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 11/29/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConfigure()
        setConstraints()
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure() { }
    func setConstraints() { }
    func setting() { }
}

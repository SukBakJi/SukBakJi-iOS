//
//  TosProtocol.swift
//  Sukbakji
//
//  Created by 오현민 on 2/19/25.
//

import Foundation

protocol TOSCellDelegate: AnyObject {
    func didTapReadMore(in cell: TOSTableViewCell)
}

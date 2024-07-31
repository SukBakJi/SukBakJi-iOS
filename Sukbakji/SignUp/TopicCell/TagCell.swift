import UIKit
import SnapKit
import Then

class TagCell: UICollectionViewCell {
    let tagLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    let removeButton = UIButton().then {
        $0.setImage(UIImage(named: "cross"), for: .normal)
        $0.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagLabel)
        contentView.addSubview(removeButton)
        
        tagLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.leading.equalTo(tagLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(12)
        }
        
        contentView.backgroundColor = .orange700
        contentView.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func removeButtonTapped() {
        print("아하하하하핫")
    }
}

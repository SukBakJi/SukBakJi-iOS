//
//  RadioGroup+.swift
//  Sukbakji
//
//  Created by jaegu park on 8/21/25.
//

import UIKit
import RxSwift
import RxCocoa

final class RadioGroup<Value: Equatable> {
    struct Appearance {
        let selectedImage: UIImage?
        let deselectedImage: UIImage?
        let useSelectedStateImage: Bool
        
        /// selected/deselected에 서로 다른 이미지를 쓸 때 사용
        static func images(selected: UIImage?, deselected: UIImage?) -> Appearance {
            .init(selectedImage: selected, deselectedImage: deselected, useSelectedStateImage: false)
        }
        
        /// UIButton의 .selected 상태 이미지를 사전에 셋업해 둔 경우
        static var usesSelectedState: Appearance {
            .init(selectedImage: nil, deselectedImage: nil, useSelectedStateImage: true)
        }
    }
    
    /// 현재 선택된 값 (외부 바인딩용)
    let selectedValue: BehaviorRelay<Value>
    
    /// 내부
    private let buttons: [UIButton]
    private let values: [Value]
    private let disposeBag = DisposeBag()
    private let appearance: Appearance
    
    init(
        buttons: [UIButton],
        values: [Value],
        initial: Value? = nil,
        appearance: Appearance = .images(
            selected: UIImage(named: "Sukbakji_RadioButton"),
            deselected: UIImage(named: "Sukbakji_RadioButton2")
        )
    ) {
        precondition(buttons.count == values.count && !buttons.isEmpty, "버튼/값 매칭 개수 이상")
        self.buttons = buttons
        self.values = values
        self.appearance = appearance
        
        let initialValue = initial ?? values[0]
        self.selectedValue = BehaviorRelay<Value>(value: initialValue)
        
        // 버튼 탭 → 선택값 갱신
        for (i, btn) in buttons.enumerated() {
            btn.rx.tap
                .map { values[i] }
                .bind(to: selectedValue)
                .disposed(by: disposeBag)
        }
        
        // 선택값 변화를 UI에 반영
        selectedValue
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] new in
                self?.applySelection(new)
            })
            .disposed(by: disposeBag)
        
        // 초기 적용
        applySelection(initialValue)
    }
    
    /// 프로그래매틱 선택
    func setSelectedValue(_ value: Value) {
        guard values.contains(value) else { return }
        selectedValue.accept(value)
    }
    
    /// 선택 UI 반영
    private func applySelection(_ value: Value) {
        for (i, btn) in buttons.enumerated() {
            let isSelected = (values[i] == value)
            btn.isSelected = isSelected
            btn.isEnabled = !isSelected // 선택된 버튼은 비활성(토글 방지)
            
            if !appearance.useSelectedStateImage {
                let image = isSelected ? appearance.selectedImage : appearance.deselectedImage
                btn.setImage(image, for: .normal)
            }
            
            // 접근성 라벨 개선(선택됨/해제됨)
            let baseLabel = btn.accessibilityLabel ?? btn.titleLabel?.text ?? "option"
            btn.accessibilityLabel = isSelected ? "\(baseLabel), 선택됨" : baseLabel
        }
    }
    
    /// index → value 헬퍼
    func asIndexDriver() -> Driver<Int> {
        selectedValue
            .map { [weak self] v in self?.values.firstIndex(of: v) ?? 0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    /// value Driver
    func asValueDriver() -> Driver<Value> {
        selectedValue.asDriver(onErrorDriveWith: .empty())
    }
}

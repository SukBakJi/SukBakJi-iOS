//
//  BottomSheetView.swift
//  Sukbakji
//
//  Created by jaegu park on 1/4/25.
//

import UIKit
import Then
import SnapKit

final class BottomSheetViewController: UIViewController {
    enum BottomSheetViewState {
        case expanded
        case normal
    }
    private let dimmedView = UIView().then {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.2)
        $0.alpha = 0
    }
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.cornerCurve = .continuous
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    private let dragIndicatorView = UIView().then {
        $0.backgroundColor = .gray300
        $0.layer.cornerRadius = 1.5
        $0.alpha = 0
    }
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    // 열린 BottomSheet의 기본 높이를 지정하기 위한 프로퍼티
    var defaultHeight: CGFloat = 500
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    var bottomSheetPanMinTopConstant: CGFloat = 150
    // pannedGesture 활성화 여부
    var isPannedable: Bool = false
    
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    
    private let contentViewController: UIViewController
    
    init(contentViewController: UIViewController, defaultHeight: CGFloat, bottomSheetPanMinTopConstant: CGFloat, isPannedable: Bool = false) {
        self.contentViewController = contentViewController
        self.defaultHeight = defaultHeight
        self.bottomSheetPanMinTopConstant = bottomSheetPanMinTopConstant
        self.isPannedable = isPannedable
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureLayout()
        self.configureDimmedTapGesture()
        
        if isPannedable {
            self.configureViewPannedGesture()
            self.dragIndicatorView.alpha = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showBottomSheet()
    }
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            self?.showBottomSheet()
        }
    }
    
    private func showBottomSheet(atState: BottomSheetViewState = .normal) {
        if atState == .normal {
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            let constraintValue = (safeAreaHeight + bottomPadding) - defaultHeight
            
            if constraintValue > 0 {
                self.bottomSheetViewTopConstraint.constant = constraintValue
            } else {
                self.bottomSheetViewTopConstraint.constant = self.bottomSheetPanMinTopConstant
            }
            
        } else {
            self.bottomSheetViewTopConstraint.constant = self.bottomSheetPanMinTopConstant
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.dimmedView.alpha = self.dimAlphaWithBottomSheetTopConstraint(value: self.bottomSheetViewTopConstraint.constant)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension BottomSheetViewController {
    private func configureUI() {
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        view.addSubview(dragIndicatorView)
        
        addChild(contentViewController)
        bottomSheetView.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        bottomSheetView.clipsToBounds = true
    }
    
    private func configureLayout() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        bottomSheetViewTopConstraint.isActive = true
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentViewController.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            contentViewController.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])
        
        dragIndicatorView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(4)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.bottom.equalTo(bottomSheetView.snp.top).inset(24)
        }
    }
    
    private func configureDimmedTapGesture() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
    
    private func configureViewPannedGesture() {
        // Pan Gesture Recognizer를 view controller의 view에 추가하기 위한 코드
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
}

extension BottomSheetViewController {
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        self.hideBottomSheetAndGoBack()
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        
        let velocity = panGestureRecognizer.velocity(in: view)
        
        switch panGestureRecognizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
        case .changed:
            if bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanMinTopConstant {
                bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
            }
            
            dimmedView.alpha = dimAlphaWithBottomSheetTopConstraint(value: bottomSheetViewTopConstraint.constant)
        case .ended:
            if velocity.y > 1500 {
                hideBottomSheetAndGoBack()
                return
            }
            
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            let nearestValue = nearest(to: bottomSheetViewTopConstraint.constant, inValues: [bottomSheetPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            if nearestValue == bottomSheetPanMinTopConstant {
                showBottomSheet(atState: .expanded)
            } else if nearestValue == defaultPadding {
                // Bottom Sheet을 .normal 상태로 보여주기
                showBottomSheet(atState: .normal)
            } else {
                // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
                hideBottomSheetAndGoBack()
            }
        default:
            break
        }
    }
}

extension BottomSheetViewController {
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
        
    private func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha: CGFloat = 0.5
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        // bottom sheet의 top constraint 값이 fullDimPosition과 같으면
        // dimmer view의 alpha 값이 dimmedAlpha가 되도록 합니다
        let fullDimPosition = (safeAreaHeight + bottomPadding - defaultHeight) / 2
        
        // bottom sheet의 top constraint 값이 noDimPosition과 같으면
        // dimmer view의 alpha 값이 0.0이 되도록 합니다
        let noDimPosition = safeAreaHeight + bottomPadding
        
        // Bottom Sheet의 top constraint 값이 fullDimPosition보다 작으면
        // 배경색이 가장 진해진 상태로 지정해줍니다.
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        // Bottom Sheet의 top constraint 값이 noDimPosition보다 크면
        // 배경색이 투명한 상태로 지정해줍니다.
        if value > noDimPosition {
            return 0.0
        }
        
        // 그 외의 경우 top constraint 값에 따라 0.0과 dimmedAlpha 사이의 alpha 값이 Return되도록 합니다
        return fullDimAlpha * (1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }
}

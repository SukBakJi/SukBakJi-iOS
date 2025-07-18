//
//  BoardViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardViewModel {
    private let repository = BoardRepository()
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let latestQnAList = BehaviorRelay<[QnA]>(value: [])
    
    let boardSearchList = BehaviorRelay<[MyPost]>(value: [])
    
    let categoryList = BehaviorRelay<[String]>(value: [])
    
    let doctorMenuList = BehaviorRelay<[String]>(value: [])
    let selectDoctorMenuItem = BehaviorRelay<String?>(value: nil)
    
    let masterMenuList = BehaviorRelay<[String]>(value: [])
    let selectMasterMenuItem = BehaviorRelay<String?>(value: nil)
    
    let enterMenuList = BehaviorRelay<[String]>(value: [])
    let selectEnterMenuItem = BehaviorRelay<String?>(value: nil)
    
    var selectPostItem: Post?
    
    let errorMessage = PublishSubject<String>()
    
    init(useCase: BoardUseCase = BoardUseCase()) {
        self.useCase = useCase
    }
    
    func loadLatestQnA() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        BoardRepository.shared.fetchLatestQnA(token: token)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.latestQnAList.accept(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadBoardSearch(keyword: String, menu: String, boardName: String) {
        useCase.fetchBoardSearch(keyword: keyword, menu: menu, boardName: boardName)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                self?.boardSearchList.accept(detail)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("프로필 로딩 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadMenu(menu: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        BoardRepository.shared.fetchBoardsMenu(token: token, menu: menu)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.categoryList.accept(response)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadDoctorMenu() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        BoardRepository.shared.fetchBoardsMenu(token: token, menu: "박사")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.doctorMenuList.accept(response)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func selectDoctorMenu(_ menu: String?) {
        selectDoctorMenuItem.accept(menu)
    }
    
    func loadMasterMenu() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        BoardRepository.shared.fetchBoardsMenu(token: token, menu: "석사")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.masterMenuList.accept(response)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func selectMasterMenu(_ menu: String?) {
        selectMasterMenuItem.accept(menu)
    }
    
    func loadEnterMenu() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        BoardRepository.shared.fetchBoardsMenu(token: token, menu: "진학예정")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.enterMenuList.accept(response)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func selectEnterMenu(_ menu: String?) {
        selectEnterMenuItem.accept(menu)
    }
}

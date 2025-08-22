//
//  BoardViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import RxSwift
import RxCocoa

enum BoardMenu: String {
    case doctor = "박사"
    case master = "석사"
    case enter  = "진학예정"
    case free   = "자유"
}

final class BoardViewModel {
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let boardSearchList = BehaviorRelay<[MyPost]>(value: [])
    
    let categoryList = BehaviorRelay<[String]>(value: [])
    
    let doctorMenuList = BehaviorRelay<[String]>(value: [])
    let selectDoctorMenuItem = BehaviorRelay<String?>(value: nil)
    
    let masterMenuList = BehaviorRelay<[String]>(value: [])
    let selectMasterMenuItem = BehaviorRelay<String?>(value: nil)
    
    let enterMenuList = BehaviorRelay<[String]>(value: [])
    let selectEnterMenuItem = BehaviorRelay<String?>(value: nil)
    
    var selectPostItem: Post?
    
    let boardCreated = PublishSubject<Bool>()
    
    let selectedMenu = BehaviorRelay<BoardMenu>(value: .doctor)
    
    init(useCase: BoardUseCase = BoardUseCase()) {
        self.useCase = useCase
    }
    
    func loadBoardSearch(keyword: String, menu: String, boardName: String) {
        useCase.fetchSearchBoard(keyword: keyword, menu: menu, boardName: boardName)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.boardSearchList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadCategories(for menu: BoardMenu) {
        useCase.fetchBoardMenu(menu: menu.rawValue)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] items in
                self?.categoryList.accept(items)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadDoctorMenu() {
        useCase.fetchBoardMenu(menu: "박사")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.doctorMenuList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func selectDoctorMenu(_ menu: String?) {
        selectDoctorMenuItem.accept(menu)
    }
    
    func loadMasterMenu() {
        useCase.fetchBoardMenu(menu: "석사")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.masterMenuList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func selectMasterMenu(_ menu: String?) {
        selectMasterMenuItem.accept(menu)
    }
    
    func loadEnterMenu() {
        useCase.fetchBoardMenu(menu: "진학예정")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.enterMenuList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func selectEnterMenu(_ menu: String?) {
        selectEnterMenuItem.accept(menu)
    }
    
    func createBoard(boardName: String, description: String) {
        useCase.createBoard(boardName: boardName, description: description)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.boardCreated.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

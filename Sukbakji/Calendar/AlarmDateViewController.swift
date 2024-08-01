//
//  AlarmDateViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/22/24.
//

import UIKit

class AlarmDateViewController: UIViewController {
    
    @IBOutlet weak var dateView: UIView!
    
    private lazy var dismissButton = UIButton()
    private lazy var yearLabel = UILabel()
    private lazy var previousButton = UIButton()
    private lazy var monthLabel = UILabel()
    private lazy var nextButton = UIButton()
    private lazy var weekStackView = UIStackView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let calendar = Calendar.current
    private let dateYearFormatter = DateFormatter()
    private let dateMonthFormatter = DateFormatter()
    private var calendarYear = Date()
    private var calendarMonth = Date()
    
    private var days = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateView.layer.cornerRadius = 10

        self.configure()
    }
    
    private func configure() {
        self.configureDismissButton()
        self.configureYearLabel()
        self.configureNextButton()
        self.configureMonthLabel()
        self.configurePreviousButton()
        self.configureWeekStackView()
        self.configureWeekLabel()
        self.configureCollectionView()
        self.configureCalendar()
    }

    private func configureDismissButton() {
        self.dateView.addSubview(self.dismissButton)
        self.dismissButton.setImage(UIImage(named: "Sukbakji_Dismiss"), for: .normal)
        self.dismissButton.addTarget(self, action: #selector(didDismissButtonTouched), for: .touchUpInside)
        self.dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dismissButton.topAnchor.constraint(equalTo: self.dateView.topAnchor, constant: 12),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 20),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 20),
            self.dismissButton.trailingAnchor.constraint(equalTo: self.dateView.trailingAnchor, constant: -20),
        ])
    }
    
    private func configureYearLabel() {
        self.dateView.addSubview(self.yearLabel)
        self.yearLabel.text = "2024년"
        self.yearLabel.textColor = .black
        self.yearLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        self.yearLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.yearLabel.topAnchor.constraint(equalTo: self.dateView.topAnchor, constant: 56),
            self.yearLabel.leadingAnchor.constraint(equalTo: self.dateView.leadingAnchor, constant: 20),
        ])
    }
    
    private func configureNextButton() {
        self.dateView.addSubview(self.nextButton)
        self.nextButton.setImage(UIImage(named: "Sukbakji_Right"), for: .normal)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nextButton.topAnchor.constraint(equalTo: self.dismissButton.bottomAnchor, constant: 24),
            self.nextButton.widthAnchor.constraint(equalToConstant: 20),
            self.nextButton.heightAnchor.constraint(equalToConstant: 20),
            self.nextButton.trailingAnchor.constraint(equalTo: self.dateView.trailingAnchor, constant: -18),
        ])
    }
    
    private func configureMonthLabel() {
        self.dateView.addSubview(self.monthLabel)
        self.monthLabel.text = "7월"
        self.monthLabel.textColor = .black
        self.monthLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        self.monthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.monthLabel.topAnchor.constraint(equalTo: self.dismissButton.bottomAnchor, constant: 24),
            self.monthLabel.trailingAnchor.constraint(equalTo: self.nextButton.leadingAnchor, constant: -4),
        ])
    }
    
    private func configurePreviousButton() {
        self.dateView.addSubview(self.previousButton)
        self.previousButton.setImage(UIImage(named: "Sukbakji_LeftDisabled"), for: .normal)
        self.previousButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.previousButton.topAnchor.constraint(equalTo: self.dismissButton.bottomAnchor, constant: 24),
            self.previousButton.widthAnchor.constraint(equalToConstant: 20),
            self.previousButton.heightAnchor.constraint(equalToConstant: 20),
            self.previousButton.trailingAnchor.constraint(equalTo: self.monthLabel.leadingAnchor, constant: -4),
        ])
    }
    
    private func configureWeekStackView() {
        self.dateView.addSubview(self.weekStackView)
        self.weekStackView.distribution = .fillEqually
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.yearLabel.topAnchor, constant: 50),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.dateView.leadingAnchor, constant: 8),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.dateView.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureWeekLabel() {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            label.font = UIFont(name: "SUITE-SemiBold", size: 14)
            self.weekStackView.addArrangedSubview(label)
            
            if i == 0 {
                label.textColor = .black
            } else if i == 6 {
                label.textColor = .black
            } else {
                label.textColor = .black
            }
        }
    }
    
    private func configureCollectionView() {
        self.dateView.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AlarmDateCollectionViewCell.self, forCellWithReuseIdentifier: AlarmDateCollectionViewCell.identifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 0),
            self.collectionView.leadingAnchor.constraint(equalTo: self.dateView.leadingAnchor, constant: 8),
            self.collectionView.trailingAnchor.constraint(equalTo: self.dateView.trailingAnchor, constant: -8),
            self.collectionView.bottomAnchor.constraint(equalTo: self.dateView.bottomAnchor,  constant: 8)
        ])
    }
    
    private func configureCalendar() {
        let componentsYear = self.calendar.dateComponents([.year], from: Date())
        let componentsMonth = self.calendar.dateComponents([.month], from: Date())
        self.calendarYear = self.calendar.date(from: componentsYear) ?? Date()
        self.calendarMonth = self.calendar.date(from: componentsMonth) ?? Date()
        self.dateYearFormatter.dateFormat = "yyyy년"
        self.dateMonthFormatter.dateFormat = "MM월"
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarYear) - 1
    }
    
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarYear)?.count ?? Int()
    }
    
    private func updateTitle(){
        let dateYear = self.dateYearFormatter.string(from: self.calendarYear)
        let dateMonth = self.dateMonthFormatter.string(from: self.calendarMonth)
        self.yearLabel.text = dateYear
        self.monthLabel.text = dateMonth
    }
    
    private func updateDays(){
        self.days.removeAll()
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        for day in Int()..<totalDays {
            if day < startDayOfTheWeek {
                self.days.append("")
                continue
            }
            self.days.append("\(day - startDayOfTheWeek + 1)")
        }
        
        self.collectionView.reloadData()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    @objc private func didDismissButtonTouched(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: false)
    }
}

extension AlarmDateViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlarmDateCollectionViewCell.identifier, for: indexPath) as? AlarmDateCollectionViewCell else { return UICollectionViewCell() }
        cell.updateDay(day: self.days[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.weekStackView.frame.width / 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

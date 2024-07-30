//
//  CalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var AlertView: UIView!
    
    private lazy var weekStackView = UIStackView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    private var days = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateView.layer.cornerRadius = 10
        AlertView.layer.cornerRadius = 10
        
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configure() {
        self.configureWeekStackView()
        self.configureWeekLabel()
        self.configureCollectionView()
        self.configureCalendar()
    }
    
    private func configureWeekStackView() {
        self.DateView.addSubview(self.weekStackView)
        self.weekStackView.distribution = .fillEqually
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.DateView.topAnchor, constant: 20),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.DateView.leadingAnchor, constant: 8),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.DateView.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureWeekLabel() {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            label.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
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
        self.DateView.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 16),
            self.collectionView.leadingAnchor.constraint(equalTo: self.DateView.leadingAnchor, constant: 8),
            self.collectionView.trailingAnchor.constraint(equalTo: self.DateView.trailingAnchor, constant: -8),
            self.collectionView.bottomAnchor.constraint(equalTo: self.DateView.bottomAnchor,  constant: 8)
        ])
    }
    
    private func configureCalendar() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle(){
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.dayLabel.text = date
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
    
    @IBAction func School_Select_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolSelectVC") as? SchoolSelectViewController else {
            return
        }
        self.present(nextVC, animated: true)
    }
    
    @IBAction func Alarm_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "CalendarFBCVC") as? CalendarFBCViewController else {
            return
        }
        self.present(nextVC, animated: false)
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
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

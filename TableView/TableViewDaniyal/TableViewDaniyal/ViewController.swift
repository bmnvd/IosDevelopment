//
//  ViewController.swift
//  TableViewDaniyal
//
//  Created by Daniyal Baimenov on 13.12.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let sectionTitles = [
        "🎬 Favorite Movies",
        "🎧 Favorite Music",
        "📚 Favorite Books",
        "💻 Favorite University Courses"
    ]
    
    private var data: [[FavoriteItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Favorites"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseIdentifier)
        
        loadData()
    }
    
    private func loadData() {
        let movies: [FavoriteItem] = [
            .init(imageName: "harryPotter", title: "Гарри Поттер: Дары Смерти", subtitle: "Фэнтези", review: "Эпическое завершение саги о Гарри Поттере."),
            .init(imageName: "twilight", title: "Сумерки: Затмение", subtitle: "Романтика", review: "Драматичная история любви вампира и девушки.")
        ]
        
        let music: [FavoriteItem] = [
            .init(imageName: "hitTheRoadJack", title: "Hit the Road Jack", subtitle: "Ритм-н-блюз", review: "Классический хит, который не теряет актуальности."),
            .init(imageName: "babyBieber", title: "Baby", subtitle: "Justin Bieber", review: "Поп-хит, который сделал Джастина знаменитым.")
        ]
        
        let books: [FavoriteItem] = [
            .init(imageName: "richestBabylon", title: "Самый богатый человек в Вавилоне", subtitle: "Джордж Клейсон", review: "Классика по финансовой грамотности и мудрости.")
        ]
        
        data = [movies, music, books]
        tableView.reloadData()
    }
}

// MARK: - UITableView DataSource & Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .systemGroupedBackground
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = sectionTitles[section]
        
        header.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else {
            fatalError("Unable to dequeue FavoriteCell")
        }
        
        cell.configure(with: data[indexPath.section][indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}

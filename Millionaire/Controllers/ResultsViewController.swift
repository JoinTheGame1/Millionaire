//
//  ResultsViewController.swift
//  Millionaire
//
//  Created by Никитка on 05.12.2021.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let statisticsService = StatisticsService()
    var data: [GameStatistics]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.isNavigationBarHidden = true
        data = statisticsService.fetch()
        tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let stats = data?[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text = stats.text.uppercased()
        return cell
    }
    
    
}

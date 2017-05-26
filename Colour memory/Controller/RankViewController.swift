//
//  RankViewController.swift
//  Colour memory
//
//  Created by Liguo Jiao on 25/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import UIKit
import RealmSwift

class RankViewController: UITableViewController {
    var realm: Realm?
    var userInfo: Results<User>?
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            realm = try Realm()
        } catch let error {
            //error handle
            assertionFailure(error.localizedDescription)
        }
        self.navigationItem.title = "Rank"
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = CMbackgroundColor
        userInfo = realm?.objects(User.self).sorted(byKeyPath: "points", ascending: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rankViewCell", for: indexPath) as? RankTableViewCell else {
            return UITableViewCell()
        }
        if let haha = userInfo {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            cell.nameLabel.text = haha[indexPath.row].name
            cell.pointLabel.text = "\(haha[indexPath.row].points) Pts "
            cell.dateLabel.text = formatter.string(from: haha[indexPath.row].recordDate as Date)
            if indexPath.row == 0 {
                cell.imageViewWidth.constant = 50
                cell.pointLabel.textColor = .red
                cell.metalImageView.image = UIImage(named: "medal")
            }

        }
        return cell
    }
    
}

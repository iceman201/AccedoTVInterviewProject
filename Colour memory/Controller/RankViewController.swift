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
            assertionFailure(error.localizedDescription)
        }
        self.navigationItem.title = "Rank"
        styleSheet()
        userInfo = realm?.objects(User.self).sorted(byKeyPath: "points", ascending: false)
    }
    
    fileprivate func styleSheet() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = CMbackgroundColor
        navigationController?.navigationBar.barTintColor = CMGreenColor
        navigationController?.navigationBar.tintColor = CMTextLabelColor
        navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: CMTextLabelColor])
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
        if let info = userInfo {
            let formatter = DateFormatter()
            let maxPoint = userInfo?[0].points
            formatter.dateFormat = "dd.MM.yyyy"
            cell.nameLabel.text = info[indexPath.row].name
            cell.pointLabel.text = "\(info[indexPath.row].points)"
            cell.dateLabel.text = formatter.string(from: info[indexPath.row].recordDate as Date)
            if Int(cell.pointLabel.text ?? "0") == maxPoint {
                print(indexPath.row)
                cell.pointLabel.textColor = .red
                cell.metalImageView.image = UIImage(named: "medal")
            }
            cell.pointLabel.text = "\(cell.pointLabel.text ?? "0") Pts"
        }
        return cell
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

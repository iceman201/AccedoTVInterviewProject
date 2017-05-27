//
//  CollectionViewController.swift
//  Colour memory
//
//  Created by Liguo Jiao on 26/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "cardView"

class GameCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var firstCard: Int?
    var firstCardIndex: Int?
    var secondCard: Int?
    var score = 0
    var totalNumberOfCards = 16
    var currentUser: User?
    lazy var randomArray: [Int] = {
        return [].randomPairs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleSheet()
        self.collectionView?.backgroundColor = CMbackgroundColor
        self.collectionView?.register(UINib.init(nibName: "CardViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 50.0, left: 0, bottom: 0, right: 0)
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    fileprivate func styleSheet() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Score: \(score)"
        navigationController?.navigationBar.barTintColor = CMGreenColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CMTextLabelColor]
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CardViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width  - 30) / 4
        let height = width + 25
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardViewCell else {
            return
        }
        cell.tapCardView(colourIndex: indexPath.row, randomArray: randomArray) { (index) in
            guard let cardIndex = index else {
                return
            }
            if self.firstCard == nil {
                self.firstCardIndex = indexPath.row
                self.firstCard = cardIndex
            } else {
                guard self.firstCardIndex != indexPath.row else {
                    return
                }
                let indexSet = [self.firstCardIndex!, indexPath.row]
                if cardIndex == self.firstCard {
                    self.score += 2
                    self.totalNumberOfCards -= 2
                    if self.totalNumberOfCards == 0 {
                        self.alertMessages(title: "WIN!!!", message: "Please enter your name")
                    }
                    self.animateCell(cellIndexs: indexSet, isFadeOut: true)
                    cell.isUserInteractionEnabled = false
                    self.firstCard = nil
                    self.firstCardIndex = nil
                } else {
                    self.animateCell(cellIndexs: indexSet, isFadeOut: false)
                    // Is the score could go negative points?
                    self.score -= 1
                    // If not solution is here
                    self.score = self.score < 0 ? 0 : self.score
                    self.firstCard = nil
                    self.firstCardIndex = nil
                }
                self.navigationItem.title = "Score: \(self.score)"
            }
        }
    }
    
    fileprivate func alertMessages(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Please enter Your name"
        }
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (_)in
            if let field = alert.textFields?[0] {
                if field.text == "" { field.text = "Ghost O_O" }
                self.currentUser = User()
                if self.currentUser?.checkNameExist(inputName: field.text ?? "") == true {
                    do {
                        let realm = try Realm()
                        if let existUser = realm.objects(User.self).filter("name == '\(field.text ?? "")'").first {
                            self.writeIntoRealm(sourceRealm: realm, user: existUser, name: nil, isUpdate: true)
                        }
                    } catch let error {
                        assertionFailure(error.localizedDescription)
                    }
                } else {
                    do {
                        let realm = try Realm()
                        self.writeIntoRealm(sourceRealm: realm, user: nil, name: field.text ?? "", isUpdate: true)
                    } catch let error {
                        assertionFailure(error.localizedDescription)
                    }
                }
            }
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func writeIntoRealm(sourceRealm: Realm, user: User?, name: String?, isUpdate: Bool) {
        self.currentUser?.points = self.score
        let today = NSDate()
        self.currentUser?.recordDate = today
        if let targetUser = user {
            self.currentUser?.id = targetUser.id
            self.currentUser?.name = targetUser.name
        } else {
            if let generateID = self.currentUser?.increaseID() {
                self.currentUser?.id = generateID
            }
            self.currentUser?.name = name ?? ""
        }
        do {
            try sourceRealm.write {
                if let recordUser = self.currentUser {
                    sourceRealm.add(recordUser, update: isUpdate)
                } else {
                    assertionFailure("Fail on grab current user  <Realm>")
                }
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
    }

    fileprivate func animateCell(cellIndexs:[Int], isFadeOut: Bool) {
        for eachIndex in cellIndexs {
            guard let cell = self.getCellAtIndex(index: eachIndex, sectionNumber: 0) else {
                assertionFailure("Animate Cell Error")
                return
            }
            if isFadeOut {
                cell.fadeOut()
            } else {
                cell.flipBack()
            }
        }
    }
    
    fileprivate func getCellAtIndex(index:Int, sectionNumber: Int) -> CardViewCell? {
        let index = IndexPath.init(row: index, section: sectionNumber)
        guard let cell = collectionView?.cellForItem(at: index) as? CardViewCell else {
            return nil
        }
        return cell
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Score: \(score)"
        self.collectionView?.backgroundColor = CMbackgroundColor
        self.collectionView!.register(UINib.init(nibName: "CardViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 50.0, left: 0, bottom: 0, right: 0)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
        
        cell.tapCardView(colourIndex: indexPath.row) { (index) in
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
    
    func alertMessages(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Please enter Your name"
        }
        // if name is empty should ask again
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (_)in
            if let field = alert.textFields?[0] {
                self.currentUser = User()
                if self.currentUser?.checkNameExist(inputName: field.text ?? "") == true {
                    
                    let realm = try! Realm()
                    let existUser = realm.objects(User.self).filter("name == '\(field.text ?? "")'").first
                    self.currentUser?.id = (existUser?.id)!
                    self.currentUser?.name = (existUser?.name)!
                    self.currentUser?.points = self.score
                    let today = NSDate()
                    self.currentUser?.recordDate = today
                    try! realm.write {
                        realm.add(self.currentUser!, update: true)
                    }
                } else {
                    self.currentUser?.name = field.text ?? ""
                    self.currentUser?.points = self.score
                    self.currentUser?.id = (self.currentUser?.increaseID())!
                    let today = NSDate()
                    self.currentUser?.recordDate = today
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(self.currentUser!, update: false)
                    }
                }
                
            }
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
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

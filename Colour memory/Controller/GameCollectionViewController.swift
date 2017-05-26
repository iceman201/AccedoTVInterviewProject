//
//  CollectionViewController.swift
//  Colour memory
//
//  Created by Liguo Jiao on 26/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cardView"

class GameCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var firstCard: Int?
    var firstCardIndex: Int?
    var secondCard: Int?
    var score = 0
    var totalNumberOfCards = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Score: \(score)"
        self.collectionView!.register(UINib.init(nibName: "CardViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 50.0, left: 0, bottom: 0, right: 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
                    print("haha")
                    self.score += 2
                    self.totalNumberOfCards -= 2
                    self.animateCell(cellIndexs: indexSet, isFadeOut: true)
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
    func animateCell(cellIndexs:[Int], isFadeOut: Bool) {
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
    
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

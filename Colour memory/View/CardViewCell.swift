//
//  CardViewCell.swift
//  Colour memory
//
//  Created by Liguo Jiao on 26/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell {
    @IBOutlet var cardImageView: UIImageView!
    var isFlipped: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isFlipped = false
        cardImageView.image = UIImage(named: "card-bg")
    }
    
    func tapCardView(colourIndex: Int, completed: @escaping (_ index:Int?) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.cardImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }, completion: { (Done) in
            if Done {
                let index = (colourIndex+1)%8 == 0 ? 8 : (colourIndex+1)%8
                self.cardImageView.image = UIImage(named: "colour\(index)")
                completed(index)
            } else {
                completed(nil)
            }
        })
    }
    
    func flipBack() {
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseInOut, animations: {
            self.cardImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (Done) in
            if Done {
                self.cardImageView.image = UIImage(named: "card-bg")
            }
        })
    }

}
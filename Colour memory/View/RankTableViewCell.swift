//
//  RankTableViewCell.swift
//  Colour memory
//
//  Created by Liguo Jiao on 26/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var metalImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        metalImageView.layer.cornerRadius = metalImageView.bounds.width / 2
        metalImageView.clipsToBounds = true
        nameLabel.textColor = CMTextLabelColor
        dateLabel.textColor = CMTextLabelColor.withAlphaComponent(0.5)
        pointLabel.textColor = CMTextLabelColor
        
        self.backgroundColor = CMbackgroundColor
        self.selectionStyle = .none
    }
}

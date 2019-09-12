//
//  OptionTableViewCell.swift
//  pattern-matching-game
//
//  Created by Joshua Kuan on 9/11/19.
//  Copyright © 2019 Joshua Kuan. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        
        // Notification post handled in HomeViewController
        switch sender.tag {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name("rowChanged"), object: self)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("colChanged"), object: self)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("patternMatchesChanged"), object: self)
        default:
            return
        }
    }
}

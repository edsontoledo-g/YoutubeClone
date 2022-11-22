//
//  OptionCell.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/11/22.
//

import UIKit

class OptionCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            highlightTitle(isSelected ? UIColor(named: "whiteColor")! : UIColor(named: "grayColor")!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func highlightTitle(_ color: UIColor) {
        titleLabel.textColor = color
    }

    func configure(with option: String) {
        titleLabel.text = option
    }
}

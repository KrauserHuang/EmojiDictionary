//
//  EmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by Tai Chin Huang on 2022/3/11.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        contentView.addShadow(offset: CGSize.init(width: 0, height: 3), color: .black, radius: 2, opacity: 0.35)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with emoji: Emoji) {
        symbolLabel.text = emoji.symbol
        nameLabel.text = emoji.name
        descriptionLabel.text = emoji.description
    }

}

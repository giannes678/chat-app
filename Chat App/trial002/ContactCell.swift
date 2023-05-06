//
//  MessageCell.swift
//  trial002
//
//  Created by Mikael Giannes M. Bernardino on 3/26/23.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var letterBubbleView: UIView!
    @IBOutlet weak var letterBubble: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
        // Initialization code
        letterBubbleView.layer.cornerRadius = letterBubbleView.frame.size.height / 2
//        print(label.text)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  TableViewCell.swift
//  MindteckDemo
//
//  Created by Magenta on 28/10/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    static let cell = "TableViewCell"

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var itemImageView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

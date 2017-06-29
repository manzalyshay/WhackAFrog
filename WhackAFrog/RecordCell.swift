//
//  RecordCell.swift
//  WhackAFrog
//
//  Created by admin on 29/06/2017.
//  Copyright © 2017 Anya&Qusay. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    @IBOutlet weak var recordPlace: UILabel!
    @IBOutlet weak var recordName: UILabel!
    @IBOutlet weak var recordScore: UILabel!
    @IBOutlet weak var recordLevel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

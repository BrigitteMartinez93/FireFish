//
//  CommentsCell.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var body: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

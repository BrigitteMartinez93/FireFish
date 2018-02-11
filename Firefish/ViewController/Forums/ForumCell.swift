
//
//  ForumCell.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit

class ForumCell: UITableViewCell {

    @IBOutlet weak var numComments: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

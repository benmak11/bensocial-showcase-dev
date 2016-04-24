//
//  PostCell.swift
//  bensocial-showcase-dev
//
//  Created by Baynham Makusha on 4/23/16.
//  Copyright © 2016 Ben Makusha. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    override func drawRect(rect: CGRect) {
    
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }


}

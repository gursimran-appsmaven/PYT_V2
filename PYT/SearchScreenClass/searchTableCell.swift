//
//  searchTableCell.swift
//  PYT
//
//  Created by Niteesh on 17/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class searchTableCell: UITableViewCell {
    
    
    @IBOutlet var locationImage: UIImageView!
    
    @IBOutlet var backShadow: UIView!
    @IBOutlet var backView: UIView!
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet weak var profileBorder: UIImageView!
    @IBOutlet var bloggerName: UILabel!
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var blogsBtnLbl: UIButton!
    
    @IBOutlet weak var likesBtnLbl: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backShadow.layer.cornerRadius = 5.0
        self.backShadow.layer.masksToBounds = true
//        self.createShadow()
    }
    
    func createShadow() {
       // self.backView.applyHoverShadow(view: self.backView)
    }
    

    
}

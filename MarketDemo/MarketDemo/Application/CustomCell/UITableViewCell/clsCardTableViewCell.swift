//
//  clsCardTableViewCell.swift
//  StoreDemo
//
//  Created by vivek gajbe on 11/04/17.
//  Copyright © 2017 Vivek Gajbe. All rights reserved.
//

import UIKit

class clsCardTableViewCell: UITableViewCell {
    //MARK:- Variable Declaration
    
    @IBOutlet var viwBG: UIView!
    @IBOutlet var imgItem: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    
    @IBOutlet var lblVendorName: UILabel!
    
    @IBOutlet var lblVendorAdd: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet var btnDeleteFromCard: UIButton!
    @IBOutlet var btnCallVender: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

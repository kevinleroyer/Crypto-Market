//
//  CustomCurrencyCell.swift
//  Crypto Market
//
//  Created by Kévin Leroyer on 18-03-02.
//  Copyright © 2018 Kévin Leroyer. All rights reserved.
//

import UIKit

class CustomCurrencyCell: UITableViewCell {

    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyShortName: UILabel!
    @IBOutlet weak var currencyValue: UILabel!
    @IBOutlet weak var currencyChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

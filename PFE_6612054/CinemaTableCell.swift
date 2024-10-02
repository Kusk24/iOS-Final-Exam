//
//  CinemaTableCell.swift
//  PFE_6612054
//
//  Created by Win Yu Maung on 02/10/2024.
//

import UIKit

class CinemaTableCell: UITableViewCell {
    @IBOutlet weak var MyImage: UIImageView!
    @IBOutlet weak var CinemaName: UILabel!
    @IBOutlet weak var CinemaLocation: UILabel!
    @IBOutlet weak var FavoriteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

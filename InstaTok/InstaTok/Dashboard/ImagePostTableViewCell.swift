//
//  ImagePostTableViewCell.swift
//  InstaTok
//
//  Created by uprightclear on 11/18/22.
//

import UIKit

class ImagePostTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var caption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}

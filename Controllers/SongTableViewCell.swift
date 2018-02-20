//
//  SongTableViewCell.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 19/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var ArtistSongName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

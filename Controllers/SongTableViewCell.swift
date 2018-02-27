//
//  SongTableViewCell.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 19/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    var onButtonTap : (() -> Void)? = nil
    var is_like: Bool = false
    
    @IBOutlet weak var SongName: UILabel!
    @IBOutlet weak var ArtistName: UILabel!
    @IBOutlet weak var like_counter_label: UILabel!
    @IBOutlet weak var SongImage: UIImageView!
    @IBOutlet weak var HeartImage: UIButton!
    @IBAction func HeartAction(_ sender: UIButton) {
        LikeHandle(c: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func LikeHandle(c: SongTableViewCell) {
        if(c.is_like){
            c.is_like = false
            c.like_counter_label.text! = String(Int(c.like_counter_label.text!)!+1)
            c.HeartImage.setBackgroundImage(UIImage(named: "emptyheart"), for: UIControlState.normal)
        }else{
            c.is_like = true
            c.like_counter_label.text! = String(Int(c.like_counter_label.text!)!-1)
            c.HeartImage.setBackgroundImage(UIImage(named: "fullheart"), for: UIControlState.normal)
            let s = Song(event_id: Model.this_event.id_code, song_name: c.SongName.text!, artist_name: c.ArtistName.text!, image: "")
            Model.instance.addLike(s: s, email: Model.this_user.email)
        }
    }

}

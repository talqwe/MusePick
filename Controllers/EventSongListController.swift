//
//  EventSongListController.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 03/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation
import UIKit
class EventSongListController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var data = [Song]()
    var like_dict = Dictionary<String,Like>()
    var like_counter_dict = Dictionary<String,Int>()

    
    @IBAction func AddSong(_ sender: Any) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = sb.instantiateViewController(withIdentifier: "AddSongController")
            show(nextViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SongTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "song_cell") as! SongTableViewCell
        let song = data[indexPath.row]
        cell.SongName.text = song.song_name
        cell.ArtistName.text = song.artist_name

        if(like_counter_dict[song.artist_name+":"+song.song_name] != nil){
            cell.HeartImage.setTitle(String(like_counter_dict[song.artist_name+":"+song.song_name]!), for: UIControlState.normal)
        }
//        cell.like_counter_label.text = String(0)

        Model.instance.getImage(urlStr: song.image! , callback: { (image) in
            cell.SongImage.image = image
        })
        
        var heart_picture_name = "emptyheart"
        if(like_dict[Model.this_user.email+":"+song.artist_name+":"+song.song_name] != nil){
            cell.is_like = true
            heart_picture_name = "fullheart"
        }
        cell.HeartImage.setBackgroundImage(UIImage(named: heart_picture_name), for: UIControlState.normal)

        
        return cell
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        Model.getAllSongsAndObserve(eventID: Model.this_event.id_code)
        Model.getAllLikesAndObserve(eventID: Model.this_event.id_code)
        
        _ = ModelNotification.LikeList.observe { (list) in
            self.like_dict = list!

        }
        
        for (string,like) in self.like_dict{
            print("LikeLoop: "+string+": "+like.song_name)
            if(!(like_counter_dict[like.artist_name+":"+like.song_name] == nil)){
                like_counter_dict[like.artist_name+":"+like.song_name] = 1
            }else{
                like_counter_dict[like.artist_name+":"+like.song_name] = like_counter_dict[like.artist_name+":"+like.song_name]!+1
            }
        }
        
        _ = ModelNotification.SongList.observe { (list) in
            if list != nil {
                self.data = list!
                self.tableView.reloadData()
                
            }
        }
        
        self.tableView.frame = CGRect(x:0,y:10, width:self.view.frame.width,height:self.view.frame.height - 40);
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 50
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(self.tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




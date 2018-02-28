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
    var like_dict = [Like]()
    
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
        
        Model.instance.getImage(urlStr: song.image! , callback: { (image) in
            cell.SongImage.image = image
        })
        
        var heart_picture_name = "emptyheart"
        var counter: Int = 0
        
        for like in like_dict{
            if(song.artist_name == like.artist_name &&
            song.song_name == like.song_name &&
                Model.this_user.email == like.user_email){
                
                cell.is_like = true
                heart_picture_name = "fullheart"
            }
            if(song.artist_name == like.artist_name &&
                song.song_name == like.song_name){
                
                counter = counter+1
            }
        }
        
        cell.like_counter_label.text = String(counter)
        cell.HeartImage.setBackgroundImage(UIImage(named: heart_picture_name), for: UIControlState.normal)

        
        return cell
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        Model.getAllLikesAndObserve(eventID: Model.this_event.id_code)
        _ = ModelNotification.LikeList.observe { (list) in
            self.like_dict = list!
        }
        
        Model.getAllSongsAndObserve(eventID: Model.this_event.id_code)
        _ = ModelNotification.SongList.observe { (list) in
            if list != nil {
                self.data = list!
                self.tableView.reloadData()
                
            }
        }
        
        self.navigationItem.title = Model.this_event.name
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




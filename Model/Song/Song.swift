//
//  Song.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 19/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

class Song {
    var event_id: String
    var song_name: String
    var artist_name: String
    var image: String?
    var last_update: Date?
    
    init(s: Song) {
        self.event_id = s.event_id
        self.song_name = s.song_name
        self.artist_name = s.artist_name
        self.image = s.image
        self.last_update = s.last_update
    }
    
    init(event_id: String, song_name: String, artist_name: String, image: String) {
        self.event_id = event_id
        self.song_name = song_name
        self.artist_name = artist_name
        self.image = image
    }
    
    init(){
        self.event_id = ""
        self.song_name = ""
        self.artist_name = ""
        self.image = ""
        self.last_update = Date()
    }
    
    init(json:Dictionary<String,Any>){
        event_id = json["event_id"] as! String
        song_name = json["song_name"] as! String
        artist_name = json["artist_name"] as! String
        image = json["image"] as? String
        if let ts = json["last_update"] as? Double{
            last_update = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["event_id"] = self.event_id
        json["song_name"] = self.song_name
        json["artist_name"] = self.artist_name
        json["image"] = self.image
        json["last_update"] = Date().toFirebase()
        return json
    }
}



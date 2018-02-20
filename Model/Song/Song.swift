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
    var album_image: String
    var like_counter: Int
    var last_update: Date?
    
    init(s: Song) {
        self.event_id = s.event_id
        self.song_name = s.song_name
        self.artist_name = s.artist_name
        self.album_image = s.album_image
        self.like_counter = s.like_counter
        self.last_update = s.last_update
    }
    
    init(event_id: String, song_name: String, artist_name: String, album_image: String, like_counter: Int, last_update: Date) {
        self.event_id = event_id
        self.song_name = song_name
        self.artist_name = artist_name
        self.album_image = album_image
        self.like_counter = like_counter
        self.last_update = last_update
    }
    
    init(){
        self.event_id = ""
        self.song_name = ""
        self.artist_name = ""
        self.album_image = ""
        self.like_counter = 0
        self.last_update = Date()
    }
    
    init(json:Dictionary<String,Any>){
        event_id = json["event_id"] as! String
        song_name = json["song_name"] as! String
        artist_name = json["artist_name"] as! String
        album_image = json["album_image"] as! String
        like_counter = json["like_counter"] as! Int
        if let ts = json["last_update"] as? Double{
            last_update = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["event_id"] = self.event_id
        json["song_name"] = self.song_name
        json["artist_name"] = self.artist_name
        json["album_image"] = self.album_image
        json["like_counter"] = self.like_counter
        json["last_update"] = Date().toFirebase()
        return json
    }
}



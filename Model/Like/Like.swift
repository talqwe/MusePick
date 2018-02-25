//
//  Like.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 23/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

class Like {
    var event_id: String
    var song_name: String
    var artist_name: String
    var user_email: String
    
    init(l: Like) {
        self.event_id = l.event_id
        self.song_name = l.song_name
        self.artist_name = l.artist_name
        self.user_email = l.user_email
    }
    
    init(event_id: String, song_name: String, artist_name: String, user_email: String) {
        self.event_id = event_id
        self.song_name = song_name
        self.artist_name = artist_name
        self.user_email = user_email
    }
    
    init(){
        self.event_id = ""
        self.song_name = ""
        self.artist_name = ""
        self.user_email = ""
    }
    
    init(json:Dictionary<String,Any>){
        event_id = json["event_id"] as! String
        song_name = json["song_name"] as! String
        artist_name = json["artist_name"] as! String
        user_email = json["user_email"] as! String
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["event_id"] = self.event_id
        json["song_name"] = self.song_name
        json["artist_name"] = self.artist_name
        json["user_email"] = self.user_email
        return json
    }
}



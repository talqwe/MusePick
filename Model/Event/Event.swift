//
//  User.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 17/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

class Event {
    var id_code: String
    var name: String
    var last_update: Date?
    
    init(e: Event) {
        self.id_code = e.id_code
        self.name = e.name
        self.last_update = e.last_update
    }
    
    init(id_code: String, name: String, last_update: Date) {
        self.id_code = id_code
        self.name = name
        self.last_update = last_update
    }
    
    init(){
        self.id_code = ""
        self.name = ""
        self.last_update = Date()
    }
    
    init(json:Dictionary<String,Any>){
        id_code = json["id_code"] as! String
        name = json["name"] as! String
        if let ts = json["last_update"] as? Double{
            last_update = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["id_code"] = self.id_code
        json["name"] = self.name
        json["last_update"] = Date().toFirebase()
        return json
    }
}


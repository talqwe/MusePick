//
//  User.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 16/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

class User {
    var email: String
    var first_name: String
    var last_name: String
    var image_url: String?
    var login_type: String
    var last_update: Date?
    
    init(u: User) {
        self.email = u.email
        self.first_name = u.first_name
        self.last_name = u.last_name
        self.image_url = u.image_url
        self.login_type = u.login_type
        self.last_update = u.last_update
        
    }
    
    init(email: String, fn: String, ln: String, iu:String? = nil, lt: String) {
        self.email = email
        self.first_name = fn
        self.last_name = ln
        self.image_url = iu
        self.login_type = lt
    }
    
    init(){
        self.email = ""
        self.first_name = ""
        self.last_name = ""
        self.image_url = ""
        self.login_type = ""
    }
    
    init(json:Dictionary<String,Any>){
        email = json["email"] as! String
        first_name = json["first_name"] as! String
        last_name = json["last_name"] as! String
        if let im = json["image_url"] as? String{
            image_url = im
        }
        login_type = json["login_type"] as! String
        if let ts = json["last_update"] as? Double{
            self.last_update = Date.fromFirebase(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["email"] = email
        json["first_name"] = first_name
        json["last_name"] = last_name
        if (image_url != nil){
            json["image_url"] = image_url!
        }
        json["login_type"] = login_type
        json["last_update"] = Date().toFirebase()
        return json
    }
}

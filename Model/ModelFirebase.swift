//
//  ModelFirebase.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 16/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class ModelFirebase {
    
    static func AddUser(u:User, completionBlock:@escaping (Error?)->Void){
        let ref = Database.database().reference().child("users").child(u.email)
        ref.setValue(u.toFirebase())
        ref.setValue(u.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    static func AddSong(s:Song, completionBlock:@escaping (Error?)->Void){
        let ref = Database.database().reference().child("songs").child(s.event_id+":"+s.artist_name+":"+s.song_name)
        ref.setValue(s.toFirebase())
        ref.setValue(s.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    static func AddLike(l: Like, completionBlock:@escaping (Error?)->Void){
        let ref = Database.database().reference().child("likes").child(l.event_id+":"+l.user_email+":"+l.artist_name+":"+l.song_name)
        ref.setValue(l.toFirebase())
        ref.setValue(l.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    static func getUserById(id:String, callback:@escaping (User?)->Void){
        let ref = Database.database().reference().child("users").child(id)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let json = snapshot.value as? Dictionary<String,Any>
            if (json != nil){
                let u = User(json: json!)
                callback(u)
            } else { callback(nil) }
        })
    }
    
    static func getEventById(id:String, callback:@escaping (Event?)->Void){
        let ref = Database.database().reference().child("events").child(id)
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let json = snapshot.value as? Dictionary<String,Any>
            if (json != nil){
                let u = Event(json: json!)
                callback(u)
            } else { callback(nil) }
        })
    }
    
    static func getSongsByEventID(eventID: String, callback:@escaping ([Song]?)->Void){
        let ref = Database.database().reference().child("songs")
        
        ref.observe(.value, with: { (snapshot) in
            if let values = snapshot.value as? [String:[String:Any]]{
                var songs = [Song]()
                for json in values{
                    let s = Song(json: json.value)
                    songs.append(s)
                }
                callback(songs)
            }else{
                callback(nil)
            }
        })
    }
    
    static func getAllSongs(lastUpdateDate: Date?, callback:@escaping ([Song])->Void){
        let handler = {(snapshot:DataSnapshot) in
            var songs = [Song]()
            for child in snapshot.children.allObjects{
                if let childData = child as? DataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let s = Song(json: json)
                        songs.append(s)
                    }
                }
            }
            callback(songs)
        }
        
        let ref = Database.database().reference().child(Song.TABLE)
        if (lastUpdateDate != nil){
            print("q starting at:\(lastUpdateDate!) \(lastUpdateDate!.toFirebase())")
            let fbQuery = ref.queryOrdered(byChild:"last_update").queryStarting(atValue:lastUpdateDate!.toFirebase())
            fbQuery.observeSingleEvent(of: .value, with: handler)
        }else{
            ref.observeSingleEvent(of: .value, with: handler)
        }
    }
    
    static func clearObservers(){
        let ref = Database.database().reference().child("students")
        ref.removeAllObservers()
    }
    
    static func saveProfileImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let storageRef = Storage.storage().reference(forURL:
            "gs://musepick-83152.appspot.com")
        
        let filesRef = storageRef.child(name)
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.putData(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    
    static func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10000000, completion: {(data, error) in
            if (error == nil && data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }else{
                callback(nil)
            }
        })
    }
}


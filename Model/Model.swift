//
//  Model.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 16/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ModelNotificationBase<T>{
    var name:String?
    
    init(name:String){
        self.name = name
    }
    
    func observe(callback:@escaping (T?)->Void)->Any{
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(name!), object: nil, queue: nil) { (data) in
            if let data = data.userInfo?["data"] as? T {
                callback(data)
            }
        }
    }
    
    func post(data:T){
        NotificationCenter.default.post(name: NSNotification.Name(name!), object: self, userInfo: ["data":data])
    }
}

class ModelNotification{
    static let SongList = ModelNotificationBase<[Song]>(name: "SongListNotification")
    static let LikeList = ModelNotificationBase<[Like]>(name: "LikeListNotification")
    
    static func removeObserver(observer:Any){
        NotificationCenter.default.removeObserver(observer)
    }
}

class Model {
    static let instance = Model()
    static var this_user = User()
    static var this_event = Event()
    
    lazy var sql_model:SQLModel? = SQLModel()
    
    
    private init(){
    }
    
    func clear(){
        ModelFirebase.clearObservers()
    }
    
    // calls the add new User function to the local DB and the firebase, post the imgUrl to the observer
    func addUser(u:User){
        ModelFirebase.AddUser(u: u){(error) in
        }
        u.addUserToLocalDb(database: self.sql_model?.database)
    }
    
    // add new User to local DB
    func addNewUserToLocalDB(u: User){
        u.addUserToLocalDb(database: self.sql_model?.database)
    }
    
    func addNewEventToLocalDB(e: Event){
        e.addEventToLocalDb(database: self.sql_model?.database)
    }
    
    // gets an id of User and pull the data from firebase
    func getUserById(id:String, callback:@escaping (User?)->Void){
        let encodedID=id.replacingOccurrences(of: ".", with: ",")
        ModelFirebase.getUserById(id: encodedID) { (u) in
            if (u != nil) {
                callback(u!)
            } else {
                callback(nil)
            }
            
        }
    }
    
    func getEventByCodeId(id:String, callback:@escaping (Event?)->Void){
        let encodedID=id.replacingOccurrences(of: ".", with: ",")
        ModelFirebase.getEventById(id: encodedID) { (e) in
            if (e != nil) {
                callback(e!)
            } else {
                callback(nil)
            }
            
        }
    }
    
    func getSongsByEventId(id:String, callback:@escaping ([Song]?)->Void){
        let encodedID=id.replacingOccurrences(of: ".", with: ",")
        ModelFirebase.getSongsByEventID(eventID: encodedID) { (s) in
            callback(s)
        }
    }
    
    func getLikesByEventId(id:String, callback:@escaping ([Like])->Void){
        ModelFirebase.getLikesByEventID(eventID: id) { (s) in
            callback(s)
        }
    }
    
    func removeLike(identifier: String){
        ModelFirebase.removeLike(identifier: identifier)
    }
    
    static func getAllSongsAndObserve(eventID: String) {
        ModelFirebase.getSongsByEventID(eventID: eventID, callback: { (list) in
            ModelNotification.SongList.post(data: list!)
        })
    }
    
    static func getAllLikesAndObserve(eventID: String) {
        ModelFirebase.getLikesByEventID(eventID: eventID, callback: { (list) in
            ModelNotification.LikeList.post(data: list)
        })
    }
    
    // saves the profile image to firebase (storage) and local DB
    func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        ModelFirebase.saveProfileImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    // gets the image url and try to pull pull the image from firebase
    func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        if url != nil {
            let localImageName = url!.lastPathComponent
            if let image = self.getImageFromFile(name: localImageName){
                callback(image)
            } else {
                //2. get the image from Firebase
                ModelFirebase.getImageFromFirebase(url: urlStr, callback: { (image) in
                    if (image != nil){
                        //3. save the image localy
                        self.saveImageToFile(image: image!, name: localImageName)
                    }
                    //4. return the image to the user
                    callback(image)
                })
            }
        }
    }
    
    // save image to local db
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    
    // returns the path of the images in the local DB
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // get the image from the local DB by name
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    func addLike(s: Song, email: String){
        let like = Like(event_id: s.event_id, song_name: s.song_name, artist_name: s.artist_name, user_email: email)

        ModelFirebase.AddLike(l: like){(error) in}
        like.addLikeToLocalDb(database: self.sql_model?.database)
    }
    
    func addSong(s: Song, email: String){
        ModelFirebase.AddSong(s: s){(error) in}
        s.addSongToLocalDb(database: self.sql_model?.database)
        
        self.addLike(s: s, email: email)
    }
    
    func addNewSongToLocalDB(s: Song){
        s.addSongToLocalDb(database: self.sql_model?.database)
    }
    
}

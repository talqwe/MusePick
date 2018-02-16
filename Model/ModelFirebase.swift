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


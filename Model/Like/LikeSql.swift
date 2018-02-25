//
//  LikeSql.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 23/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

extension Like {
    static let TABLE = "likes"
    static let CODE = "CODE"
    static let NAME = "NAME"
    static let ANAME = "ANAME"
    static let EMAIL = "EMAIL"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + TABLE + " ( "
            + CODE + " TEXT, "
            + NAME + " TEXT, "
            + ANAME + " TEXT, "
            + EMAIL + " TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addLikeToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(database, "INSERT OR REPLACE INTO " + Like.TABLE
            + "("
            + Like.CODE + ","
            + Like.NAME + ","
            + Like.ANAME + ","
            + Like.EMAIL + ") VALUES (?,?,?,?);"
            , -1, &sqlite3_stmt, nil) == SQLITE_OK){
            
            let event_id = self.event_id.cString(using: .utf8)
            let sn = self.song_name.cString(using: .utf8)
            let an = self.artist_name.cString(using: .utf8)
            let email = self.user_email.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, event_id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, sn,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, an,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, email,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("New Like Row Successfully Addded to LocalDB")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
}

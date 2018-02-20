//
//  SongSql.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 19/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

extension Song {
    static let TABLE = "songs"
    static let CODE = "CODE"
    static let NAME = "NAME"
    static let ANAME = "ANAME"
    static let ALBUM = "ALBUM"
    static let LIKES = "LIKES"
    static let LAST = "LAST"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + TABLE + " ( "
            + CODE + " TEXT, "
            + NAME + " TEXT, "
            + ANAME + " TEXT, "
            + ALBUM + " TEXT, "
            + LIKES + " INT, "
            + LAST + " TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addSongToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(database, "INSERT OR REPLACE INTO " + Song.TABLE
            + "("
            + Song.CODE + ","
            + Song.NAME + ","
            + Song.ANAME + ","
            + Song.ALBUM + ","
            + Song.LIKES + ","
            + Song.LAST + ") VALUES (?,?,?,?,?);"
            , -1, &sqlite3_stmt, nil) == SQLITE_OK){
            
            let email = self.event_id.cString(using: .utf8)
            let fn = self.song_name.cString(using: .utf8)
            let ln = self.artist_name.cString(using: .utf8)
            var image_url = "".cString(using: .utf8)
            let like_counter = self.like_counter.cString(using: .utf8)
            if self.image_url != nil {
                image_url = self.image_url!.cString(using: .utf8)
            }
            
            sqlite3_bind_text(sqlite3_stmt, 1, email,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, fn,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, ln,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, image_url,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, login_type,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("New Song Row Successfully Addded to LocalDB")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
}

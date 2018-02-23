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
            + Song.LIKES + ") VALUES (?,?,?,?,?);"
            , -1, &sqlite3_stmt, nil) == SQLITE_OK){
            
            let event_id = self.event_id.cString(using: .utf8)
            let sn = self.song_name.cString(using: .utf8)
            let an = self.artist_name.cString(using: .utf8)
            var image = "".cString(using: .utf8)
            let like_counter = Int32(self.like_counter)
            if self.image != nil {
                image = self.image?.cString(using: .utf8)
            }
            
            sqlite3_bind_text(sqlite3_stmt, 1, event_id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, sn,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, an,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, image,-1,nil);
            sqlite3_bind_int(sqlite3_stmt, 5, like_counter);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("New Song Row Successfully Addded to LocalDB")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
}

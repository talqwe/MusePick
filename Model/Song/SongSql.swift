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
    static let LAST = "LAST"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + TABLE + " ( "
            + CODE + " TEXT, "
            + NAME + " TEXT, "
            + ANAME + " TEXT, "
            + ALBUM + " TEXT, "
            + LAST + " TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    static func getAllSongsFromLocalDbByEvent(eventID: String, database:OpaquePointer?)->[Song]{
        var songs = [Song]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from "+TABLE,-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                //need to change the sqlite3_column_text
                let event_id =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let song_name =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let artist_name =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let image =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,4))
                
                if(eventID == event_id){
                    let song = Song()
                    song.song_name = song_name!
                    song.artist_name = artist_name!
                    song.event_id = event_id!
                    song.image = image
                    
                    song.last_update = Date.fromFirebase(update)
                    songs.append(song)
                }
                
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return songs
    }
    
    func addSongToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(database, "INSERT OR REPLACE INTO " + Song.TABLE
            + "("
            + Song.CODE + ","
            + Song.NAME + ","
            + Song.ANAME + ","
            + Song.ALBUM + ") VALUES (?,?,?,?);"
            , -1, &sqlite3_stmt, nil) == SQLITE_OK){
            
            let event_id = self.event_id.cString(using: .utf8)
            let sn = self.song_name.cString(using: .utf8)
            let an = self.artist_name.cString(using: .utf8)
            var image = "".cString(using: .utf8)
            if self.image != nil {
                image = self.image?.cString(using: .utf8)
            }
            
            sqlite3_bind_text(sqlite3_stmt, 1, event_id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, sn,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, an,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, image,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("New Song Row Successfully Addded to LocalDB")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
}

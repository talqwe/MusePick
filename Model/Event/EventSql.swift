//
//  UserSql.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 16/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

extension Event {
    static let TABLE = "Events"
    static let ID = "ID"
    static let NAME = "NAME"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + TABLE + " ( "
            + ID + " TEXT PRIMARY KEY, "
            + NAME + " TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addEventToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(database, "INSERT OR REPLACE INTO " + Event.TABLE
            + "("
            + Event.ID + ","
            + Event.NAME + ") VALUES (?,?);"
            , -1, &sqlite3_stmt, nil) == SQLITE_OK){
            
            let id = self.id_code.cString(using: .utf8)
            let name = self.name.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name,-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("New Event Row Successfully Addded to LocalDB")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
}


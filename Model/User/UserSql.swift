//
//  UserSql.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 16/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

extension User {
    static let TABLE = "Users"
    static let EMAIL = "EMAIL"
    static let FNAME = "FNAME"
    static let LNAME = "LNAME"
    static let IMAGE_URL = "IMAGE_URL"
    static let LOGIN = "LOGIN"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + TABLE + " ( "
            + EMAIL + " TEXT PRIMARY KEY, "
            + FNAME + " TEXT, "
            + LNAME + " TEXT, "
            + IMAGE_URL + " TEXT, "
            + LOGIN + " TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addUserToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if(sqlite3_prepare_v2(database, "INSERT OR REPLACE INTO " + User.TABLE
            + "("
            + User.EMAIL + ","
            + User.FNAME + ","
            + User.LNAME + ","
            + User.IMAGE_URL + ","
            + User.LOGIN + ") VALUES (?,?,?,?,?);"
            , -1, &sqlite3_stmt, nil) == SQLITE_OK){
            
            let email = self.email.cString(using: .utf8)
            let fn = self.first_name.cString(using: .utf8)
            let ln = self.last_name.cString(using: .utf8)
            var image_url = "".cString(using: .utf8)
            let login_type = self.login_type.cString(using: .utf8)
            if self.image_url != nil {
                image_url = self.image_url!.cString(using: .utf8)
            }
            
            sqlite3_bind_text(sqlite3_stmt, 1, email,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, fn,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, ln,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, image_url,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, login_type,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully to students table")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
}

//
//  SqlCommonOperations.swift
//  Application
//
//  Created by vivek gajbe on 08/10/17.
//  Copyright © 2017 Vivek Gajbe. All rights reserved.
//

import UIKit

class SqlCommonOperations: NSObject {
    
    var database: OpaquePointer? = nil
    var statement: OpaquePointer? = nil
    let strDatabaseName = "MarketDemo.sqlite"
    
    /**
    Get data base path
    - Returns: String Database path
    */
    func getDBPath () -> String
    {
        var path = ""
        
        let paths =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        path = "\(paths[0])/\(strDatabaseName)"
//        print(path)
        return path
    }
    
    /**
    Copy database from bundle to a document folder if required
    */
    func copyDBIfNeeded()
    {
        var success=false;
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: getDBPath())
        
        if(success)
        {
            return
        }
        else
        {
            do
            {
                let source = (Bundle.main.resourcePath?.appendingFormat("/\(strDatabaseName)"))!
                try fileManager.copyItem(atPath: source, toPath: getDBPath())
            }
            catch _
            {
               print("Database is not available")
            }
        }
    }
    
    /**
    Open Database
    - Returns: Bool Database is opened or not
    */
    func openDB() -> Bool
    {
        copyDBIfNeeded()
        
       
        if sqlite3_open(getDBPath(), &database) == SQLITE_OK
        {
            return true
        }
        return false
    }
    
    /**
    Close database connection
    */
    func closeDB()
    {
        sqlite3_finalize(statement)
        sqlite3_close(database)
    }
    
    
    /**
    Executes the non query provided in parameter. (Like delete)
    - Parameters: query sql query
    */
    func executeNonQuery(query : String) -> Bool
    {
        if(openDB())
        {
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if (sqlite3_step(statement) != SQLITE_DONE)
                {
                    return false
                }
                sqlite3_reset(statement)
            }
            closeDB()
        }
        return true
    }
    
    
}

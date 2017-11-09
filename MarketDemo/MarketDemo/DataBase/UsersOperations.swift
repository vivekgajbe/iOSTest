//
//  UsersOperations.swift
//  Application
//
//  Created by vivek gajbe on 08/10/17.
//  Copyright © 2017 Vivek Gajbe. All rights reserved.
//

import UIKit

class UsersOperations: SqlCommonOperations {
    /**
    Save ProductToCard in local database
    */
    func saveProductToCard (entProductDetails : clsProductEntity) -> Bool
    {
        var b = Bool()
        if openDB()
        {
            let query = "SELECT count(productName) from cart where productName = '" + entProductDetails.strProductName! + "'"
           
            if(sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                var cnt = 0
                while sqlite3_step(statement) == SQLITE_ROW
                {
                    cnt = Int(sqlite3_column_int(statement, 0))
                }
                
                if (cnt>0)
                {
                    sqlite3_reset(statement)
                    sqlite3_finalize(statement)
                    sqlite3_close(database)
                    return false
                }
            }
            //this query is for
            let query1 = "INSERT OR REPLACE INTO Cart (productName , price, venderName, venderAdd, number,strImageUrl) VALUES(?,?,?,?,?,?)"
            
            if(sqlite3_prepare_v2(database, query1, -1, &statement, nil) == SQLITE_OK)
            {
                sqlite3_bind_text(statement, 1,(entProductDetails.strProductName! as NSString).utf8String , -1, nil)
                sqlite3_bind_text(statement, 2, (entProductDetails.strPrice! as NSString).utf8String , -1, nil)
                sqlite3_bind_text(statement, 3,(entProductDetails.strVendorName! as NSString).utf8String , -1, nil)
                sqlite3_bind_text(statement, 4, (entProductDetails.strVendorAddress! as NSString).utf8String , -1, nil)
                sqlite3_bind_text(statement, 5, (entProductDetails.strPhoneNumber! as NSString).utf8String , -1, nil)
                sqlite3_bind_text(statement, 6, (entProductDetails.strProductImg! as NSString).utf8String , -1, nil)
                
                if(sqlite3_step(statement) != SQLITE_DONE)
                {
                    print("SQLITE_DONE")
                }
                b = true
            }
            else
            {
                b = false
                print("error in insert :\(sqlite3_errmsg(database))")
            }
        }
        closeDB()
        return b
        
    }
    
    /**
     get all CardDetails information from local database
     */
    func getCartDetails () -> NSMutableArray
    {
        let arrmAllProduct = NSMutableArray()
        if(openDB())
        {
            let query = "select productName,price,venderName,venderAdd,number,strImageUrl from Cart"
            
            if (sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                
                while( sqlite3_step(statement) == SQLITE_ROW)
                {
                    let objProduct = clsProductEntity()
                    
                    
                    objProduct.strProductName = String(cString: sqlite3_column_text(statement, 0)!)
                    
                    objProduct.strPrice = String(cString: sqlite3_column_text(statement, 1)!)
                    objProduct.strVendorName = String(cString: sqlite3_column_text(statement, 2)!)
                    objProduct.strVendorAddress = String(cString: sqlite3_column_text(statement, 3)!)
                    objProduct.strPhoneNumber = String(cString: sqlite3_column_text(statement, 4)!)
                    objProduct.strProductImg = String(cString: sqlite3_column_text(statement, 5)!)
                    
                    
                    arrmAllProduct.add(objProduct)
                }
                sqlite3_finalize(statement)
            }
            else
            {
                print("Statement FAILED")
                
            }

        }
        return arrmAllProduct
    }
    
    /**
     delete ProductDetails information from local database
     */
    func delateProductDetailsFromCart (entProductDetails : clsProductEntity) -> Bool
    {
        
        if(openDB())
        {
            let query = "DELETE from Cart where productName = '" + entProductDetails.strProductName! + "'"
            
            if (sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK)
            {
                if(sqlite3_step(statement) != SQLITE_DONE)
                {
                    print("SQLITE_DONE")
                }
                closeDB()
                return true
            }
            else
            {
                print("error in delate :\(sqlite3_errmsg(database))")
               closeDB()
                return false
            }
            
        }
       return false
    }

}

//
//  Constants.swift
//  TestDemo
//
//  Created by vivek gajbe on 6/10/17.
//  Copyright © 2017 Vivek Gajbe. All rights reserved.
//

import UIKit

class Constants: NSObject
{
    
    static let objAppDel = UIApplication.shared.delegate as! AppDelegate
    static let strWebserviceURL = "https://mobiletest-hackathon.herokuapp.com/getdata/"
    
    static let AlertTitle = "MarketDemo"
    static let InternetNotFound = "Internet connection not available!"
    


    //CollectionView Identifier
    static let kColIdenProduct = "cellProduct"
    
    //TableView Identifier
    static let kTblIdenCellCart = "cellCard"
    
    
    // show Alert in swift
    internal static func showAlert(titleString:String,messageString:String , delegate:AnyObject){
        
        // if #available(iOS 8.0, *) {
        let alert = UIAlertController(title:titleString as String, message:messageString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        delegate.present(alert, animated: true, completion: nil)
        
        
    }
}
    

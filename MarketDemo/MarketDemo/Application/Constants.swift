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
    static let strWebserviceURL = "http://servicestest.touchbase.in/interview/api/Employee/ManageEmployee"
    
    static let AlertTitle = "TestDemo"
    static let InternetNotFound = "Internet connection not available!"
    
    //********************************************************/
    //*******************  Storyboard IDs  *******************/
    //********************************************************/
    
    static let kHomeScreen = "HomeViewController"
    static let kDetailScreen = "DetailViewController"
    
    static let kGetEmployee = "GetEmployee"
    static let kSaveEmployee = "SaveEmployee"
    static let kDeleteEmployee = "DeleteEmployee"


    // show Alert in swift
    internal static func showAlert(titleString:String,messageString:String , delegate:AnyObject){
        
        // if #available(iOS 8.0, *) {
        let alert = UIAlertController(title:titleString as String, message:messageString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        delegate.present(alert, animated: true, completion: nil)
        
        
    }
}

//
//  BaseClass.swift
//  TestDemo
//
//  Created by vivek gajbe on 6/10/17.
//  Copyright © 2017 Vivek Gajbe. All rights reserved.
//

import UIKit
import SystemConfiguration


class BaseClass: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - CheckInternet
    func checkInternet() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        
        return isReachable
    }
}

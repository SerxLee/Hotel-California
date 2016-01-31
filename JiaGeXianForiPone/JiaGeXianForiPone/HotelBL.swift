//
//  HotelBL.swift
//  JiaGeXianForiPone
//
//  Created by Serx on 1/31/16.
//  Copyright © 2016 serx. All rights reserved.
//

import Foundation

let BLQueryKeyFinishedNotification = "BLQueryKeyFinishedNotification"

let BLQueryKeyFailedNotification = "BLQueryKeyFailedNotification"

let BLQueryHotelFinishedNotification = "BLQueryHotelFinishedNotification"

let BLQueryHotelFailedNotification = "BLQueryHotelFailedNotification"

let HOST_NAME = "jiagexian.com"
let KEY_QUERY_URL = "/ajaxplcheck.mobile?method = mobilesuggest&v = 1&city = % @"
let HOTEL_QUERY_URL = "/hotelListForMobile.mobile?newSearch = 1"

public class HotelBL{
    
    public func selectKey(city: String){
        
        var strURL = NSString(format: KEY_QUERY_URL, city)
        strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        var op = engine.operationWithPath(strURL as String)
        
        op.addCompletionHandler({ (operation) -> Void in
            
            let data = operation.responseData()
            
            //完成
            let reDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            NSNotificationCenter.defaultCenter().postNotificationName(BLQueryKeyFinishedNotification, object: reDict)
            
            //失败
            }) { (errorOp, err) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(BLQueryKeyFailedNotification, object: err)
        }
        engine.enqueueOperation(op)
    }
}

class var sharedInstance: HotelBL{

    struct Static {
        static var instance: HotelBL?
        static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token){
        
        Static.instance = HotelBL()
    }
    return Static.instance
}
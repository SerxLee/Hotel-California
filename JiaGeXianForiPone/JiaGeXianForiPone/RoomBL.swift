//
//  RoomBL.swift
//  JiaGeXianForiPone
//
//  Created by Serx on 1/31/16.
//  Copyright © 2016 serx. All rights reserved.
//

import Foundation

let BLQueryRoomFinishedNotification = "BLQueryRoomFinishedNotification"

let BLQueryRoomFailedNotification = "BLQueryRoomFailedNotification"

let ROOM_QUERY_URL = "/priceline/hotelroom/hotelroomcache.mobile"
//"/priceline/hotelroom/hotelroomqunar.mobile"

public class RoomBL: NSObject{
    
    class var sharedInstance: RoomBL{
        
        struct Static {
            
            static var instance: RoomBL?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token){
            
            Static.instance = RoomBL()
        }
        return Static.instance!
    }
}

public func queryRoom(key_info: [NSObject: AnyObject]){
    
    var strURL = NSString(format: ROOM_QUERY_URL)
    strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    
    var params = [NSObject: AnyObject]()
    params["supplierid"] = key_info["hotelId"]
    params["fromDate"] = key_info["Checkin"]
    params["toDate"] = key_info["Checkout"]
    
    var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
    
    var op = engine.operationWithPath(strURL as String, params: params, httpMethod: "POST")
    
    op.addCompletionHandler({ (operation) -> Void in
        
        let data = operation.responseData()
        
        var error: NSError?
        
        var list = [AnyObject]()
        
        do {
            let tbxml = try TBXML(XMLData: data)
            
            if let root = tbxml?.rootXMLElement{
                
                let roomsElement = TBXML.childElementNamed("rooms", parentElement: root)
                
                if roomsElement != nil{
                    
                    var roomElement = TBXML.childElementNamed("room", parentElement: roomsElement)
                    
                    if roomElement != nil{
                        
                        var dict = [NSObject: AnyObject]()
                        
                        let name = TBXML.valueOfAttributeNamed("name", forElement: roomElement)
                        dict["name"] = name
                        
                        let frontprice = TBXML.valueOfAttributeNamed("frontprice", forElement: roomElement)
                        dict["frontprice"] = frontprice
                        
                        let  breakfast = TBXML.valueOfAttributeNamed("breakfast", forElement: roomElement)
                        dict["breakfast"] = breakfast
                        
                        let bed = TBXML.valueOfAttributeNamed("bed", forElement: roomElement)
                        dict["bed"] = bed
                        
                        let broadband = TBXML.valueOfAttributeNamed("broadband", forElement: roomElement)
                        dict["broadband"] = broadband
                        
                        let marketprice = TBXML.valueOfAttributeNamed("marketprice", forElement: roomElement)
                        dict["marketprice"] = marketprice
                        
                        let paymode = TBXML.valueOfAttributeNamed("paymode", forElement: roomElement)
                        dict["paymode"] = paymode
                        
                        roomElement = TBXML.nextSiblingNamed("room", searchFromElement: roomElement)
                        
                        list.append(dict)
                    }
                }
            }
        }catch{
        }
        
        NSLog("解析完成....")
        NSNotificationCenter.defaultCenter().postNotificationName(BLQueryHotelFinishedNotification, object: list)
        
        }) { (errorOp, err) -> Void in
            
            NSLog("MKNetwork请求错误：% @", err.localizedDescription)
            NSNotificationCenter.defaultCenter().postNotificationName(BLQueryHotelFailedNotification, object: err)
    }
    engine.enqueueOperation(op)
}
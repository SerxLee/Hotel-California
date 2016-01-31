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
    
    public func queryHotel(key_info: [NSObject: AnyObject]){
        
        var strURL = NSString(format: HOTEL_QUERY_URL)
        
        strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        var params = [NSObject: AnyObject]()
        params["f_pcityid"] = key_info["Plcityid"]
        params["currentPage"] = key_info["currentPage"]
        params["q"] = key_info["key"]
        
        let price = params["Price"] as! String
        
        if price == "价格不限"{
        
            params["priceSlider_minSliderDisplay"] = "￥0"
            params["priceSlider_maxSliderDisplay"] = "￥3000+"
            
        }else{
            
            let set = NSCharacterSet(charactersInString: "-->")
            let tempArray = price.componentsSeparatedByCharactersInSet(set)
            params["priceSlider_minSliderDisplay"] = tempArray[0]
            params["priceSlider_maxSliderDisplay"] = tempArray[3]
        }
        
        params["fromDate"] = key_info["Checkin"]
        params["toDate"] = key_info["checkout"]
        
        var engine=  MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        
        var op = engine.operationWithPath(strURL as String, params: params, httpMethod: "POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            
            //酒店查询
            let data = operation.responseData()
            var list = [AnyObject]()
            
            var error: NSError?
            
            do{
                let tbxml = try TBXML(XMLData: data)
                
                if let root = tbxml?.rootXMLElement{
                    
                    let hotel_listElement = TBXML.childElementNamed("hotel_list", parentElement: root)
                    
                    if hotel_listElement != nil{
                        
                        var hotelElement = TBXML.childElementNamed("hotel", parentElement: hotel_listElement)
                        
                        while hotelElement != nil{
                            
                            var dict = [NSObject: AnyObject]()
                            
                            let idElement = TBXML.childElementNamed("id", parentElement:hotelElement)
                            
                            if idElement != nil{
                                
                                dict["id"] = TBXML.textForElement(idElement)
                            }
                            
                            let descriptionElement = TBXML.childElementNamed("description", parentElement: hotelElement)
                            
                            if descriptionElement != nil{
                                
                                dict["description"] = TBXML.textForElement(descriptionElement)
                            }
                            
                            let imgElement = TBXML.childElementNamed("img", parentElement: hotelElement)
                            
                            if imgElement != nil{
                                
                                let src = TBXML.valueOfAttributeNamed("src", forElement: imgElement)
                                dict["img"] = src
                            }
                            
                            hotelElement = TBXML.nextSiblingNamed("hotel", searchFromElement: hotelElement)
                            
                            list.append(dict)
                        }
                    }
                }
            
            }catch let error as NSError{
            
            }
            NSLog("解析完成")
            NSNotificationCenter.defaultCenter().postNotificationName(BLQueryHotelFinishedNotification, object: list)
            
            }) { (errorOp, err) -> Void in
                
                NSLog("MKNetwork请求错误 % @ ", err.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName(BLQueryHotelFailedNotification, object: err)
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
//
//  EightBallModel.swift
//  Magic 8 Ball
//
//  Created by Matthew Saliba on 7/03/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import Foundation

class EightBallModel:CustomStringConvertible, CustomDebugStringConvertible {
    
    var description : String {
        
        var responseString = ""
        
        if let response = responseArray{
            for resp in response{
                
                responseString = responseString + ", " + resp
            }
        }
        
        return responseString
        
    }
    
    var debugDescription : String {
        
        return "Debug: " + description
        
    }
    
    let initialResponseArray = ["Maybe if you try a little harder","Reply hazy, come back tomorrow","It is decidely so","My sources say no","Ask again later","Don't count on it"];
    
    let circleImages = [ "circle1","circle2","circle3","circle4","circle5","circle6" ]
    
    var responseArray : [String]? = [String]()
    var circleArray : [String]? = [String]()
    
    
    /**
     Default Constructor. Sets the responseArray property with the initialResponseArray
     */
    
    init(){
        responseArray = initialResponseArray
        circleArray = circleImages
    }
    
    /**
     Default Constructor. Sets the responseArray property with the initialResponseArray
     and combines it with the extraResponseArray
     */
    
//    init(extraResponseArray : Array<String> ) {
//        responseArray?.appendContentsOf(initialResponseArray)
//        responseArray?.appendContentsOf(extraResponseArray)
//        
//        circleArray?.appendContentsOf(circleImages)
//    }
    
    func magicResponse() -> Int {
        
        if let responses = responseArray {
            let num = Int(arc4random_uniform(UInt32(responses.count)))
            return num
        }
        
        return 0
    }
    
    func getResponseByIndex(responseIndex : Int) -> String {
        
        return responseArray![responseIndex]
    }
    
    func magicCircle() -> String{
    
        if let circles = circleArray {
            let num = Int(arc4random_uniform(UInt32(circles.count)))
            return circles[num]
        }
        
        return ""
    }
    
    
    
    
    
}
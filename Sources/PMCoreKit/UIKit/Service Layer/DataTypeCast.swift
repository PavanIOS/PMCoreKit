//
//  DataTypeCast.swift
//  GPServiceApi
//
//  Created by Rahul K. on 04/04/19.
//

import Foundation

public class DataTypeCast {
    public func convertToInt(intStr:String, defValue:Int) -> Int {
        
        if (intStr != "") {
            let convertedInt : Int = Int(intStr) ?? defValue
            return convertedInt
        }
        return 0
    }
    
    public func convertToLong(dStr:String, defValue:Int32) -> Int32 {
        
        if (dStr != "") {
            let convertedLong : Int32 = Int32(dStr) ?? defValue
            return convertedLong
        }
        return defValue
    }
    
   public func convertToFloat(dStr:String, defValue:Float) -> Float {
        
        if (dStr != "") {
            let convertedFloat : Float = Float(dStr) ?? defValue
            return convertedFloat
        }
        return defValue
    }
    
   public func convertToDouble(dStr:String, defValue:Double) -> Double {
        
        if (dStr != "") {
            let convertedDouble : Double = Double(dStr) ?? defValue
            return convertedDouble
        }
        return defValue
    }
    
   public func convertToInteger(intStr:String) -> Int {
        
        if (intStr != "") {
            let convertedInt : Int = Int(intStr) ?? 0
            return convertedInt
        }
        return 0
    }
    
   public func convertToLong(dStr:String) -> Int32 {
        
        if (dStr != "") {
            let convertedLong : Int32 = Int32(dStr) ?? 0
            return convertedLong
        }
        return 0
    }
    
   public func convertToFloat(dStr:String) -> Float {
        
        if (dStr != "") {
            let convertedFloat : Float = Float(dStr) ?? 0.0
            return convertedFloat
        }
        return 0.0
    }
    
   public func convertToDouble(dStr:String) -> Double {
        
        if (dStr != "") {
            let convertedDouble : Double = Double(dStr) ?? 0
            return convertedDouble
        }
        return 0
    }
    
   public func round(value:Double, places:Int) -> Double {
        
        if (places < 0) {
            return value
        }
        let returnValue = (value * 10 * Double(places)).rounded() / 10 * Double(places)
        return returnValue
    }
    
}


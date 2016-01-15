//
//  Double+extension.swift
//  MudPlayerExample
//
//  Created by TimTiger on 16/1/15.
//  Copyright © 2016年 Mudmen. All rights reserved.
//

import Foundation

extension Double {
    var intValue: Int {
        if self.isNormal == true  {
            return Int(self)
        }
        return 0
    }
    
    var floatValue: Float {
        if self.isNormal == true {
            return Float(self)
        }
        return 0
    }
    
    var minutesAndSeconds: String {
        var resultString = ""
        var calcValue = self.intValue
        if (calcValue/3600 > 0) {
            calcValue %= 3600
        }
        
        if (calcValue/60 > 0) {
            resultString = resultString.stringByAppendingFormat("%.2d:", calcValue/60)
            calcValue %= 60
        } else {
            resultString = resultString.stringByAppendingString("00:")
        }
        
        if (calcValue > 0) {
            resultString = resultString.stringByAppendingFormat("%.2d", calcValue)
        } else {
            resultString = resultString.stringByAppendingString("00")
        }
        
        return resultString
    }
}
//
//  Methods.swift

import Foundation
import UIKit

//MARK: - Global Methods.....

func RGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
}


// DELAY
func RUN_AFTER_DELAY(_ delay: TimeInterval, block: @escaping ()->()) {
    let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time, execute: block)
}

func TO_STRING(_ obj : AnyObject?) -> String {
    if obj == nil {
        return ""
    }
    else if obj is String {
        return (obj as! String)
    }
    else if obj is NSString {
        return obj as! String
    }
    else if obj is NSNumber {
        return obj as! String
    }
    return ""
}

func TO_INT(_ obj : AnyObject?) -> Int {
    if obj == nil {
        return 0
    }
    else if let answer = obj as? Int {
        return answer
    }
    else if let answer = obj as? NSNumber {
        return answer.intValue
    }
    else if let answer = obj as? String {
        return (answer as NSString).integerValue
    }
    return 0
}

func TO_DOUBLE(_ obj : AnyObject?) -> Double {
    if obj == nil {
        return 0.0
    }
    else if let answer = obj as? Double {
        return answer
    }
    else if let answer = obj as? NSNumber {
        return Double(answer.doubleValue)
    }
    else if let answer = obj as? String {
        return (answer as NSString).doubleValue
    }
    return 0.0
}

func TO_BOOL(_ obj : AnyObject?) -> Bool {
    if obj == nil {
        return false
    }
    else if let answer = obj as? Int, answer == 1 {
        return true
    }
    else if let answer = obj as? NSNumber, answer == 1 {
        return true
    }
    
    return false
}

func PRINT_BLANK_LINES(howmany : Int) {
    for _ in 1...howmany {
        print()
    }
}

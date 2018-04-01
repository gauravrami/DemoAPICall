//
//  Pref.swift

import Foundation

let kIsLoggedIn = "IsLoggedIn"


class Pref {
    class func setNSObject(_ obj:NSObject? , forKey:String) {
        let userDefaults = UserDefaults.standard
        if obj == nil {
            userDefaults.set(nil, forKey: forKey)
            userDefaults.synchronize()
        }
        else {
            let data = NSKeyedArchiver.archivedData(withRootObject: obj!)
            userDefaults.set(data, forKey: forKey)
            userDefaults.synchronize()
        }
    }
    
    class func setAnyObject(_ obj:AnyObject? , forKey:String) {
        let userDefaults = UserDefaults.standard
        
        if obj == nil {
            userDefaults.set(obj, forKey: forKey)
            userDefaults.synchronize()
            return
        }
        else if obj is NSURL {
            userDefaults.set(obj as? URL, forKey: forKey)
        }
        else {
            userDefaults.set(obj, forKey: forKey)
        }
        userDefaults.synchronize()
    }
    
    class func getObjectForKey(_ theKey:String) -> AnyObject? {
        let userDefaults = UserDefaults.standard
        let resultObject = userDefaults.object(forKey: theKey)
        if resultObject != nil && resultObject is NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: resultObject as! Data) as AnyObject?
        }
        return UserDefaults.standard.object(forKey: theKey) as AnyObject?
    }
}


//
//  PatientProfileBean.swift

import UIKit

class ListBean: NSObject {
    
    var id : Int = 0
    var userId : Int = 0
    var title : String = ""
    var body : String = ""
    
    override init() {
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        self.userId = aDecoder.decodeObject(forKey: "userId") as! Int
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.body = aDecoder.decodeObject(forKey: "body") as! String
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.body, forKey: "body")
    }
}

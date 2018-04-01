//
//  ViewControllerExtension.swift

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    func showAlert(_ title : String , message : String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(actionOK)
        self.present(alertVC, animated: true, completion: nil)
    }
    func showAlert(_ title : String , message : String, completion : (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel) { (action : UIAlertAction) in
            if completion != nil {
                completion!()
            }
        }
        alertVC.addAction(actionOK)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlertForNoInternet() {
        let alertVC = UIAlertController(title: "Connection Error!", message: "Internet connection is not available", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(actionOK)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showHud() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Processing...")
    }
    
    func hideHud() {
         SVProgressHUD.dismiss()
    }
}


extension String {
    
    //Triming Functions
    func trimWhiteSpaces() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    func trimAllSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    func trimNewLines() -> String {
        return self.trimmingCharacters(in: CharacterSet.newlines)
    }
    func trimWhiteSpacesAndNewLines() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

extension CALayer {
    func setBorder(_ width: CGFloat, color : UIColor, cornerRadius : CGFloat) {
        self.borderWidth = width
        self.borderColor = color.cgColor
        self.cornerRadius = cornerRadius
    }
}

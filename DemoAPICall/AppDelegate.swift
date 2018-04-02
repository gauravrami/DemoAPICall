//
//  AppDelegate.swift
//  DemoAPICall

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        if UserDefaults.standard.value(forKey: kIsLoggedIn) as? Bool == true {
            self.goToAfterLoginVC()
        }
        return true
    }
    
    func goToAfterLoginVC() {
        
        let SBMain = UIStoryboard(name: "Main", bundle: nil)
        if let destinationVC = SBMain.instantiateViewController(withIdentifier: "AfterLoginNavigation") as? UINavigationController,
            let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            appDelegate.window?.rootViewController = destinationVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }

}


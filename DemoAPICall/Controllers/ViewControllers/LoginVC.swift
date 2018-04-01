//
//  LoginVC.swift
//  DemoAPICall


import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}

//MARK: - Initial Data Loading.
extension LoginVC {
    func initialSetup() {
       //self.viewBorder.layer.setBorder(2.0, color: UIColor.black, cornerRadius: 20.0)
        self.btnSignIn.layer.setBorder(1.0, color: UIColor.black, cornerRadius: 5.0)
    }
}

//MARK: - Button Tap Events.
extension LoginVC {
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        guard isFormValid() else {
            return
        }
        self.loginAPICall()
    }
}

//MARK: - Validation
extension LoginVC {
    func isFormValid() -> Bool {
        
        if txtEmail.text?.trimWhiteSpaces() == "" {
            self.showAlert("Alert!", message: "Please Enter The Email.")
            return false
        }
        else if txtPassword.text?.trimWhiteSpaces() == "" {
            self.showAlert("Alert!", message: "Please Enter The Password.")
            return false
        }
        
        return true
    }
}

//MARK: - Web Service Call For Login
extension LoginVC {
    func loginAPICall() {
        if txtEmail.text?.trimWhiteSpaces() == "admin@gmail.com" &&
            txtPassword.text?.trimWhiteSpaces() == "123456" {
            // Login Success
            self.goToAfterLoginVC()
        } else {
            self.showAlert("Login Error", message: "Invalid Email or Password.")
        }
    }
    
    func goToAfterLoginVC() {
        if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "AfterLoginNavigation") as? UINavigationController,
            let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            appDelegate.window?.rootViewController = destinationVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}

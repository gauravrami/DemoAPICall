//
//  SignUpVC.swift
//  DemoAPICall
//
//  Created by GAURAV RAMI on 02/04/18.
//  Copyright © 2018 GAURAV RAMI. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    var datePicker : UIDatePicker!
    var pickerGender : UIPickerView!
    
    let arrGenders = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

//MARK: - Initial Data Loading.
extension SignUpVC {
    func initialSetup() {
        self.btnSignUp.layer.setBorder(1.0, color: UIColor.black, cornerRadius: 5.0)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        txtDateOfBirth.inputView = datePicker
        
        pickerGender = UIPickerView()
        pickerGender.dataSource = self
        pickerGender.delegate = self
        txtGender.inputView = pickerGender
    }
}

//MARK: - Date Picker.
extension SignUpVC {
    func dateChanged(_ sender : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDateOfBirth.text = formatter.string(from: sender.date)
    }
}

//MARK: - Initial Data Loading.
extension SignUpVC : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrGenders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrGenders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtGender.text = arrGenders[row]
    }
}

//MARK: - Button Tap Events.
extension SignUpVC {
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        guard isFormValid() else {
            return
        }
        self.SignUpAPICall()
    }
}

//MARK: - Validation
extension SignUpVC {
    func isFormValid() -> Bool {
        if txtName.text?.trimWhiteSpaces() == "" {
            self.showAlert("Alert!", message: "Please Enter The Name.")
            return false
        }
        else if txtEmail.text?.trimWhiteSpaces() == "" {
            self.showAlert("Alert!", message: "Please Enter The Email.")
            return false
        }
        else if txtPassword.text?.trimWhiteSpaces() == "" {
            self.showAlert("Alert!", message: "Please Enter The Password.")
            return false
        }
        else if txtConfirmPassword.text?.trimWhiteSpaces() == "" {
            self.showAlert("Alert!", message: "Please Enter The Confirm Password.")
            return false
        }
        else if txtConfirmPassword.text?.trimWhiteSpaces() != txtPassword.text?.trimWhiteSpaces() {
            self.showAlert("Alert!", message: "The Password and The Confirm Password Must Same.")
            return false
        }
        else if txtDateOfBirth.text?.trimWhiteSpaces() == "" {
            self.showAlert("Alert!", message: "Please Select The Date of Birth.")
            return false
        }
        else if txtGender.text?.trimWhiteSpaces() == "" {
            self.showAlert("Alert!", message: "Please Select The Gender.")
            return false
        }
        
        return true
    }
}

//MARK: - Web Service Call For Login
extension SignUpVC {
    func SignUpAPICall() {
        
        self.goToAfterSignUpVC()
    }
    
    func goToAfterSignUpVC() {
        UserDefaults.standard.set(true, forKey: kIsLoggedIn)
        UserDefaults.standard.synchronize()
        
        if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "AfterLoginNavigation") as? UINavigationController,
            let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            appDelegate.window?.rootViewController = destinationVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}

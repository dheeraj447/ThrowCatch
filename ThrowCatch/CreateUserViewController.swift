//
//  CreateUserViewController.swift
//  ThrowCatch
//
//  Created by Kaveti, Dheeraj on 12/25/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FBSDKLoginKit
import MBProgressHUD

class CreateUserViewController: UIViewController, UITextFieldDelegate {
    let kgreenColor = UIColor(red: 34 / 255, green: 139 / 255, blue: 75 / 255, alpha: 1)
    @IBOutlet weak var passwordmadatory: UIImageView!
    
    @IBOutlet weak var emailMandatory: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameMandatory: UIImageView!
    @IBOutlet weak var firstMandatory: UIImageView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        firstNameTextField.layer.borderColor = UIColor.red.cgColor
        lastNameTextFeild.layer.borderColor = UIColor.red.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapOnCreate(_ sender: Any) {
        
        var isAlert = false
        emailMandatory.isHidden = true
        emailTextField.layer.borderColor = kgreenColor.cgColor
        if !isValidEmail(testStr: emailTextField.text!) {
            isAlert = true
            emailMandatory.isHidden = false
            emailTextField.layer.borderColor = UIColor.red.cgColor
            showAlert(message: "Please enter a valid email")
            return
        }
        
        SharedObject.sharedInstance().checkIfUserExists(emailId: emailTextField.text!, completionHandler: { (isExists) in
            if !isExists {
                self.passwordmadatory.isHidden = true
                self.passwordmadatory.layer.borderColor = self.kgreenColor.cgColor
                if !self.checkCount(testStr: self.passwordTextField.text!, length: 5) {
                    self.passwordmadatory.isHidden = false
                    self.passwordmadatory.layer.borderColor = UIColor.red.cgColor
                    if !isAlert {
                        isAlert = true
                        self.showAlert(message: "Password should be greater than 6 charecters")
                    }
                    return
                }
                
                self.firstMandatory.isHidden = true
                self.firstNameTextField.layer.borderColor = self.kgreenColor.cgColor
                if !self.checkCount(testStr: self.firstNameTextField.text!, length: 0) {
                    self.firstMandatory.isHidden = false
                    self.firstNameTextField.layer.borderColor = UIColor.red.cgColor
                    if !isAlert {
                        isAlert = true
                        self.showAlert(message: "Please enter First Name")
                    }
                    return
                }
                
                self.lastNameMandatory.isHidden = true
                self.lastNameMandatory.layer.borderColor = self.kgreenColor.cgColor
                if !self.checkCount(testStr: self.lastNameTextFeild.text!, length: 0) {
                    self.lastNameMandatory.isHidden = false
                    if !isAlert {
                        isAlert = true
                        self.lastNameMandatory.layer.borderColor = UIColor.red.cgColor
                        self.showAlert(message: "Please enter Last Name")
                    }
                    return
                }
                if !isAlert {
                    self.createUser()
                }
            }
            else {
                self.showAlert(message: "User already Registered")
            }
            
        })
        
    }
    
    func isValidEmail(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func checkCount(testStr: String, length: Int) -> Bool {
        // print("validate calendar: \(testStr)")
        return testStr.characters.count > length
    }
    
    @IBAction func didTapOnShowPassowrd(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = true
        if sender.isSelected {
            passwordTextField.isSecureTextEntry = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // let cs = CharacterSet.alphanumerics.inverted
        if textField.tag == 3 || textField.tag == 2 {
            let set = NSCharacterSet.alphanumerics
            let cs = set.inverted
            let filtered = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0 {
            switch textField.tag {
            case 0:
                emailMandatory.isHidden = true
                emailTextField.layer.borderColor = kgreenColor.cgColor
                
                if !isValidEmail(testStr: emailTextField.text!) {
                    emailTextField.layer.borderColor = UIColor.red.cgColor
                    emailMandatory.isHidden = false
                }
                passwordTextField.becomeFirstResponder()
            case 1:
                passwordmadatory.isHidden = true
                self.passwordTextField.layer.borderColor = kgreenColor.cgColor
                if !checkCount(testStr: passwordTextField.text!, length: 5) {
                    self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                    passwordmadatory.isHidden = false
                }
                firstNameTextField.becomeFirstResponder()
            case 2:
                firstMandatory.isHidden = true
                self.firstNameTextField.layer.borderColor = kgreenColor.cgColor
                if !checkCount(testStr: firstNameTextField.text!, length: 0) {
                    
                    self.firstNameTextField.layer.borderColor = UIColor.red.cgColor
                    firstMandatory.isHidden = false
                }
                lastNameTextFeild.becomeFirstResponder()
            case 3:
                lastNameMandatory.isHidden = true
                self.lastNameTextFeild.layer.borderColor = kgreenColor.cgColor
                
                if !checkCount(testStr: lastNameTextFeild.text!, length: 0) {
                    lastNameMandatory.isHidden = false
                    self.lastNameTextFeild.layer.borderColor = UIColor.red.cgColor
                }
                self.didTapOnCreate(textField)
            default:
                break
            }
            return true
        }
        return false
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cencelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            
        }
        alertController.addAction(cencelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func didTapOnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func createUser() {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print("unable to authenticateuser creation error:", (error?.localizedDescription)!)
            } else {
                let userObj = User(userId: (user?.uid)!, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextFeild.text!, emailId: self.emailTextField.text!)
                
                let msg = [
                    "email": userObj.emailId as Any,
                    "userId": userObj.userId as Any,
                    "firstName": userObj.firstName as Any,
                    "lastName": userObj.lastName as Any,
                ] as [String: Any]
                
                let fireMsg = DataService.ds.USER_DB_REF.childByAutoId()
                fireMsg.setValue(msg)
                print("sucessfully user created")
                
                self.dismiss(animated: true, completion: {
                    
                })
                
            }
        })
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

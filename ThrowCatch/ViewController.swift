//
//  ViewController.swift
//  ThrowCatch
//
//  Created by Kaveti, Dheeraj on 12/18/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FBSDKLoginKit
import MBProgressHUD
class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    weak var actionToEnable: UIAlertAction?
    
    var loginButton = FBSDKLoginButton()
    
    var userDict = [String: AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnFb.layer.cornerRadius = btnFb.frame.height / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    @IBAction func loginFB(_ sender: Any) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) {
            (result, error) in
            if error != nil {
                print("KD:unable to authenticate with Facebook", error)
            } else if result?.isCancelled == true {
                print("user cancelled")
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                print("sucess facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential, fromFaceBook: true)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential, fromFaceBook: Bool) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                MBProgressHUD.hide(for: self.view, animated: true)
                print("unable to sign in \(error)")
            } else {
                SharedObject.sharedInstance().checkIfUserExists(userId: (user?.uid)!, completionHandler: { (isUserExists) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if fromFaceBook && isUserExists {
                        if SharedObject.sharedInstance().currentUser.firstName == nil && SharedObject.sharedInstance().currentUser.lastName == nil {
                            self.addFirstNameLastName(userId: (user?.uid)!, emailId: (user?.email)!)
                            return
                        }
                    }
                    else {
                        self.showThrowCatch()
                    }
                    
                })
            }
        })
    }
    
    @IBAction func didTapOnSignIn(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text, (emailField.text?.characters.count)! > 0, (passwordField.text?.characters.count)! > 0 {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("email auth susessful")
                    SharedObject.sharedInstance().checkIfUserExists(userId: (user?.uid)!, completionHandler: { (isUserExists) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if SharedObject.sharedInstance().currentUser.firstName == nil && SharedObject.sharedInstance().currentUser.lastName == nil {
                            self.addFirstNameLastName(userId: (user?.uid)!, emailId: (user?.email)!)
                            return
                        }
                        else {
                            self.showThrowCatch()
                        }
                        
                    })
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let alertController = UIAlertController(title: "No Email registered with this account", message: "Do you want to create a Account?", preferredStyle: .alert)
                    let cencelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
                        
                    }
                    alertController.addAction(cencelAction)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        self.showCreate()
                    }
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    @IBAction func didTapOnSignup(_ sender: Any) {
        self.showCreate()
    }
    
    func showCreate() {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserViewController") as! CreateUserViewController
        newVC.modalPresentationStyle = .overCurrentContext
        self.present(newVC, animated: true, completion: nil)
    }
    
    func showThrowCatch() {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ThrowCatchViewController") as! ThrowCatchViewController
        
        // let navigationController = UINavigationController(rootViewController: newVC)
        /*let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
         appDel.window?.rootViewController = newVC*/
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func addFirstNameLastName(userId: String, emailId: String) {
        
        let alertController = UIAlertController(title: "Please Add your First Name Last Name to Complete Process", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            let userObj = User(userId: userId, firstName: firstTextField.text!, lastName: secondTextField.text!, emailId: emailId)
            
            let msg = [
                "email": userObj.emailId as Any,
                "userId": userObj.userId as Any,
                "firstName": userObj.firstName as Any,
                "lastName": userObj.lastName as Any,
            ] as [String: Any]
            
            let fireMsg = DataService.ds.USER_DB_REF.childByAutoId()
            fireMsg.setValue(msg)
            
            SharedObject.sharedInstance().currentUser = userObj
            
        })
        
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            textField.placeholder = "Enter First Name"
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            textField.placeholder = "Enter Last Name"
        }
        
        alertController.addAction(saveAction)
        self.actionToEnable = saveAction
        saveAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textChanged(_ sender: UITextField) {
        self.actionToEnable?.isEnabled = (sender.text!.characters.count > 0)
    }
}


//
//  LoginViewController.swift
//  realtimeapp
//
//  Created by Vik Denic on 1/29/16.
//  Copyright © 2016 nektar labs. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    var firebase = Firebase(url: "https://nektar-realtimeapp.firebaseio.com/")

    var username: String?
    var isNewUser = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLoginTapped(sender: UIButton) {
        loginUser()
    }

    @IBAction func onSignUpTapped(sender: UIButton) {
        if fieldFilled() {
            firebase.createUser(emailTextField.text, password: passwordTextField.text) { (error: NSError!) -> Void in
                if error != nil {
                    print(error.localizedDescription)
                    self.displayErrorMessage(error)
                } else {
                    print("new user created")
                    self.requestUsername()
                }
            }
        }
    }

    func loginUser() {
        if fieldFilled() {
            print("start logging user")
            firebase.authUser(emailTextField.text, password: passwordTextField.text) { (error: NSError!, authData: FAuthData!) -> Void in
                if error != nil {
                    print(error.localizedDescription)
                    self.displayErrorMessage(error)
                } else {
                    if self.isNewUser {
                        self.firebase.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(["isOnline" : true, "name" : self.username!])
                    } else {
                        self.firebase.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(["isOnline" : true])
                    }

                    print("user logged \(authData.description)")
                    self.performSegueWithIdentifier("mainSegue", sender: self)
                }
            }
        }
    }

    func fieldFilled() -> Bool {
        if ((!emailTextField.text!.isEmpty) && (!passwordTextField.text!.isEmpty)) {
            return true
        } else {
            print("Empty field was found")
            return false
        }
    }

    func displayErrorMessage(error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(okAction)

        presentViewController(alert, animated: true, completion: nil)
    }

    func requestUsername() {
        var usernameTextField: UITextField?
        let alert = UIAlertController(title: "Enter Username", message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Enter Username", style: .Default) { (action) -> Void in
            if let someText = usernameTextField?.text {
                self.isNewUser = true
                self.username = someText
                self.loginUser()
            }
        }
        alert.addAction(okAction)

        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            usernameTextField = textField
        }

        presentViewController(alert, animated: true, completion: nil)
    }
}

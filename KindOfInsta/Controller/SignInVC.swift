//
//  ViewController.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 14.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Jakub: Unable to auth with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {  // that means: if we don't have an error something else may appear
                print("Jakub: User Cancelled FB authentication")
            } else {
                print("Jakub: Succesfullty authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Jakub: Unable to auth with Firebase -\(String(describing: error))")
            } else {
                print("Jakub: Successfully authenticated with Firebase")
            }
        })
    }

    @IBAction func signInPressed(_ sender: Any) {
                            // first like always check if there is any text in text fields
        if let email = emailField.text, email != "", let password = passwordField.text, password != "" {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil { // thats means that email and pass is correct and we have that user
                    print("Jakub: Email User authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Jakub: Unable to authenticate with Firebase using email")
                        } else {
                            print("Jakub: Successfuky authenticated with Firebase")
                        }
                    })
                }
            })
        }
    }
    
}




















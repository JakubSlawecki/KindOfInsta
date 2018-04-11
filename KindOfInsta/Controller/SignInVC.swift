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
import SwiftKeychainWrapper


class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    

    override func viewDidLoad() {                   // Segue can not be in viewDidLoad, it's too early !
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {   // that's better place for Segue
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)   // If there is uid in keychain it will performe Segue to the FeedVC
        }
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
                if let user = user {
                    let userData = ["provider": credential.provider]  // for firebase database provider is Facebook in that case so credential provider
                    self.completeSignIN(id: user.uid, userData: userData) // save that id to keychain
                }
                
            }
        })
    }

    @IBAction func signInPressed(_ sender: Any) {
                            // first like always check if there is any text in text fields
        if let email = emailField.text, email != "", let password = passwordField.text, password != "" {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil { // thats means that email and pass is correct and we have that user
                    print("Jakub: Email User authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIN(id: user.uid, userData: userData) // save that id to keychain
                    }
                    
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Jakub: Unable to authenticate with Firebase using email")
                        } else {
                            print("Jakub: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIN(id: user.uid, userData: userData) // save that id to keychain
                            }
                        }
                    })
                }
            })
        }
    }
   
    
    func completeSignIN(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Jakub: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil) // it will performe Segue to FeedVC if credentials
    }
    
    
}




















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
    

    override func viewDidLoad() {                    // remember this error, Segue can not be in viewDidLoad, it is too early for that
        
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {                      // ...a better place for Segue
       
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "goToProfileVC", sender: nil)   // if there is an uid in keychain then it will do Segue to FeedVC
        }
    }
    
   
    @IBAction func facebookBtnPressed(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("Jakub: Unable to auth with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {                     // it means that if there is no error then it can continue
               
                print("Jakub: User Cancelled FB authentication")
            } else {
                
                print("Jakub: Succesfullty authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    
    

    @IBAction func signInPressed(_ sender: Any) {
                            // to start with, as always, check if there is text in the fields
        if let email = emailField.text, email != "", let password = passwordField.text, password != "" {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {           // it means that the email and password are correct and I have this user in the database
                    
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
    
    func completeSignIN(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
//        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
//        print("Jakub: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToProfileVC", sender: id)  // it will do Segue to AddProfileImageVC if credentials will be ok
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
   
    // this function will send id and sender to AddProfileImageVC as "profileId"
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "goToProfileVC" && sender != nil {
                
                let destinationVC = segue.destination as? AddProfileImgVC
                destinationVC?.profileId = sender as! String
            }
        }
    }
    
    
}




















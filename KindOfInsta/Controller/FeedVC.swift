//
//  FeedVC.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 20.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVIew.delegate = self
        tableVIew.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value) { (snapshot) in
            print(snapshot.value as Any)  // this will observe for any changes in database !
        }
       
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableVIew.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    
    
    
    
    
    
    
    
                            // to sign out i need to remove id from Keychain and sign out from Firebase
    @IBAction func signOutBtn(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Jakub: ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}

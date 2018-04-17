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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addProfileImage: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var profileImagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    static var profileImageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableVIew.delegate = self
        tableVIew.dataSource = self
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true // that's nice!
        imagePicker.delegate = self
        
                                // this will observe if there are changes in the database
        DataService.ds.REF_POSTS.observe(.value) { (snapshot) in
            print(snapshot.value as Any) // only for checking
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                   
                    print("Snap: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.insert(post, at: 0)      // attach a new post to posts array as it goes through this loop
                    }
                }
                self.tableVIew.reloadData()
            }
        }
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableVIew.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                
                cell.configureCell(post: post)
                return cell
            }
        } else {
            
            return PostCell()
        }
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            addImage.image = image
            imageSelected = true
        } else {
            print("Jakub: the photo has not been selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
   
    
    
    
    @IBAction func postBtnPressed(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            
            print("Jakub: caption must be entered")
            return
        }
        guard let img = addImage.image, imageSelected == true else {
            
            print("Jakub: the photo must be selected")
            return
        }

        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            // The UUIDString creates a unique name for the photo file, due to the fact that each photo will have to have a unique name
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    
                    print("Jakub: Unable to upload image to Firebase Storage")
                } else {
                   
                    print("Jakub: Successfully uploaded image to Firebase Storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        
                        self.postToFirebase(imageUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        captionField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "addImage")
    }
    
    
    @IBAction func addImagePressed(_ sender: Any) {
       
        present(imagePicker, animated: true, completion: nil)
    }
    
    
                                    // to log out I have to remove id from keychain and log out of firebase
    @IBAction func signOutBtn(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Jakub: ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    
}














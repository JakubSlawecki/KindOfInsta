//
//  AddProfileImgVC.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 06.04.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class AddProfileImgVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicker: FancyProfileImage!
    @IBOutlet weak var displayName: FancyField!
    
    
    var imgPickerController: UIImagePickerController!
    var imagePicked = false
    var profileId: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPickerController = UIImagePickerController()
        imgPickerController.allowsEditing = true
        imgPickerController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "goToFeedVC", sender: nil)  // id profile already exists, do Segue to FeedVC
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imagePicker.image = selectedImage
            imagePicked = true
        } else {
            
            print("Jakub: invalid profile image selected")
        }
        imgPickerController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func arrowBtnPressed(_ sender: Any) {
        
        guard let profileImage = imagePicker.image, imagePicked else {
           
            print("Jakub: Profile image not selected")
            return
        }
        
        guard let userDisplayName = displayName.text else {
            
            print("Jakub: Display name cannot be empty")
            return
        }
        
        if let profileImageData = UIImageJPEGRepresentation(profileImage, 0.2) {
            
            let profileImgUid = NSUUID().uuidString
            let profileImgMeta = StorageMetadata()
            profileImgMeta.contentType = "image/jpeg"
            dismissKeyboard()
            DataService.ds.REF_POST_IMAGES.child(profileImgUid).putData(profileImageData, metadata: profileImgMeta) { (metadata, error) in
                if error != nil {
                    
                    print("Jakub: unable to upload profile image")
                } else {
                    
                    print("Jakub: successfully uploaded profile image")
                    if let profileImgURL = metadata?.downloadURL()?.absoluteString {
                        
                        self.saveProfileInfo(userDisplayName, profileImgURL)
                    }
                }
            }
        }
    }
    
    
    func saveProfileInfo(_ userDisplayName: String, _ profileImgURL: String) {
        
        let currentUserRef = DataService.ds.REF_USERS.child(profileId)
        currentUserRef.child("display_name").setValue(userDisplayName)
        currentUserRef.child("image_url").setValue(profileImgURL)
        let keychainResult = KeychainWrapper.standard.set(profileId, forKey: KEY_UID)
        print("Jakub: Keychain result save status: \(keychainResult)")
        performSegue(withIdentifier: "goToFeedVC", sender: nil)
    }
    
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    
    @IBAction func imagePickerTapped(_ sender: Any) {
       
        present(imgPickerController, animated: true, completion: nil)
    }
    
}


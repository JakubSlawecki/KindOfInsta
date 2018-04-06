//
//  AddProfileImgVC.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 06.04.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import Firebase

class AddProfileImgVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addProfileImgField: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

       
    }
    // to be continued
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let FeedViewController: FeedVC = segue.destination as! FeedVC
//
//        FeedViewController.addProfileImage.image = addProfileImgField.image
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addProfileImgField.image = image
        } else {
            print("Jakub: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func addProfileImgFieldPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    

   
}

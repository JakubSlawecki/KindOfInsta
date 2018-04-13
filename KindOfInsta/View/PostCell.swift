//
//  PostCell.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 23.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var post: Post!
    var likesRef: DatabaseReference!
    var uploaderRef: DatabaseReference!
    
    let currentUserProfileId = KeychainWrapper.standard.string(forKey: KEY_UID)
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil, userImg: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes) likes"
        
        uploaderRef = DataService.ds.REF_USERS.child(self.post.uploadedByUser)
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 4 * 5000 * 5000, completion: { (data, error) in
                if error != nil {
                    print("Jakub: Ubable to download image from Firebase Storage")
                } else {
                    print("Jakub: Image downloaded from Firebase Storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            
                        }
                    }
                }
            })
        }
        
        if post.uploadedByUser == currentUserProfileId {
            deleteBtn.isHidden = false
        } else {
            deleteBtn.isHidden = true
        }
        
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heartIcon")
            } else {
                self.likeImg.image = UIImage(named: "heartIconblack")
            }
        }
        
        uploaderRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let uploaderImg = snapshot.childSnapshot(forPath: "image_url").value as? String {
                let storageRef = Storage.storage().reference(forURL: uploaderImg)
                storageRef.getData(maxSize: 10 * 1024 * 1024, completion: {(data, error) in
                    
                    if error != nil {
                        print("Jakub: Unable to download profile image from firebase: \(String(describing: error))")
                    } else {
                        print("Jakub: Profile image downloaded from firebase")
                        
                        if let profileImgData = data {
                            if let actualImg = UIImage(data: profileImgData) {
                                self.profileImg.image = actualImg
                            }
                        }
                    }
                })
            }
            
            if let uploaderName = snapshot.childSnapshot(forPath: "display_name").value as? String {
                self.usernameLbl.text = uploaderName
            }
        })
    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heartIconblack")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                
            } else {
                self.likeImg.image = UIImage(named: "heartIcon")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        if !deleteBtn.isHidden {
            DataService.ds.REF_POSTS.child(post.postKey).removeValue()
        } else {
            print("Jakub: You can't delete others posts")
        }
    }
    
    
}












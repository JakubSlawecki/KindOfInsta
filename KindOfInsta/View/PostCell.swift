//
//  PostCell.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 23.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var likesRef: DatabaseReference!
    
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
        
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heartIcon")
            } else {
                
                self.likeImg.image = UIImage(named: "heartIconblack")
            }
        }
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
    
}












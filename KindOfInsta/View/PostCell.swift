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
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil, userImg: UIImage? = nil) {
        self.post = post
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
        
        
        if userImg != nil {
            self.profileImg.image = userImg
        } else {
            let ref = Storage.storage().reference(forURL: post.profileImageUrl)
            ref.getData(maxSize: 4 * 5000 * 5000, completion: { (data, error) in
                if error != nil {
                    print("Jakub: Ubable to download ProfileImage from Firebase Storage")
                } else {
                    print("Jakub: Profile Image downloaded from Firebase Storage")
                    if let profileImgData = data {
                        if let profileImg = UIImage(data: profileImgData) {
                            self.profileImg.image = profileImg
                            FeedVC.profileImageCache.setObject(profileImg, forKey: post.profileImageUrl as NSString)
                        }
                    }
                    
                }
            })
        }
    }
    
}












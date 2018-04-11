//
//  Post.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 28.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _profileImageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
//    var profileImageUrl: String {
//        return _profileImageUrl
//    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    
    
    init(caption: String, imageUrl: String, profileImageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._profileImageUrl = profileImageUrl
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) { // this ll convert firebase data into something that I can use ;)
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let profileImageUrl = postData["profileImageUrl"] as? String {
            self._profileImageUrl = profileImageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
        
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
    _postRef.child("likes").setValue(_likes)
    }
}






















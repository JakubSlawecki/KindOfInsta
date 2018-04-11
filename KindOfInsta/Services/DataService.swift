//
//  DataService.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 26.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()  // that is the top of my Databese in URL
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // Databasese refernces
    private var _REF_BASE = DB_BASE // I will not probably need that but we'll see
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    // Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("profile-pics")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!) // will need to change that force unwraping soon!
        return user
    }
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: StorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    
    
    // user from authetnication is seperate thing that user from firebase database! That's why I'll call them DBUser etc
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) { // uid is our user and userData ll be our "provider"
        REF_USERS.child(uid).updateChildValues(userData)  // if user it's not there, firebase will automaticly create one in database!
    }
    
    
    
    
    
    
    
    
    
}



















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

let DB_BASE = Database.database().reference()  // this is the "highest position" in my database in URL
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // Databasese refernces
    private var _REF_BASE = DB_BASE // I probably will not need it, but who knows
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
        let user = REF_USERS.child(uid!) // I will have to change this force unpacking soon
        return user
    }
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: StorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    
    
    // the user from the aunteification it's different from another user from the firebase database! That's why I'll call them DBUser etc
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) { // uid will be our user and userData will be the "provider"
        REF_USERS.child(uid).updateChildValues(userData)  // if the user is not in the database, firebase will create it automatically!
    }
    
    
}



















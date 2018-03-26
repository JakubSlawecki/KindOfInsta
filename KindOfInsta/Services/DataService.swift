//
//  DataService.swift
//  KindOfInsta
//
//  Created by Jakub Slawecki on 26.03.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()  // that is the top of my Databese in URL

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE // I will not probably need that but we'll see
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    // user from authetnication is seperate thing that user from firebase database! That's why I'll call them DBUser etc
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) { // uid is our user and userData ll be our "provider"
        REF_USERS.child(uid).updateChildValues(userData)  // if user it's not there, firebase will automaticly create one in database!
    }
    
    
    
    
    
    
    
    
    
}



















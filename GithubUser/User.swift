//
//  User.swift
//  GithubUser
//
//  Created by Michael Nikitochkin on 8/10/14.
//  Copyright (c) 2014 JetThoughts. All rights reserved.
//

class User {
    
    var login: String
    var score: Double
    var avatarUrl: String
    var profileUrl: String
    
    init (login: String, score: Double, avatarUrl: String, profileUrl: String) {
        self.login = login
        self.score = score
        self.avatarUrl = avatarUrl
        self.profileUrl = profileUrl
        
    }
    
}
//
//  UserSingleton.swift
//  SnapChat
//
//  Created by Can Kanbur on 6.04.2023.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init(){
        
    }
}

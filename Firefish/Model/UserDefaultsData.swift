//
//  UserDefaultsData.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import Foundation

class UserDefaultsData {
    
    fileprivate var standardUserDefaults = UserDefaults.standard
    
    func setUserName (_ userName : String ){
        standardUserDefaults.set(userName, forKey: UserDefaultConstants.USER_NAME)
    }
    
    func setUserToken (_ userUserToken : String ){
        standardUserDefaults.set(userUserToken, forKey: UserDefaultConstants.USER_TOKEN)
    }
    
    func setUserPassword (_ userPassword : String ){
        standardUserDefaults.set(userPassword, forKey: UserDefaultConstants.USER_PASSWORD)
    }
    
    // getter methods
    
    func getUserName () -> String {
        guard standardUserDefaults.string(forKey: UserDefaultConstants.USER_NAME) == nil else {
            return standardUserDefaults.string(forKey: UserDefaultConstants.USER_NAME)!
        }
        return ""
    }
    
    func getUserToken () -> String {
        guard standardUserDefaults.string(forKey: UserDefaultConstants.USER_TOKEN) == nil else {
            return standardUserDefaults.string(forKey: UserDefaultConstants.USER_TOKEN)!
        }
        return ""
    }
    
    func getUserPassword () -> String {
        guard standardUserDefaults.string(forKey: UserDefaultConstants.USER_PASSWORD) == nil else {
            return standardUserDefaults.string(forKey: UserDefaultConstants.USER_PASSWORD)!
        }
        return ""
    }
}

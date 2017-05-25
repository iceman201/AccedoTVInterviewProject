//
//  User.swift
//  Colour memory
//
//  Created by Liguo Jiao on 26/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import Foundation

private let _UserSharedInstance = User()

class User: NSObject {
    class var sharedInstance: User {
        return _UserSharedInstance
    }
    
}

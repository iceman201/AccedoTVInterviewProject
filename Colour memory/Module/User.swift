//
//  User.swift
//  Colour memory
//
//  Created by Liguo Jiao on 26/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import Foundation
import RealmSwift

private let _UserSharedInstance = User()

class User: Object {
    class var sharedInstance: User {
        return _UserSharedInstance
    }
    dynamic var id = 0
    dynamic var name = ""
    dynamic var points = 0
    dynamic var recordDate = NSDate()
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func increaseID() -> Int {
        let realm = try! Realm()
        let RetNext: Array = Array(realm.objects(User.self).sorted(byKeyPath: "id"))
        let last = RetNext.last
        if RetNext.count > 0 {
            let valor = last?.value(forKey: "id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
    
    func objectExist (id: String) -> Bool {
        return realm!.object(ofType: User.self, forPrimaryKey: id) != nil ? true : false
    }
    
    func checkNameExist(inputName: String) -> Bool {
        let realm = try! Realm()
        let RetNext: Array = Array(realm.objects(User.self).sorted(byKeyPath: "name"))
        if RetNext.contains(where: { user in user.name == inputName }) {
            return true
        } else {
            return false
        }
    }
    
    
}

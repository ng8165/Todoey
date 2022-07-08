//
//  Item.swift
//  Todoey
//
//  Created by Nelson Gou on 7/7/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    convenience init(title: String, done: Bool) {
        self.init()
        
        self.title = title
        self.done = done
    }
}

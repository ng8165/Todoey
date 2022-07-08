//
//  Category.swift
//  Todoey
//
//  Created by Nelson Gou on 7/7/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
    convenience init(name: String) {
        self.init()
        
        self.name = name
    }
}

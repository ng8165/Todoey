//
//  Item.swift
//  Todoey
//
//  Created by Nelson Gou on 7/5/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

class Item {
    var title: String
    var done: Bool
    
    init() {
        title = ""
        done = false
    }
    
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}

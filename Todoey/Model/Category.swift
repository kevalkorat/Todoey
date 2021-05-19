//
//  Category.swift
//  Todoey Realm
//
//  Created by Keval Korat on 5/15/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
}

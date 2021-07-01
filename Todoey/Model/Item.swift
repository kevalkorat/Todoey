//
//  Item.swift
//  Todoey Realm
//
//  Created by Keval Korat on 5/15/21.
//  Copyright © 2021 Keval Korat. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

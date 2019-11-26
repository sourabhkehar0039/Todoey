//
//  Item.swift
//  Todoey
//
//  Created by Sourabh kehar on 2019-11-24.
//  Copyright © 2019 Sourabh kehar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

//
//  Category.swift
//  Todoey
//
//  Created by Sourabh kehar on 2019-11-24.
//  Copyright © 2019 Sourabh kehar. All rights reserved.
//

import Foundation
import  RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    let  items = List<Item>()
    
}

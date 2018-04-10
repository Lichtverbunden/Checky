//
//  Item.swift
//  Checky
//
//  Created by Ken Krippeler on 02.04.18.
//  Copyright © 2018 Lichtverbunden. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

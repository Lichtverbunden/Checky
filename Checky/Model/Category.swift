//
//  Category.swift
//  Checky
//
//  Created by Ken Krippeler on 02.04.18.
//  Copyright © 2018 Lichtverbunden. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

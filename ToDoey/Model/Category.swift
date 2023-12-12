//
//  Category.swift
//  ToDoey
//
//  Created by Atakan Başaran on 9.12.2023.
//

import Foundation
import RealmSwift

class Category: Object { //We inherit object class to define this class in Realm
    
    @objc dynamic var name: String = ""
    @objc dynamic var redNo: Float = 0
    @objc dynamic var blueNo: Float = 0
    @objc dynamic var greenNo: Float = 0
    @objc dynamic var favorite: Bool = false
    let items = List<Item>() //Empty list of Item objects to set up a one to many relationship between them like we did in the core Data
}

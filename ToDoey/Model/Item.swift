//
//  Item.swift
//  ToDoey
//
//  Created by Atakan Başaran on 9.12.2023.
//

import Foundation
import RealmSwift


class Item: Object {
    
    @objc dynamic var title: String = "" //@objc dynamic is used to save our data to realm
    @objc dynamic var done: Bool = false
    @objc dynamic var favorite: Bool = false
    @objc dynamic var date: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //We set up inverse relationship to the Category class, "items" is in the categoy file
    //Category.self -> type needed, Category -> class, fromType -> its destination, property -> let items = List<Item>() inside Category class
}


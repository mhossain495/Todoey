//
//  Item.swift
//  Todoey
//
//  Created by Mohammed Hossain on 10/13/20.
//  Copyright © 2020 Mohammed Hossain. All rights reserved.
//

import Foundation

// Class for to do item and whether task is completed

class Item: Encodable {
    
    var title: String = ""
    var done: Bool = false
}

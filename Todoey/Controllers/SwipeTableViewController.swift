//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by shanaaz begum on 10/25/20.
//  Copyright © 2020 Mohammed Hossain. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        // Item constant for reusability. IndexPath.row is index number of selected category row
        //let category = categoryArray[indexPath.row]
        
        // Populate cell of TableView with elements of array
        //cell.textLabel?.text = category.name
 
        cell.delegate = self
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            
            
            // Allows user to select trash icon to delete row after swiping from right side
            //self.categoryArray.remove(at: indexPath.row)
            action.fulfill(with: .delete)

        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    // Method to delete category row by swiping across screen
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        return options
        
    }
    
    func updateModel(at indexPath: IndexPath) {
    }

    
}

//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mohammed Hossain on 10/19/20.
//  Copyright © 2020 Mohammed Hossain. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    var categoryArray = [Category]()
    
    // Access to context of persistent container to allow app to interact with database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set reusable cell separator style when adding background color
        tableView.separatorStyle = .none
        
        loadCategories()
    }


    
    //MARK: - TableView Datasource Methods
    
    
    // Set number of sections in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Determine number of rows for table view based on number of categories in array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    


    // Display array data in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Create reusable swipe cell and add to table at indexPath
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        
        // Item constant for reusability. IndexPath.row is index number of selected category row
        let category = categoryArray[indexPath.row]
        
        // Populate cell of TableView with elements of array
        cell.textLabel?.text = category.name
        
        //cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
       // cell.delegate = self
        
        // Change cell background color
        //cell.backgroundColor = UIColor(hexString: <#T##String#>)
        
        return cell
        
    }
 
    
    
    
    //MARK: - TableView Delegate Methods
      
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    // Save new category in context, a temporary area that tracks changes
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        // Populate table with newly added category in array
        tableView.reloadData()
    }
    
    // Default request to load all categories from database into categoryArray
    func loadCategories() {
        
    let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        // Reloads the rows of table view and redisplays updates to data
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        // Delete category from context before saving and removing from array to avoid crash
        context.delete(categoryArray[indexPath.row] as NSManagedObject)
        saveCategories()
        
        // Allows user to select trash icon to delete row after swiping from right side
        self.categoryArray.remove(at: indexPath.row)
        super.updateModel(at: indexPath)
    }
    
    
    
    //MARK: - Add New Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        // 1. Create the alert controller
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // 2. Action when user clicks the Add button
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // When user clicks the Add button on UIAlert, new NSManagedObject or row is created
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!

    
            
            self.categoryArray.append(newCategory)
            
            // Call function to encode new category data, save to directory, and reload data
            self.saveCategories()
            
        }
        // 3. Add a text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
            
        }
        
        // 4. Present the alert
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
    
    
    
    
}


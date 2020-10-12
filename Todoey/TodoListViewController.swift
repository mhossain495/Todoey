//
//  TodoListViewControllerswift
//  Todoey
//


import UIKit

class TodoListViewController: UITableViewController {
    
    // Create instance of UserDefaults class
    let defaults = UserDefaults.standard
    
    var itemArray = ["Laundry", "Buy groceries", "Practice coding"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UserDefaults to load array of saved data
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }

    //Mark - Tableview Datasource Methods
    
    
    // Set number of sections in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Determine number of rows for table view based on number of items in array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Display array data in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as UITableViewCell
        
        // Populate cell of TableView with elements of array
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    // Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // Add checkmark when selecting cell or remove checkmark if already checked
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
        
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // 1. Create the alert controller
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // 2. Action when user clicks the Add Item button
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // When user clicks the Add Item button on UIAlert, the new item gets added to array
            self.itemArray.append(textField.text!)
            
            // Store newly added item and array to UserDefaults with unique key TodoListArray
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Populate table with newly added item in array
            self.tableView.reloadData()
        }
        // 3. Add a text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        // 4. Present the alert
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    

}


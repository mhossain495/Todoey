//
//  TodoListViewControllerswift
//  Todoey
//


import UIKit

class TodoListViewController: UITableViewController {
    
    // Create instance of UserDefaults class
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UserDefaults to load array of saved data
        let newItem = Item()
        newItem.title = "Do Laundry"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Write Code"
        itemArray.append(newItem2)
        
        
        //if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            //itemArray = items
       // }
    }

    //MARK: - Tableview Datasource Methods
    
    
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
        
        // Item constant for reusability
        let item = itemArray[indexPath.row]
        
        // Populate cell of TableView with elements of array
        cell.textLabel?.text = item.title
        
        // Ternary operator instead of if else statement to display checkmark when selecting cell or remove checkmark if already checked
        // value = check whether condition is true ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
    
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // Add or remove check mark to selected to do item by inverting .done property Bool value
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        // Reload table data to reflect check mark changes
        tableView.reloadData()
        
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
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
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


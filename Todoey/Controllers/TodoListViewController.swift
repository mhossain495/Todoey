//
//  TodoListViewControllerswift
//  Todoey
//


import UIKit

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    // Create file path to Documents directory
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        loadItems()
        
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
         //   itemArray = items
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
        
        // Call function to reload table data to reflect check mark changes
        saveItems()
        
        // Change background view of cell
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
            
            // Call function to encode new item data, save to directory, and reload data
            self.saveItems()
            
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
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
       
        // Encode new item data to be written to plist, save to directory, and reload data
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        // Populate table with newly added item in array
        self.tableView.reloadData()
    }
    
    // Load decoded data from plist
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

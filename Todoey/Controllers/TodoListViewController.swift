//
//  TodoListViewControllerswift
//  Todoey
//


import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
  
    // Access to context of persistent container to allow app to interact with database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
        // Item constant for reusability. IndexPath.row is index number of selected to do item row
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
        
        // Delete selected item from context and array; saveItems function will commit delete to be reflected
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        
        // Add or remove check mark to selected to do item by inverting .done property Bool value
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Call function to commit changes and reload table data to reflect check mark changes
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
            
            // When user clicks the Add Item button on UIAlert, new NSManagedObject or row is created
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
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
    
    // Save new to do item in context, a temporary area that tracks changes to item properties
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // Populate table with newly added item in array
        self.tableView.reloadData()
    }
    
    // Load data from database into itemArray at startup
    func loadItems() {
        // Fetch all data of type Item
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
}


}

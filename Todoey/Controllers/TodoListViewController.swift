//
//  TodoListViewControllerswift
//  Todoey
//


import UIKit
import CoreData
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var itemArray = [Item]()
    
    // Call loadItems once selectedCategory is set with a value
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
  
    // Access to context of persistent container to allow app to interact with database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.separatorStyle = .none
        
        

    }

    // Set navigation bar color to match category cell color
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.color {
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            
            navBar.backgroundColor = UIColor(hexString: colorHex )
        }
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Item constant for reusability. IndexPath.row is index number of selected category row
        let item = itemArray[indexPath.row]
        
        // Populate cell of TableView with elements of array
        cell.textLabel?.text = item.title
        
        // Set gradient background color of to do item cells to color of category cells
        if let color = UIColor(hexString: selectedCategory!.color!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray.count)) {
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell

    }
    
    
 
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        // Add or remove check mark to selected to do item by inverting .done property Bool value
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Call function to commit changes and reload table data to reflect check mark changes
        saveItems()
        
        // Change background view of cell to remove gray background when selecting cell
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
            newItem.parentCategory = self.selectedCategory
            
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
    
    // Default request to load all items from database into itemArray
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // Load results where parentCategory matches selected Category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        // Reloads the rows of table view and redisplays updates to data
        tableView.reloadData()
    }
    
    // Delete selected item from context and array; saveItems function will commit delete to be reflected

    override func updateModel(at indexPath: IndexPath) {
        
        // Delete item from context before saving and removing from array to avoid crash
        context.delete(itemArray[indexPath.row] as NSManagedObject)
        saveItems()
        
        // Allows user to select trash icon to delete row after swiping from right side
        self.itemArray.remove(at: indexPath.row)
        super.updateModel(at: indexPath)
    }
    
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Set predicate to search for items in database; %@ = searchBart.text
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // [cd] = case and diacritic insensitive
        
        // Sort search reasults by alphabetical order
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        // Pass request to loadItems function to fetch sorted results data
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // If search bar is empty then load original data and resign keyboard
        if searchBar.text?.isEmpty == true {
            loadItems()
            
            // Use DispatchQueue to run code in main queue
            DispatchQueue.main.async {
                // Dismiss search bar as the active item and dismiss keyboard
                searchBar.resignFirstResponder()
                
            }
            
        // If search bar is not empty, then search while user is entering text
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            // Set predicate to search for items in database; %@ = searchBart.text
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // [cd] = case and diacritic insensitive
            
            // Sort search reasults by alphabetical order
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            // Pass request to loadItems function to fetch sorted results data
            loadItems(with: request)
        }
    }
    
}
